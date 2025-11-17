<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_start();

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
// After successful login verification in other pages
if (!isset($_SESSION['hr_system_user_id'])) {
    $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
    $_SESSION['hr_system_username'] = $_SESSION['user_name'];
    $_SESSION['hr_system_user_role'] = $_SESSION['user_role'];
}

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}
require_once 'auth_check.php';
require_once 'auth.php';
require_once 'config.php';
$conn = getConnection();

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

function formatDate($date) {
    if (!$date) return 'N/A';
    return date('M d, Y', strtotime($date));
}

function getStatusBadgeClass($status) {
    switch ($status) {
        case 'approved': return 'badge-success';
        case 'rejected': return 'badge-danger';
        case 'pending': return 'badge-warning';
        case 'pending_section_head': return 'badge-info';
        case 'pending_dept_head': return 'badge-primary';
        case 'pending_hr': return 'badge-warning';
        default: return 'badge-secondary';
    }
}

function getStatusDisplayName($status) {
    switch ($status) {
        case 'approved': return 'Approved';
        case 'rejected': return 'Rejected';
        case 'pending': return 'Pending';
        case 'pending_section_head': return 'Pending Section Head Approval';
        case 'pending_dept_head': return 'Pending Department Head Approval';
        case 'pending_hr': return 'Pending HR Approval';
        default: return ucfirst($status);
    }
}

// Get user's employee record with department name
$userEmployeeQuery = "SELECT e.*, d.name as department_name 
                      FROM employees e 
                      LEFT JOIN users u ON u.employee_id = e.employee_id 
                      LEFT JOIN departments d ON e.department_id = d.id
                      WHERE u.id = ?";
$stmt = $conn->prepare($userEmployeeQuery);
$stmt->bind_param("i", $user['id']);
$stmt->execute();
$userEmployee = $stmt->get_result()->fetch_assoc();

// Initialize variables
$employee = null;
$leaveBalances = [];
$leaveHistory = [];
$currentFinancialYearId = null;
$yearDetails = 'Current Year';
$startDate = '';
$endDate = '';

if ($userEmployee) {
    $employee = $userEmployee;

    // Get current financial year based on today's date
    $currentDate = date('Y-m-d');
    $currentYearQuery = "SELECT id, year_name, start_date, end_date FROM financial_years 
                         WHERE start_date <= ? AND end_date >= ? 
                         LIMIT 1";
    $stmt = $conn->prepare($currentYearQuery);
    $stmt->bind_param("ss", $currentDate, $currentDate);
    $stmt->execute();
    $currentYearResult = $stmt->get_result();
    $currentYearData = $currentYearResult->fetch_assoc();

    if ($currentYearData) {
        $currentFinancialYearId = $currentYearData['id'];
        $yearDetails = $currentYearData['year_name']; // ✅ Fixed: was 'year'
        $startDate = $currentYearData['start_date'];
        $endDate = $currentYearData['end_date'];

        // ✅ Removed 'lt.max_days_per_year' — column no longer exists
        $stmt = $conn->prepare("
            SELECT elb.*, 
                   lt.name AS leave_type_name,  
                   lt.counts_weekends,
                   lt.deducted_from_annual
            FROM employee_leave_balances elb
            JOIN leave_types lt ON elb.leave_type_id = lt.id
            WHERE elb.employee_id = ? 
              AND elb.financial_year_id = ?
              AND lt.is_active = 1
            ORDER BY lt.name
        ");
        $stmt->bind_param("ii", $employee['id'], $currentFinancialYearId);
        $stmt->execute();
        $leaveBalances = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    } else {
        // Fallback: use latest financial year with leave data
        $latestYearQuery = "SELECT MAX(financial_year_id) AS latest_year 
                            FROM employee_leave_balances 
                            WHERE employee_id = ?";
        $stmt = $conn->prepare($latestYearQuery);
        $stmt->bind_param("i", $employee['id']);
        $stmt->execute();
        $latestYear = $stmt->get_result()->fetch_assoc();

        if ($latestYear && $latestYear['latest_year']) {
            $currentFinancialYearId = $latestYear['latest_year'];

            $yearDetailsQuery = "SELECT year_name, start_date, end_date 
                                 FROM financial_years 
                                 WHERE id = ?";
            $stmt = $conn->prepare($yearDetailsQuery);
            $stmt->bind_param("i", $currentFinancialYearId);
            $stmt->execute();
            $yearData = $stmt->get_result()->fetch_assoc();

            $yearDetails = $yearData['year_name'] ?? 'Latest Year';
            $startDate = $yearData['start_date'] ?? '';
            $endDate = $yearData['end_date'] ?? '';

            // ✅ Also removed max_days_per_year here (already correct in your original)
            $stmt = $conn->prepare("
                SELECT elb.*, 
                       lt.name AS leave_type_name,  
                       lt.counts_weekends,
                       lt.deducted_from_annual
                FROM employee_leave_balances elb
                JOIN leave_types lt ON elb.leave_type_id = lt.id
                WHERE elb.employee_id = ? 
                  AND elb.financial_year_id = ?
                  AND lt.is_active = 1
                ORDER BY lt.name
            ");
            $stmt->bind_param("ii", $employee['id'], $currentFinancialYearId);
            $stmt->execute();
            $leaveBalances = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
        }
    }

    // ✅ Get leave history — only once (removed duplicate)
    $historyQuery = "
        SELECT la.*, 
               lt.name AS leave_type_name,
               la.primary_days, 
               la.annual_days, 
               la.unpaid_days
        FROM leave_applications la
        JOIN leave_types lt ON la.leave_type_id = lt.id
        WHERE la.employee_id = ?
        ORDER BY la.applied_at DESC
    ";
    $stmt = $conn->prepare($historyQuery);
    $stmt->bind_param("i", $employee['id']);
    $stmt->execute();
    $leaveHistory = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

require_once 'header.php';
require_once 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Leave Profile - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Main Content -->
    <div class="main-content">
        <div class="content">
            <div class="leave-tabs">
                <a href="leave_management.php" class="leave-tab">Apply Leave</a>
                <?php if (in_array($user['role'], ['hr_manager', 'dept_head', 'section_head', 'manager', 'managing_director','super_admin'])): ?>
                    <a href="manage.php" class="leave-tab">Manage Leave</a>
                <?php endif; ?>
                <?php if(in_array($user['role'], ['hr_manager', 'super_admin', 'manager','managing_director'])): ?>
                    <a href="history.php" class="leave-tab">Leave History</a>
                    <a href="holidays.php" class="leave-tab">Holidays</a>
                <?php endif; ?>
                <a href="profile.php" class="leave-tab active">My Leave Profile</a>
            </div>

            <!-- Enhanced My Leave Profile Tab -->
            <div class="tab-content">
                <h3>My Leave Profile</h3>

                <?php if ($employee): ?>
                    <!-- Employee Information -->
                    <div class="employee-info mb-4">
                        <div class="form-grid">
                            <div>
                                <h4>Employee Information</h4>
                                <p><strong>Employee ID:</strong> <?php echo htmlspecialchars($employee['employee_id']); ?></p>
                                <p><strong>Name:</strong> <?php echo htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name']); ?></p>
                                <p><strong>Employment Type:</strong> <?php echo htmlspecialchars($employee['employment_type']); ?></p>
                                <p><strong>Department:</strong> <?php echo htmlspecialchars($employee['department_name'] ?? 'N/A'); ?></p>
                            </div>
                        </div>
                    </div>

                    <!-- Enhanced Leave Balance Display -->
                    <div class="leave-balance-section mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4>Leave Balances - <?php echo htmlspecialchars($yearDetails); ?></h4>
                            <?php if ($startDate && $endDate): ?>
                                <small class="text-muted">
                                    (<?php echo formatDate($startDate); ?> to <?php echo formatDate($endDate); ?>)
                                </small>
                            <?php endif; ?>
                        </div>

                        <?php if (empty($leaveBalances)): ?>
                            <div class="alert alert-warning">
                                <h5>No leave balances found for this financial year.</h5>
                                <p class="mb-0">Please contact HR if you believe this is incorrect.</p>
                            </div>
                        <?php else: ?>
                            <div class="row">
                                <?php foreach ($leaveBalances as $balance): ?>
                                <div class="col-md-4 mb-4">
                                    <div class="card h-100">
                                        <div class="card-header bg-primary text-white">
                                            <h5 class="card-title mb-0"><?php echo htmlspecialchars($balance['leave_type_name']); ?></h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="progress mb-3" style="height: 20px;">
                                                <?php 
                                                $allocated = floatval($balance['allocated_days']);
                                                $used = floatval($balance['used_days']);
                                                $percentage = $allocated > 0 ? ($used / $allocated) * 100 : 0;
                                                $progressClass = $percentage > 80 ? 'bg-danger' : ($percentage > 50 ? 'bg-warning' : 'bg-success');
                                                ?>
                                                <div class="progress-bar <?php echo $progressClass; ?>" 
                                                     role="progressbar" 
                                                     style="width: <?php echo min($percentage, 100); ?>%" 
                                                     aria-valuenow="<?php echo $percentage; ?>" 
                                                     aria-valuemin="0" 
                                                     aria-valuemax="100">
                                                    <?php echo round($percentage, 1); ?>%
                                                </div>
                                            </div>

                                            <div class="balance-details">
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Allocated:</span>
                                                    <strong><?php echo number_format($balance['allocated_days'], 2); ?> days</strong>
                                                </div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Used:</span>
                                                    <strong><?php echo number_format($balance['used_days'], 2); ?> days</strong>
                                                </div>
                                                <div class="d-flex justify-content-between mb-2">
                                                    <span>Remaining:</span>
                                                    <strong class="<?php echo floatval($balance['total_days']) < 0 ? 'text-danger' : 'text-success'; ?>">
                                                        <?php echo number_format($balance['total_days'], 2); ?> days
                                                    </strong>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-light">
                                            <small class="text-muted">
                                                <?php if ($balance['counts_weekends'] == 0): ?>
                                                    <i class="fas fa-calendar-week"></i> Excludes weekends
                                                <?php else: ?>
                                                    <i class="fas fa-calendar-alt"></i> Includes weekends
                                                <?php endif; ?>

                                                <?php if (!empty($balance['deducted_from_annual'])): ?>
                                                    <span class="ml-2"><i class="fas fa-exchange-alt"></i> Falls back to Annual Leave</span>
                                                <?php endif; ?>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                <?php endforeach; ?>
                            </div>

                            <!-- Summary Statistics -->
                            <div class="row mt-4">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header bg-light">
                                            <h6 class="mb-0">Leave Summary - <?php echo htmlspecialchars($yearDetails); ?></h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="row text-center">
                                                <div class="col-md-3">
                                                    <h4 class="text-primary"><?php echo count($leaveBalances); ?></h4>
                                                    <small class="text-muted">Leave Types</small>
                                                </div>
                                                <div class="col-md-3">
                                                    <h4 class="text-success">
                                                        <?php 
                                                        $totalAllocated = array_sum(array_column($leaveBalances, 'allocated_days'));
                                                        echo number_format($totalAllocated, 2);
                                                        ?>
                                                    </h4>
                                                    <small class="text-muted">Total Allocated Days</small>
                                                </div>
                                                <div class="col-md-3">
                                                    <h4 class="text-warning">
                                                        <?php 
                                                        $totalUsed = array_sum(array_column($leaveBalances, 'used_days'));
                                                        echo number_format($totalUsed, 2);
                                                        ?>
                                                    </h4>
                                                    <small class="text-muted">Total Used Days</small>
                                                </div>
                                                <div class="col-md-3">
                                                    <h4 class="text-info">
                                                        <?php 
                                                        $totalRemaining = array_sum(array_column($leaveBalances, 'remaining_days'));
                                                        echo number_format($totalRemaining, 2);
                                                        ?>
                                                    </h4>
                                                    <small class="text-muted">Total Remaining Days</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <?php endif; ?>
                    </div>

                    <!-- Enhanced Leave History -->
                    <div class="table-container">
                        <h4>My Leave History</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Leave Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Days</th>
                                    <th>Deduction Breakdown</th>
                                    <th>Applied Date</th>
                                    <th>Status</th>
                                    <th>Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($leaveHistory)): ?>
                                    <tr>
                                        <td colspan="8" class="text-center">No leave applications found</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($leaveHistory as $leave): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($leave['leave_type_name']); ?></td>
                                        <td><?php echo formatDate($leave['start_date']); ?></td>
                                        <td><?php echo formatDate($leave['end_date']); ?></td>
                                        <td><?php echo $leave['days_requested']; ?></td>
                                        <td>
                                            <?php if (isset($leave['primary_days'], $leave['annual_days'], $leave['unpaid_days'])): ?>
                                            <small>
                                                <?php if ($leave['primary_days'] > 0): ?>
                                                Primary: <?php echo $leave['primary_days']; ?><br>
                                                <?php endif; ?>
                                                <?php if ($leave['annual_days'] > 0): ?>
                                                Annual: <?php echo $leave['annual_days']; ?><br>
                                                <?php endif; ?>
                                                <?php if ($leave['unpaid_days'] > 0): ?>
                                                <span style="color: #dc3545;">Unpaid: <?php echo $leave['unpaid_days']; ?></span>
                                                <?php endif; ?>
                                            </small>
                                            <?php else: ?>
                                            <small class="text-muted">Not specified</small>
                                            <?php endif; ?>
                                        </td>
                                        <td><?php echo formatDate($leave['applied_at']); ?></td>
                                        <td>
                                            <span class="badge <?php echo getStatusBadgeClass($leave['status']); ?>">
                                                <?php echo getStatusDisplayName($leave['status']); ?>
                                            </span>
                                        </td>
                                        <td><?php echo htmlspecialchars(substr($leave['reason'], 0, 50) . (strlen($leave['reason']) > 50 ? '...' : '')); ?></td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Quick Actions -->
                    <div class="action-buttons mt-4">
                        <a href="leave_management.php" class="btn btn-primary">Apply for New Leave</a>
                    </div>

                <?php else: ?>
                    <div class="alert alert-warning">
                        Employee record not found. Please contact HR to resolve this issue.
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</body>
</html>