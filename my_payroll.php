<?php
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

// Get employee ID from logged-in user
function getEmployeeIdFromUserId($conn, $user_id) {
    $stmt = $conn->prepare("SELECT employee_id FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        $stmt2 = $conn->prepare("SELECT id FROM employees WHERE employee_id = ?");
        $stmt2->bind_param("s", $user['employee_id']);
        $stmt2->execute();
        $emp_result = $stmt2->get_result();
        
        if ($emp_result && $emp_result->num_rows > 0) {
            return $emp_result->fetch_assoc()['id'];
        }
    }
    return null;
}

// Generate downloadable payroll summary
function generatePayrollDownload($payrollRecords, $type = 'txt') {
    $content = "PAYROLL SUMMARY\n";
    $content .= "Generated: " . date('Y-m-d H:i:s') . "\n";
    $content .= str_repeat("=", 50) . "\n\n";
    
    foreach ($payrollRecords as $record) {
        $content .= "Period: {$record['period_name']}\n";
        $content .= "Pay Date: " . date('M d, Y', strtotime($record['pay_date'])) . "\n";
        $content .= str_repeat("-", 30) . "\n";
        
        $content .= "Basic Salary: KSh " . number_format($record['base_salary'], 2) . "\n";
        $content .= "Total Allowances: KSh " . number_format($record['total_allowances'], 2) . "\n";
        $content .= "Gross Pay: KSh " . number_format($record['gross_pay'], 2) . "\n";
        $content .= "Total Deductions: KSh " . number_format($record['total_deductions'], 2) . "\n";
        
        // Show loan deductions separately if they exist
        $loan_deductions = 0;
        foreach ($record['deductions_breakdown'] as $deduction) {
            if (strpos($deduction['type_name'], 'Loan:') === 0) {
                $loan_deductions += $deduction['amount'];
            }
        }
        if ($loan_deductions > 0) {
            $content .= "Loan Deductions: KSh " . number_format($loan_deductions, 2) . "\n";
        }
        
        $content .= "NET PAY: KSh " . number_format($record['net_pay'], 2) . "\n\n";
        
        // Allowances breakdown
        if (!empty($record['allowances_breakdown'])) {
            $content .= "Allowances Breakdown:\n";
            foreach ($record['allowances_breakdown'] as $allowance) {
                $content .= "  - " . ($allowance['type'] ?? 'Unknown') . ": KSh " . 
                           number_format($allowance['amount'] ?? 0, 2) . "\n";
            }
            $content .= "\n";
        }
        
        // Deductions breakdown (including loans)
        if (!empty($record['deductions_breakdown'])) {
            $content .= "Deductions Breakdown:\n";
            foreach ($record['deductions_breakdown'] as $deduction) {
                $content .= "  - " . ($deduction['type_name'] ?? 'Unknown') . ": KSh " . 
                           number_format($deduction['amount'] ?? 0, 2) . "\n";
            }
            $content .= "\n";
        }
        
        $content .= str_repeat("=", 50) . "\n\n";
    }
    
    return $content;
}

$conn = getConnection();
$emp_id = getEmployeeIdFromUserId($conn, $_SESSION['user_id']);

if (!$emp_id) {
    $_SESSION['flash_message'] = "Employee record not found.";
    $_SESSION['flash_type'] = "danger";
    header("Location: dashboard.php");
    exit();
}

// Handle payroll download
if (isset($_GET['download_payroll']) && isset($_GET['record_id'])) {
    $record_id = (int)$_GET['record_id'];
    
    $stmt = $conn->prepare(
        "SELECT pr.*, pp.period_name, pp.pay_date, e.first_name, e.last_name, e.employee_id
         FROM payroll_records pr
         JOIN payroll_periods pp ON pr.pay_period_id = pp.id
         JOIN employees e ON pr.employee_id = e.id
         WHERE pr.id = ? AND pr.employee_id = ?"
    );
    $stmt->bind_param("ii", $record_id, $emp_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result && $result->num_rows > 0) {
        $record = $result->fetch_assoc();
        $record['allowances_breakdown'] = json_decode($record['allowances_breakdown'], true) ?: [];
        $record['deductions_breakdown'] = json_decode($record['deductions_breakdown'], true) ?: [];
        
        $payrollContent = generatePayrollDownload([$record]);
        
        header('Content-Type: text/plain');
        header("Content-Disposition: attachment; filename=payroll_{$record['period_name']}.txt");
        echo $payrollContent;
        exit();
    }
}

// Handle bulk download of all records
if (isset($_GET['download_all_payroll'])) {
    $stmt = $conn->prepare(
        "SELECT pr.*, pp.period_name, pp.pay_date, e.first_name, e.last_name, e.employee_id
         FROM payroll_records pr
         JOIN payroll_periods pp ON pr.pay_period_id = pp.id
         JOIN employees e ON pr.employee_id = e.id
         WHERE pr.employee_id = ?
         ORDER BY pp.start_date DESC"
    );
    $stmt->bind_param("i", $emp_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $allRecords = [];
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $row['allowances_breakdown'] = json_decode($row['allowances_breakdown'], true) ?: [];
            $row['deductions_breakdown'] = json_decode($row['deductions_breakdown'], true) ?: [];
            $allRecords[] = $row;
        }
    }
    
    if (!empty($allRecords)) {
        $payrollContent = generatePayrollDownload($allRecords);
        
        header('Content-Type: text/plain');
        header("Content-Disposition: attachment; filename=all_payroll_records.txt");
        echo $payrollContent;
        exit();
    }
}

// Fetch payroll records grouped by period
$stmt = $conn->prepare(
    "SELECT pr.*, pp.period_name, pp.pay_date, pp.start_date, pp.end_date,
            e.first_name, e.last_name, e.employee_id
     FROM payroll_records pr
     JOIN payroll_periods pp ON pr.pay_period_id = pp.id
     JOIN employees e ON pr.employee_id = e.id
     WHERE pr.employee_id = ?
     ORDER BY pp.start_date DESC"
);
$stmt->bind_param("i", $emp_id);
$stmt->execute();
$result = $stmt->get_result();

$payrollRecords = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $row['allowances_breakdown'] = json_decode($row['allowances_breakdown'], true) ?: [];
        $row['deductions_breakdown'] = json_decode($row['deductions_breakdown'], true) ?: [];
        $payrollRecords[] = $row;
    }
}

$conn->close();

require_once 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Payroll</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .compact-payroll-card {
            background: rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            margin-bottom: 15px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.1);
        }
        .payroll-header {
            background: rgba(78, 115, 223, 0.3);
            padding: 15px 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.3s ease;
        }
        .payroll-header:hover {
            background: rgba(78, 115, 223, 0.4);
        }
        .payroll-header h3 {
            margin: 0;
            font-size: 16px;
            color: #fff;
        }
        .payroll-date {
            color: rgba(255,255,255,0.7);
            font-size: 14px;
        }
        .payroll-content {
            padding: 0;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .payroll-content.expanded {
            padding: 20px;
            max-height: 1000px;
        }
        .payroll-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .summary-item {
            text-align: center;
            padding: 12px;
            background: rgba(0,0,0,0.2);
            border-radius: 8px;
        }
        .summary-label {
            font-size: 12px;
            color: rgba(255,255,255,0.7);
            margin-bottom: 5px;
        }
        .summary-value {
            font-size: 18px;
            font-weight: bold;
            color: #fff;
        }
        .breakdown-section {
            margin: 15px 0;
        }
        .breakdown-title {
            font-size: 14px;
            color: #4e73df;
            margin-bottom: 10px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 5px;
        }
        .breakdown-item {
            display: flex;
            justify-content: space-between;
            padding: 5px 0;
            font-size: 13px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .breakdown-item:last-child {
            border-bottom: none;
        }
        .download-section {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        .btn-download {
            background: rgba(28, 200, 138, 0.3);
            color: #fff;
            border: 1px solid rgba(28, 200, 138, 0.5);
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        .btn-download:hover {
            background: rgba(28, 200, 138, 0.5);
            transform: translateY(-2px);
        }
        .btn-download-all {
            background: rgba(78, 115, 223, 0.3);
            border: 1px solid rgba(78, 115, 223, 0.5);
        }
        .btn-download-all:hover {
            background: rgba(78, 115, 223, 0.5);
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: rgba(255,255,255,0.7);
        }
        .loan-deduction {
            color: #e74a3b;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <div class="content">
                <div class="tabs">
                    <a href="dashboard.php">Dashboard</a>
                    <a href="my_payroll.php" class="active">My Payroll</a>
                    <a href="leave_management.php">Leave</a>
                </div>

                <?php if (isset($_SESSION['flash_message'])): ?>
                    <div class="alert alert-<?php echo $_SESSION['flash_type'] ?? 'info'; ?>">
                        <?php echo htmlspecialchars($_SESSION['flash_message']); ?>
                        <?php unset($_SESSION['flash_message'], $_SESSION['flash_type']); ?>
                    </div>
                <?php endif; ?>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2>My Payroll Records</h2>
                    <?php if (!empty($payrollRecords)): ?>
                        <a href="?download_all_payroll=1" class="btn-download btn-download-all">
                            <i class="fas fa-download"></i> Download All Records
                        </a>
                    <?php endif; ?>
                </div>

                <?php if (empty($payrollRecords)): ?>
                    <div class="empty-state">
                        <i class="fas fa-file-invoice-dollar" style="font-size: 48px; margin-bottom: 15px; opacity: 0.5;"></i>
                        <h3>No Payroll Records Found</h3>
                        <p>Your payroll records will appear here once they are processed.</p>
                    </div>
                <?php else: ?>
                    <?php foreach ($payrollRecords as $index => $record): ?>
                    <div class="compact-payroll-card">
                        <div class="payroll-header" onclick="togglePayroll(<?php echo $index; ?>)">
                            <h3>
                                <i class="fas fa-calendar-alt" style="margin-right: 8px;"></i>
                                <?php echo htmlspecialchars($record['period_name']); ?>
                            </h3>
                            <div class="payroll-date">
                                <?php echo date('M d, Y', strtotime($record['pay_date'])); ?>
                                <i class="fas fa-chevron-down" id="icon-<?php echo $index; ?>" style="margin-left: 10px;"></i>
                            </div>
                        </div>
                        
                        <div class="payroll-content" id="content-<?php echo $index; ?>">
                            <div class="payroll-summary-grid">
                                <div class="summary-item">
                                    <div class="summary-label">Basic Salary</div>
                                    <div class="summary-value">KSh <?php echo number_format($record['base_salary'], 2); ?></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Allowances</div>
                                    <div class="summary-value">KSh <?php echo number_format($record['total_allowances'], 2); ?></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Gross Pay</div>
                                    <div class="summary-value">KSh <?php echo number_format($record['gross_pay'], 2); ?></div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Deductions</div>
                                    <div class="summary-value">KSh <?php echo number_format($record['total_deductions'], 2); ?></div>
                                </div>
                                <div class="summary-item" style="background: rgba(28, 200, 138, 0.2);">
                                    <div class="summary-label">Net Pay</div>
                                    <div class="summary-value">KSh <?php echo number_format($record['net_pay'], 2); ?></div>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <!-- Allowances Breakdown -->
                                <div class="breakdown-section">
                                    <div class="breakdown-title">
                                        <i class="fas fa-plus-circle"></i> Allowances
                                    </div>
                                    <div class="breakdown-item">
                                        <span>Basic Salary</span>
                                        <span>KSh <?php echo number_format($record['base_salary'], 2); ?></span>
                                    </div>
                                    <?php foreach ($record['allowances_breakdown'] as $allowance): ?>
                                    <div class="breakdown-item">
                                        <span><?php echo htmlspecialchars($allowance['type'] ?? 'Unknown'); ?></span>
                                        <span>KSh <?php echo number_format($allowance['amount'] ?? 0, 2); ?></span>
                                    </div>
                                    <?php endforeach; ?>
                                </div>

                                <!-- Deductions Breakdown (including loans) -->
                                <div class="breakdown-section">
                                    <div class="breakdown-title">
                                        <i class="fas fa-minus-circle"></i> Deductions
                                    </div>
                                    <?php 
                                    $hasLoans = false;
                                    foreach ($record['deductions_breakdown'] as $deduction): 
                                        $isLoan = strpos($deduction['type_name'], 'Loan:') === 0;
                                        if ($isLoan) $hasLoans = true;
                                    ?>
                                    <div class="breakdown-item <?php echo $isLoan ? 'loan-deduction' : ''; ?>">
                                        <span>
                                            <?php if ($isLoan): ?>
                                                <i class="fas fa-hand-holding-usd" style="margin-right: 5px;"></i>
                                            <?php endif; ?>
                                            <?php echo htmlspecialchars($deduction['type_name']); ?>
                                        </span>
                                        <span>KSh <?php echo number_format($deduction['amount'] ?? 0, 2); ?></span>
                                    </div>
                                    <?php endforeach; ?>
                                    
                                    <?php if ($hasLoans): ?>
                                    <div style="margin-top: 10px; padding: 8px; background: rgba(231, 74, 59, 0.1); border-radius: 5px; font-size: 12px;">
                                        <i class="fas fa-info-circle"></i> Loan deductions are included in total deductions
                                    </div>
                                    <?php endif; ?>
                                </div>
                            </div>

                            <div class="download-section">
                                <a href="?download_payroll=1&record_id=<?php echo $record['id']; ?>" class="btn-download">
                                    <i class="fas fa-file-download"></i> Download Payslip
                                </a>
                            </div>
                        </div>
                    </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        function togglePayroll(index) {
            const content = document.getElementById('content-' + index);
            const icon = document.getElementById('icon-' + index);
            
            if (content.classList.contains('expanded')) {
                content.classList.remove('expanded');
                icon.classList.remove('fa-chevron-up');
                icon.classList.add('fa-chevron-down');
            } else {
                content.classList.add('expanded');
                icon.classList.remove('fa-chevron-down');
                icon.classList.add('fa-chevron-up');
            }
        }

        // Auto-expand the first record
        document.addEventListener('DOMContentLoaded', function() {
            if (document.getElementById('content-0')) {
                togglePayroll(0);
            }
        });
    </script>
</body>
</html>