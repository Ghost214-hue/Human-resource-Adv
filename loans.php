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

function getFlashMessage() {
    if (isset($_SESSION['flash_message'])) {
        $message = $_SESSION['flash_message'];
        $type = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);
        return ['message' => $message, 'type' => $type];
    }
    return false;
}

function calculateLoanDeduction($loan) {
    $calculation_type = $loan['calculation_type'];
    $remaining_balance = $loan['remaining_balance'];
    $monthly_deduction = 0;
    
    switch($calculation_type) {
        case 'fixed':
            $monthly_deduction = min($loan['monthly_amount'], $remaining_balance);
            break;
            
        case 'percentage':
            // Percentage of gross salary
            $percentage = $loan['percentage_rate'];
            $gross_salary = $loan['gross_salary'] ?? 0;
            $monthly_deduction = min(($gross_salary * $percentage / 100), $remaining_balance);
            break;
            
        case 'reducing_balance':
            // Reducing balance with interest
            $interest_rate = $loan['interest_rate'] / 100 / 12; // Monthly interest
            $months_remaining = $loan['months_remaining'];
            
            if ($months_remaining > 0 && $interest_rate > 0) {
                $monthly_deduction = $remaining_balance * 
                    ($interest_rate * pow(1 + $interest_rate, $months_remaining)) / 
                    (pow(1 + $interest_rate, $months_remaining) - 1);
            } else {
                $monthly_deduction = $remaining_balance / max($months_remaining, 1);
            }
            $monthly_deduction = min($monthly_deduction, $remaining_balance);
            break;
    }
    
    return round($monthly_deduction, 2);
}

$conn = getConnection();

// Handle POST requests
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['add_loan']) && hasPermission('hr_manager')) {
        $emp_id = $conn->real_escape_string($_POST['emp_id']);
        $loan_type = $conn->real_escape_string($_POST['loan_type']);
        $principal_amount = $conn->real_escape_string($_POST['principal_amount']);
        $interest_rate = $conn->real_escape_string($_POST['interest_rate']);
        $calculation_type = $conn->real_escape_string($_POST['calculation_type']);
        $monthly_amount = $conn->real_escape_string($_POST['monthly_amount'] ?? 0);
        $percentage_rate = $conn->real_escape_string($_POST['percentage_rate'] ?? 0);
        $loan_duration = $conn->real_escape_string($_POST['loan_duration']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $description = $conn->real_escape_string($_POST['description']);
        
        $calculation_details = json_encode([
            'calculation_type' => $calculation_type,
            'monthly_amount' => $monthly_amount,
            'percentage_rate' => $percentage_rate,
            'interest_rate' => $interest_rate
        ]);
        
        $insertQuery = "INSERT INTO employee_loans 
            (emp_id, loan_type, principal_amount, interest_rate, remaining_balance, 
             loan_duration, months_remaining, start_date, calculation_type, calculation_details, 
             description, status, created_at) 
            VALUES 
            ('$emp_id', '$loan_type', '$principal_amount', '$interest_rate', '$principal_amount', 
             '$loan_duration', '$loan_duration', '$start_date', '$calculation_type', '$calculation_details', 
             '$description', 'active', NOW())";
        
        if ($conn->query($insertQuery)) {
            $_SESSION['flash_message'] = "Loan added successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: loans.php");
        exit();
    }
    
    if (isset($_POST['record_payment']) && hasPermission('hr_manager')) {
        $loan_id = $conn->real_escape_string($_POST['loan_id']);
        $payment_amount = $conn->real_escape_string($_POST['payment_amount']);
        $payment_date = $conn->real_escape_string($_POST['payment_date']);
        
        // Get loan details
        $loanQuery = "SELECT * FROM employee_loans WHERE loan_id = '$loan_id'";
        $loanResult = $conn->query($loanQuery);
        $loan = $loanResult->fetch_assoc();
        
        $new_balance = $loan['remaining_balance'] - $payment_amount;
        $new_months = max(0, $loan['months_remaining'] - 1);
        $new_status = $new_balance <= 0 ? 'completed' : 'active';
        
        // Update loan
        $updateQuery = "UPDATE employee_loans SET 
            remaining_balance = '$new_balance',
            months_remaining = '$new_months',
            status = '$new_status',
            last_payment_date = '$payment_date'
            WHERE loan_id = '$loan_id'";
        
        // Record payment
        $paymentQuery = "INSERT INTO loan_payments 
            (loan_id, payment_amount, payment_date, balance_after_payment) 
            VALUES ('$loan_id', '$payment_amount', '$payment_date', '$new_balance')";
        
        if ($conn->query($updateQuery) && $conn->query($paymentQuery)) {
            $_SESSION['flash_message'] = "Payment recorded successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: loans.php");
        exit();
    }
}

// Fetch loans with employee details
$loansQuery = "SELECT l.*, e.first_name, e.last_name, e.employee_id,
    (SELECT SUM(payment_amount) FROM loan_payments WHERE loan_id = l.loan_id) as total_paid
    FROM employee_loans l
    JOIN employees e ON l.emp_id = e.id
    ORDER BY l.created_at DESC";
$loansResult = $conn->query($loansQuery);

$loans = [];
if ($loansResult) {
    while ($row = $loansResult->fetch_assoc()) {
        $loans[] = $row;
    }
}

// Fetch employees
$employeesQuery = "SELECT id, employee_id, first_name, last_name FROM employees ORDER BY first_name";
$employeesResult = $conn->query($employeesQuery);

$conn->close();

require_once 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loan Management</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .loan-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .calculation-type-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 15px 0;
        }
        .type-card {
            background: rgba(255, 255, 255, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .type-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: #4e73df;
        }
        .type-card.selected {
            background: rgba(78, 115, 223, 0.25);
            border-color: #4e73df;
        }
        .dynamic-section {
            display: none;
        }
        .dynamic-section.active {
            display: block;
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
                    <a href="loans.php">Reports</a>
                    <A href="process_payroll.php">Reports</A>

                </div>

                <?php $flash = getFlashMessage(); if ($flash): ?>
                    <div class="alert alert-<?php echo $flash['type']; ?>">
                        <?php echo htmlspecialchars($flash['message']); ?>
                    </div>
                <?php endif; ?>

                <?php if (hasPermission('hr_manager')): ?>
                <div class="loan-card">
                    <h3>Add New Loan</h3>
                    <form method="POST" action="loans.php">
                        <input type="hidden" name="add_loan" value="1">
                        <input type="hidden" name="calculation_type" id="calculation_type" value="fixed">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="emp_id">Employee</label>
                                <select name="emp_id" id="emp_id" class="form-control" required>
                                    <option value="">Select Employee</option>
                                    <?php while ($emp = $employeesResult->fetch_assoc()): ?>
                                        <option value="<?php echo $emp['id']; ?>">
                                            <?php echo htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name'] . ' (' . $emp['employee_id'] . ')'); ?>
                                        </option>
                                    <?php endwhile; ?>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="loan_type">Loan Type</label>
                                <input type="text" name="loan_type" id="loan_type" class="form-control" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="principal_amount">Principal Amount (₦)</label>
                                <input type="number" step="0.01" name="principal_amount" id="principal_amount" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="interest_rate">Interest Rate (%)</label>
                                <input type="number" step="0.01" name="interest_rate" id="interest_rate" class="form-control" value="0">
                            </div>
                            
                            <div class="form-group">
                                <label for="loan_duration">Duration (Months)</label>
                                <input type="number" name="loan_duration" id="loan_duration" class="form-control" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="start_date">Start Date</label>
                                <input type="date" name="start_date" id="start_date" class="form-control" required>
                            </div>
                        </div>
                        
                        <label>Calculation Method</label>
                        <div class="calculation-type-selector">
                            <div class="type-card selected" data-type="fixed" onclick="selectCalculationType('fixed')">
                                <h5>Fixed Amount</h5>
                                <p>Same amount every month</p>
                            </div>
                            <div class="type-card" data-type="percentage" onclick="selectCalculationType('percentage')">
                                <h5>Percentage</h5>
                                <p>% of monthly salary</p>
                            </div>
                            <div class="type-card" data-type="reducing_balance" onclick="selectCalculationType('reducing_balance')">
                                <h5>Reducing Balance</h5>
                                <p>Interest on remaining balance</p>
                            </div>
                        </div>
                        
                        <div class="dynamic-section active" id="fixed_section">
                            <div class="form-group">
                                <label for="monthly_amount">Monthly Deduction (₦)</label>
                                <input type="number" step="0.01" name="monthly_amount" id="monthly_amount" class="form-control">
                            </div>
                        </div>
                        
                        <div class="dynamic-section" id="percentage_section">
                            <div class="form-group">
                                <label for="percentage_rate">Percentage of Salary (%)</label>
                                <input type="number" step="0.01" name="percentage_rate" id="percentage_rate" class="form-control">
                            </div>
                        </div>
                        
                        <div class="dynamic-section" id="reducing_balance_section">
                            <p class="text-muted">Reducing balance calculation will use the interest rate and duration above</p>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea name="description" id="description" class="form-control" rows="2"></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Add Loan</button>
                    </form>
                </div>
                <?php endif; ?>

                <div class="table-container">
                    <h3>Active Loans</h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Loan Type</th>
                                <th>Principal</th>
                                <th>Paid</th>
                                <th>Balance</th>
                                <th>Months Left</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($loans as $loan): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($loan['first_name'] . ' ' . $loan['last_name']); ?></td>
                                <td><?php echo htmlspecialchars($loan['loan_type']); ?></td>
                                <td>₦<?php echo number_format($loan['principal_amount'], 2); ?></td>
                                <td>₦<?php echo number_format($loan['total_paid'] ?? 0, 2); ?></td>
                                <td>₦<?php echo number_format($loan['remaining_balance'], 2); ?></td>
                                <td><?php echo $loan['months_remaining']; ?></td>
                                <td><span class="badge badge-<?php echo $loan['status'] == 'active' ? 'success' : 'secondary'; ?>">
                                    <?php echo ucfirst($loan['status']); ?>
                                </span></td>
                                <td>
                                    <?php if ($loan['status'] == 'active' && hasPermission('hr_manager')): ?>
                                    <button class="btn btn-sm btn-primary record-payment-btn" 
                                            data-loan-id="<?php echo $loan['loan_id']; ?>"
                                            data-balance="<?php echo $loan['remaining_balance']; ?>">
                                        Record Payment
                                    </button>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div id="paymentModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>Record Loan Payment</h5>
                    <button type="button" class="close" onclick="closeModal()">&times;</button>
                </div>
                <form method="POST" action="loans.php">
                    <div class="modal-body">
                        <input type="hidden" name="record_payment" value="1">
                        <input type="hidden" name="loan_id" id="payment_loan_id">
                        
                        <div class="form-group">
                            <label>Current Balance: ₦<span id="current_balance"></span></label>
                        </div>
                        
                        <div class="form-group">
                            <label for="payment_amount">Payment Amount (₦)</label>
                            <input type="number" step="0.01" name="payment_amount" id="payment_amount" class="form-control" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="payment_date">Payment Date</label>
                            <input type="date" name="payment_date" id="payment_date" class="form-control" required value="<?php echo date('Y-m-d'); ?>">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Record Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function selectCalculationType(type) {
            document.getElementById('calculation_type').value = type;
            document.querySelectorAll('.type-card').forEach(card => {
                card.classList.toggle('selected', card.dataset.type === type);
            });
            document.querySelectorAll('.dynamic-section').forEach(section => {
                section.classList.remove('active');
            });
            document.getElementById(type + '_section').classList.add('active');
        }
        
        document.querySelectorAll('.record-payment-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.getElementById('payment_loan_id').value = this.dataset.loanId;
                document.getElementById('current_balance').textContent = parseFloat(this.dataset.balance).toFixed(2);
                document.getElementById('payment_amount').value = this.dataset.balance;
                document.getElementById('paymentModal').style.display = 'block';
            });
        });
        
        function closeModal() {
            document.getElementById('paymentModal').style.display = 'none';
        }
    </script>
</body>
</html>