<?php
session_start();
require_once 'config.php';
require_once 'auth_check.php'; // Optional but recommended for security

header('Content-Type: application/json');

if (!isset($_GET['employee_id']) || !is_numeric($_GET['employee_id'])) {
    echo json_encode([]);
    exit;
}

$employeeId = (int)$_GET['employee_id'];
$conn = getConnection();

// === SECURITY: Only allow access if user has permission ===
$userRole = $_SESSION['user_role'] ?? '';
$allowed = false;

// Get logged-in user's employee ID
$stmt = $conn->prepare("SELECT e.id, e.department_id, e.section_id, e.subsection_id 
                        FROM employees e 
                        JOIN users u ON u.employee_id = e.employee_id 
                        WHERE u.id = ?");
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$userEmp = $stmt->get_result()->fetch_assoc();

if (in_array($userRole, ['hr_manager', 'super_admin', 'managing_director'])) {
    $allowed = true;
} elseif ($userRole === 'dept_head' && $userEmp && $userEmp['department_id']) {
    $stmt = $conn->prepare("SELECT 1 FROM employees WHERE id = ? AND department_id = ?");
    $stmt->bind_param("ii", $employeeId, $userEmp['department_id']);
    $stmt->execute();
    $allowed = $stmt->get_result()->num_rows > 0;
} elseif ($userRole === 'section_head' && $userEmp && $userEmp['section_id']) {
    $stmt = $conn->prepare("SELECT 1 FROM employees WHERE id = ? AND section_id = ?");
    $stmt->bind_param("ii", $employeeId, $userEmp['section_id']);
    $stmt->execute();
    $allowed = $stmt->get_result()->num_rows > 0;
} elseif ($userRole === 'sub_section_head' && $userEmp && $userEmp['subsection_id']) {
    $stmt = $conn->prepare("SELECT 1 FROM employees WHERE id = ? AND subsection_id = ?");
    $stmt->bind_param("ii", $employeeId, $userEmp['subsection_id']);
    $stmt->execute();
    $allowed = $stmt->get_result()->num_rows > 0;
} else {
    // Regular user: only self
    $allowed = ($userEmp && $userEmp['id'] == $employeeId);
}

if (!$allowed) {
    echo json_encode([]);
    exit;
}

// === GET CURRENT FINANCIAL YEAR (same logic as leave_management.php) ===
function getCurrentFinancialYearId($conn) {
    $fyStmt = $conn->prepare("SELECT id FROM financial_years WHERE end_date >= CURDATE() ORDER BY id DESC LIMIT 1");
    $fyStmt->execute();
    $fyResult = $fyStmt->get_result();
    $fy = $fyResult->fetch_assoc();
    if (!$fy) {
        $fyStmt = $conn->prepare("SELECT id FROM financial_years ORDER BY id DESC LIMIT 1");
        $fyStmt->execute();
        $fyResult = $fyStmt->get_result();
        $fy = $fyResult->fetch_assoc();
        if (!$fy) {
            return null;
        }
    }
    return $fy['id'];
}

$current_fy_id = getCurrentFinancialYearId($conn);
if (!$current_fy_id) {
    echo json_encode([]);
    exit;
}

// === FETCH LEAVE BALANCES FOR CURRENT FY ===
$stmt = $conn->prepare("
    SELECT 
        elb.leave_type_id,
        lt.name as leave_type_name,
        elb.total_days,
        elb.allocated_days,
        elb.used_days,
        elb.remaining_days,
        lt.counts_weekends,
        lt.deducted_from_annual
    FROM employee_leave_balances elb
    JOIN leave_types lt ON elb.leave_type_id = lt.id
    WHERE elb.employee_id = ? 
      AND elb.financial_year_id = ?
      AND lt.is_active = 1
    ORDER BY lt.name
");
$stmt->bind_param("ii", $employeeId, $current_fy_id);
$stmt->execute();
$result = $stmt->get_result();

$balances = [];
while ($row = $result->fetch_assoc()) {
    $balances[] = [
        'leave_type_id' => (int)$row['leave_type_id'],
        'leave_type_name' => $row['leave_type_name'],
        'total_days' => (float)$row['total_days'],
        'allocated_days' => (float)$row['allocated_days'],
        'used_days' => (float)$row['used_days'],
        'remaining_days' => (float)$row['remaining_days'],
        'counts_weekends' => (int)$row['counts_weekends'],
        'deducted_from_annual' => (int)$row['deducted_from_annual']
    ];
}

echo json_encode($balances);