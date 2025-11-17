<?php
ob_start(); // Buffer output to prevent headers issues from any early echoes/warnings
ini_set('display_errors', 1);
error_reporting(E_ALL);

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}
// After successful login verification in other pages
if (!isset($_SESSION['hr_system_user_id'])) {
    $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
    $_SESSION['hr_system_username'] = $_SESSION['user_name'];
    $_SESSION['hr_system_user_role'] = $_SESSION['user_role'];
}

require_once 'auth_check.php';
require_once 'config.php';
require_once 'auth.php';
if (!hasPermission('hr_manager')) {
    header("Location: dashboard.php");
    exit();
}

// ================================
// LOAN DEDUCTION CALCULATION
// ================================
function calculateLoanDeduction($conn, $loan) {
    $remaining_balance = (float)$loan['remaining_balance'];
    if ($remaining_balance <= 0) {
        return 0;
    }

    $calculation_type = $loan['calculation_type'];
    // FIX: Default to empty string if calculation_details is NULL to avoid json_decode(null) deprecation
    $calculation_details = json_decode($loan['calculation_details'] ?? '', true) ?: [];
    $monthly_deduction = 0;

    switch ($calculation_type) {
        case 'fixed':
            $monthly_deduction = min((float)($calculation_details['monthly_amount'] ?? 0), $remaining_balance);
            break;
            
        case 'percentage':
            $percentage = (float)($calculation_details['percentage_rate'] ?? 0);
            $gross_salary = (float)($loan['gross_salary'] ?? 0);
            $monthly_deduction = min(($gross_salary * $percentage / 100), $remaining_balance);
            break;
            
        case 'reducing_balance':
            $interest_rate = (float)$loan['interest_rate'];
            $months_remaining = (int)$loan['months_remaining'];
            
            if ($months_remaining > 0 && $interest_rate > 0) {
                $monthly_rate = $interest_rate / 100 / 12;
                $power = pow(1 + $monthly_rate, $months_remaining);
                $monthly_deduction = $remaining_balance * ($monthly_rate * $power) / ($power - 1);
            } else {
                $monthly_deduction = $remaining_balance / max($months_remaining, 1);
            }
            $monthly_deduction = min($monthly_deduction, $remaining_balance);
            break;
    }

    return round($monthly_deduction, 2);
}

// ================================
// EMPLOYEE DEDUCTIONS (INCLUDING LOANS)
// ================================
function processEmployeeDeductions($conn, $emp_id, $period_id, $gross_pay) {
    $emp_id = $conn->real_escape_string($emp_id);
    $period_id = $conn->real_escape_string($period_id);
    $deductions = [];
    $total_deductions = 0;

    // === STEP 1: Standard Deduction Types ===
    $deductionsQuery = "SELECT DISTINCT dt.deduction_type_id, dt.type_name, dt.calculation_method, dt.calculation_details
                        FROM deduction_types dt
                        WHERE dt.is_active = 1";
    $deductionsResult = $conn->query($deductionsQuery);
    
    if ($deductionsResult) {
        while ($deduction = $deductionsResult->fetch_assoc()) {
            // FIX: Default to empty string if calculation_details is NULL to avoid json_decode(null) deprecation
            $calculation_details = json_decode($deduction['calculation_details'] ?? '', true) ?: [];
            $amount = 0;

            if ($deduction['calculation_method'] === 'fixed') {
                $amount = (float)($calculation_details['amount'] ?? 0);
            } elseif ($deduction['calculation_method'] === 'percentage') {
                $percentage = (float)($calculation_details['percentage'] ?? 0);
                $amount = ($gross_pay * $percentage) / 100;
            }

            if ($amount > 0) {
                $deductions[] = [
                    'type_id' => $deduction['deduction_type_id'],
                    'type_name' => $deduction['type_name'],
                    'amount' => round($amount, 2),
                    'method' => $deduction['calculation_method']
                ];
                $total_deductions += $amount;
            }
        }
    }

    // === STEP 2: ACTIVE LOANS AS DEDUCTIONS ===
    $loansQuery = "SELECT l.*, p.Gross_pay as gross_salary 
                   FROM employee_loans l
                   LEFT JOIN payroll p ON l.emp_id = p.emp_id
                   WHERE l.emp_id = '$emp_id' AND l.status = 'active' AND l.remaining_balance > 0";
    $loansResult = $conn->query($loansQuery);
    
    if ($loansResult) {
        while ($loan = $loansResult->fetch_assoc()) {
            $loan_deduction = calculateLoanDeduction($conn, $loan);
            
            if ($loan_deduction > 0) {
                $deductions[] = [
                    'type_id' => 'LOAN_' . $loan['loan_id'],
                    'type_name' => 'Loan Repayment: ' . $loan['loan_type'],
                    'amount' => $loan_deduction,
                    'method' => 'loan',
                    'loan_id' => $loan['loan_id'],
                    'calculation_type' => $loan['calculation_type']
                ];
                $total_deductions += $loan_deduction;
            }
        }
    }

    return [
        'success' => true,
        'deductions' => $deductions,
        'total_deductions' => round($total_deductions, 2)
    ];
}

// ================================
// EMPLOYEE ALLOWANCES
// ================================
function calculateEmployeeAllowances($conn, $emp_id, $period_id) {
    $emp_id = $conn->real_escape_string($emp_id);
    $period_id = $conn->real_escape_string($period_id);
    
    $allowancesQuery = "SELECT ea.*, at.type_name 
                        FROM employee_allowances ea
                        JOIN allowance_types at ON ea.allowance_type_id = at.allowance_type_id
                        WHERE ea.emp_id = '$emp_id' 
                        AND ea.status = 'active'
                        AND (ea.period_id = '$period_id' OR ea.period_id IS NULL)";
    $allowancesResult = $conn->query($allowancesQuery);
    
    $allowances = [];
    $total = 0;
    
    if ($allowancesResult) {
        while ($allowance = $allowancesResult->fetch_assoc()) {
            $amount = (float)$allowance['amount'];
            $allowances[] = [
                'type' => $allowance['type_name'],
                'amount' => $amount
            ];
            $total += $amount;
        }
    }
    
    return [
        'success' => true,
        'allowances' => $allowances,
        'total_allowances' => round($total, 2)
    ];
}

// ================================
// UPDATE LOAN BALANCES
// ================================
function updateLoanBalances($conn, $deductions_breakdown, $payment_date) {
    foreach ($deductions_breakdown as $deduction) {
        if ($deduction['method'] === 'loan' && isset($deduction['loan_id'])) {
            $loan_id = $conn->real_escape_string($deduction['loan_id']);
            $payment_amount = $conn->real_escape_string($deduction['amount']);

            // Get current loan details
            $loanQuery = "SELECT remaining_balance, months_remaining FROM employee_loans WHERE loan_id = '$loan_id'";
            $loanResult = $conn->query($loanQuery);
            
            if ($loanResult && $loan = $loanResult->fetch_assoc()) {
                $new_balance = max(0, $loan['remaining_balance'] - $payment_amount);
                $new_months = max(0, $loan['months_remaining'] - 1);
                $new_status = $new_balance <= 0.01 ? 'completed' : 'active';

                // Update loan
                $updateQuery = "UPDATE employee_loans SET 
                    remaining_balance = '$new_balance',
                    months_remaining = '$new_months',
                    status = '$new_status',
                    last_payment_date = '$payment_date'
                    WHERE loan_id = '$loan_id'";
                $conn->query($updateQuery);

                // Record payment
                $paymentQuery = "INSERT INTO loan_payments 
                    (loan_id, payment_amount, payment_date, balance_after_payment, payment_method) 
                    VALUES ('$loan_id', '$payment_amount', '$payment_date', '$new_balance', 'payroll_deduction')";
                $conn->query($paymentQuery);
            }
        }
    }
}

// ================================
// PROCESS SINGLE EMPLOYEE
// ================================
function processEmployeePayroll($conn, $emp_id, $period_id, $period) {
    $emp_id = $conn->real_escape_string($emp_id);
    
    // Get base salary
    $payrollQuery = "SELECT * FROM payroll WHERE emp_id = '$emp_id' AND status = 'active'";
    $payrollResult = $conn->query($payrollQuery);
    
    if (!$payrollResult || $payrollResult->num_rows === 0) {
        return ['success' => false, 'message' => 'No payroll record found'];
    }
    
    $payroll = $payrollResult->fetch_assoc();
    $base_salary = (float)$payroll['salary'];

    // Calculate allowances
    $allowancesResult = calculateEmployeeAllowances($conn, $emp_id, $period_id);
    if (!$allowancesResult['success']) return $allowancesResult;
    
    $total_allowances = $allowancesResult['total_allowances'];
    $allowances_breakdown = $allowancesResult['allowances'];

    // Calculate gross pay
    $gross_pay = $base_salary + $total_allowances;

    // Calculate deductions (including loans)
    $deductionsResult = processEmployeeDeductions($conn, $emp_id, $period_id, $gross_pay);
    if (!$deductionsResult['success']) return $deductionsResult;
    
    $total_deductions = $deductionsResult['total_deductions'];
    $deductions_breakdown = $deductionsResult['deductions'];

    // Calculate net pay
    $net_pay = $gross_pay - $total_deductions;

    // Save payroll record
    $allowances_json = $conn->real_escape_string(json_encode($allowances_breakdown));
    $deductions_json = $conn->real_escape_string(json_encode($deductions_breakdown));
    
    // Check if record exists
    $checkQuery = "SELECT id FROM payroll_records 
                   WHERE employee_id = '$emp_id' AND pay_period_id = '$period_id'";
    $checkResult = $conn->query($checkQuery);
    
    if ($checkResult && $checkResult->num_rows > 0) {
        // Update existing
        $updateQuery = "UPDATE payroll_records SET 
            base_salary = '$base_salary',
            gross_pay = '$gross_pay',
            total_allowances = '$total_allowances',
            total_deductions = '$total_deductions',
            net_pay = '$net_pay',
            allowances_breakdown = '$allowances_json',
            deductions_breakdown = '$deductions_json',
            processed_at = NOW()
            WHERE employee_id = '$emp_id' AND pay_period_id = '$period_id'";
        $conn->query($updateQuery);
    } else {
        // Insert new
        $insertQuery = "INSERT INTO payroll_records 
            (employee_id, pay_period_id, base_salary, gross_pay, total_allowances, 
             total_deductions, net_pay, allowances_breakdown, deductions_breakdown, 
             processed_at, created_at) 
            VALUES 
            ('$emp_id', '$period_id', '$base_salary', '$gross_pay', '$total_allowances', 
             '$total_deductions', '$net_pay', '$allowances_json', '$deductions_json', 
             NOW(), NOW())";
        $conn->query($insertQuery);
    }

    // Update loan balances
    updateLoanBalances($conn, $deductions_breakdown, $period['pay_date']);

    return [
        'success' => true,
        'data' => [
            'base_salary' => $base_salary,
            'total_allowances' => $total_allowances,
            'gross_pay' => $gross_pay,
            'total_deductions' => $total_deductions,
            'net_pay' => $net_pay,
            'allowances_breakdown' => $allowances_breakdown,
            'deductions_breakdown' => $deductions_breakdown
        ]
    ];
}

// ================================
// PROCESS ENTIRE PERIOD
// ================================
function processPayrollForPeriod($conn, $period_id) {
    $period_id = $conn->real_escape_string($period_id);
    
    $periodQuery = "SELECT * FROM payroll_periods WHERE id = '$period_id'";
    $periodResult = $conn->query($periodQuery);
    
    if (!$periodResult || $periodResult->num_rows === 0) {
        return ['success' => false, 'message' => 'Period not found'];
    }
    
    $period = $periodResult->fetch_assoc();
    
    if ($period['is_locked']) {
        return ['success' => false, 'message' => 'Period is locked'];
    }

    $employeesQuery = "SELECT e.id, e.employee_id, e.first_name, e.last_name, 
                       p.salary, p.bank_id, p.bank_account
                       FROM employees e
                       JOIN payroll p ON e.id = p.emp_id
                       WHERE e.employee_status = 'active' AND p.status = 'active'";
    $employeesResult = $conn->query($employeesQuery);
    
    if (!$employeesResult) {
        return ['success' => false, 'message' => 'Failed to fetch employees'];
    }

    $processed = 0;
    $errors = [];
    $payroll_data = [];
    
    while ($employee = $employeesResult->fetch_assoc()) {
        $emp_id = $employee['id'];
        $result = processEmployeePayroll($conn, $emp_id, $period_id, $period);
        
        if ($result['success']) {
            $processed++;
            $payroll_data[] = array_merge($employee, $result['data']);
        } else {
            $errors[] = [
                'employee' => $employee['first_name'] . ' ' . $employee['last_name'],
                'error' => $result['message']
            ];
        }
    }

    return [
        'success' => true,
        'processed' => $processed,
        'errors' => $errors,
        'payroll_data' => $payroll_data
    ];
}

// ================================
// MAIN EXECUTION
// ================================

$conn = getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['process_payroll'])) {
    $period_id = $conn->real_escape_string($_POST['period_id']);
    $result = processPayrollForPeriod($conn, $period_id);
    
    if ($result['success']) {
        $_SESSION['flash_message'] = "Payroll processed: {$result['processed']} employees";
        $_SESSION['flash_type'] = count($result['errors']) > 0 ? "warning" : "success";
        $_SESSION['payroll_result'] = $result;
    } else {
        $_SESSION['flash_message'] = "Error: " . $result['message'];
        $_SESSION['flash_type'] = "danger";
    }
    ob_end_clean(); // Clear any buffered output before redirect
    header("Location: process_payroll.php");
    exit();
}

$periodsQuery = "SELECT * FROM payroll_periods ORDER BY start_date DESC";
$periodsResult = $conn->query($periodsQuery);

$payroll_result = $_SESSION['payroll_result'] ?? null;
unset($_SESSION['payroll_result']);

$conn->close();

require_once 'header.php';
include 'nav_bar.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Payroll</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .process-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .summary-card {
            background: linear-gradient(135deg, rgba(78, 115, 223, 0.3), rgba(28, 200, 138, 0.3));
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .summary-card h3 {
            margin: 0;
            font-size: 32px;
            color: #fff;
        }
        .payroll-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }
        .payroll-table th,
        .payroll-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .payroll-table th {
            background: rgba(255, 255, 255, 0.1);
            font-weight: 600;
            color: #fff;
        }
        .amount {
            text-align: right;
            font-family: 'Courier New', monospace;
        }
        .breakdown-row {
            display: none;
            background: rgba(0, 0, 0, 0.3);
        }
        .breakdown-row.show {
            display: table-row;
        }
        .breakdown-content {
            padding: 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        .breakdown-section h4 {
            margin-top: 0;
            color: #4e73df;
        }
        .breakdown-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .loan-item {
            background: rgba(231, 74, 59, 0.1);
            padding: 8px;
            border-radius: 5px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <div class="content">
                <div class="tabs">
                    <a href="payroll_management.php">Payroll Management</a>
                    <a href="process_payroll.php" class="active">Process Payroll</a>
                    <a href="deductions.php">Deductions</a>
                    <a href="allowances.php">Allowances</a>
                    <a href="loans.php">Loans</a>
                    <a href="periods.php">Periods</a>
                </div>

                <?php if (isset($_SESSION['flash_message'])): ?>
                    <div class="alert alert-<?php echo $_SESSION['flash_type']; ?>">
                        <?php echo htmlspecialchars($_SESSION['flash_message']); ?>
                        <?php unset($_SESSION['flash_message'], $_SESSION['flash_type']); ?>
                    </div>
                <?php endif; ?>

                <div class="process-card">
                    <h2>Process Payroll for Period</h2>
                    <form method="POST" action="process_payroll.php" onsubmit="return confirm('Process payroll? This will calculate salaries, allowances, deductions, and loan payments.');">
                        <input type="hidden" name="process_payroll" value="1">
                        <div class="form-group">
                            <label for="period_id">Select Payroll Period</label>
                            <select name="period_id" id="period_id" class="form-control" required>
                                <option value="">-- Select Period --</option>
                                <?php while ($period = $periodsResult->fetch_assoc()): ?>
                                    <option value="<?php echo $period['id']; ?>" <?php echo $period['is_locked'] ? 'disabled' : ''; ?>>
                                        <?php echo htmlspecialchars($period['period_name']); ?>
                                        (<?php echo date('M d, Y', strtotime($period['start_date'])); ?> - 
                                         <?php echo date('M d, Y', strtotime($period['end_date'])); ?>)
                                        <?php echo $period['is_locked'] ? ' - LOCKED' : ''; ?>
                                    </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-play"></i> Process Payroll
                        </button>
                    </form>
                </div>

                <?php if ($payroll_result): ?>
                <div class="result-table">
                    <h3>Payroll Processing Results</h3>
                    <?php
                    $totals = [
                        'base_salary' => 0,
                        'allowances' => 0,
                        'gross' => 0,
                        'deductions' => 0,
                        'net' => 0
                    ];
                    foreach ($payroll_result['payroll_data'] as $emp) {
                        $totals['base_salary'] += $emp['base_salary'];
                        $totals['allowances'] += $emp['total_allowances'];
                        $totals['gross'] += $emp['gross_pay'];
                        $totals['deductions'] += $emp['total_deductions'];
                        $totals['net'] += $emp['net_pay'];
                    }
                    ?>
                    
                    <div class="summary-cards">
                        <div class="summary-card">
                            <h3><?php echo $payroll_result['processed']; ?></h3>
                            <p>Employees Processed</p>
                        </div>
                        <div class="summary-card">
                            <h3>KSh <?php echo number_format($totals['gross'], 2); ?></h3>
                            <p>Total Gross Pay</p>
                        </div>
                        <div class="summary-card">
                            <h3>KSh <?php echo number_format($totals['deductions'], 2); ?></h3>
                            <p>Total Deductions</p>
                        </div>
                        <div class="summary-card">
                            <h3>KSh <?php echo number_format($totals['net'], 2); ?></h3>
                            <p>Total Net Pay</p>
                        </div>
                    </div>

                    <table class="payroll-table">
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th class="amount">Base Salary</th>
                                <th class="amount">Allowances</th>
                                <th class="amount">Gross Pay</th>
                                <th class="amount">Deductions</th>
                                <th class="amount">Net Pay</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($payroll_result['payroll_data'] as $index => $emp): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name']); ?></td>
                                <td class="amount">KSh <?php echo number_format($emp['base_salary'], 2); ?></td>
                                <td class="amount">KSh <?php echo number_format($emp['total_allowances'], 2); ?></td>
                                <td class="amount">KSh <?php echo number_format($emp['gross_pay'], 2); ?></td>
                                <td class="amount">KSh <?php echo number_format($emp['total_deductions'], 2); ?></td>
                                <td class="amount"><strong>KSh <?php echo number_format($emp['net_pay'], 2); ?></strong></td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="toggleBreakdown(<?php echo $index; ?>)">
                                        Details
                                    </button>
                                </td>
                            </tr>
                            <tr class="breakdown-row" id="breakdown-<?php echo $index; ?>">
                                <td colspan="7">
                                    <div class="breakdown-content">
                                        <div class="breakdown-section">
                                            <h4>Allowances</h4>
                                            <?php if (!empty($emp['allowances_breakdown'])): ?>
                                                <?php foreach ($emp['allowances_breakdown'] as $allowance): ?>
                                                    <div class="breakdown-item">
                                                        <span><?php echo htmlspecialchars($allowance['type']); ?></span>
                                                        <span>KSh <?php echo number_format($allowance['amount'], 2); ?></span>
                                                    </div>
                                                <?php endforeach; ?>
                                            <?php else: ?>
                                                <p style="color: rgba(255,255,255,0.5);">No allowances</p>
                                            <?php endif; ?>
                                        </div>
                                        <div class="breakdown-section">
                                            <h4>Deductions (Including Loans)</h4>
                                            <?php if (!empty($emp['deductions_breakdown'])): ?>
                                                <?php foreach ($emp['deductions_breakdown'] as $deduction): ?>
                                                    <div class="breakdown-item <?php echo $deduction['method'] === 'loan' ? 'loan-item' : ''; ?>">
                                                        <span>
                                                            <?php echo htmlspecialchars($deduction['type_name']); ?>
                                                            <?php if ($deduction['method'] === 'loan'): ?>
                                                                <i class="fas fa-hand-holding-usd"></i>
                                                            <?php endif; ?>
                                                        </span>
                                                        <span>KSh <?php echo number_format($deduction['amount'], 2); ?></span>
                                                    </div>
                                                <?php endforeach; ?>
                                            <?php else: ?>
                                                <p style="color: rgba(255,255,255,0.5);">No deductions</p>
                                            <?php endif; ?>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        function toggleBreakdown(index) {
            const row = document.getElementById('breakdown-' + index);
            row.classList.toggle('show');
        }
    </script>
</body>
</html>
<?php ob_end_flush(); // Flush buffer at the end ?>