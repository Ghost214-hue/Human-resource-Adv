<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

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

// Get current user from session
$user = [
    'first_name' => $_SESSION['user_name'] ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => $_SESSION['user_name'] ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// Helper functions
function getAllowanceStatusBadge($status) {
    $badges = [
        'active' => 'badge-success',
        'inactive' => 'badge-danger',
        'pending' => 'badge-warning'
    ];
    return $badges[$status] ?? 'badge-light';
}

function formatDate($date) {
    if (!$date) return 'N/A';
    return date('M d, Y', strtotime($date));
}

function getFlashMessage() {
    if (isset($_SESSION['flash_message'])) {
        $message = $_SESSION['flash_message'];
        $type = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);
        return ['message' => $message, 'type' => $type];
    }
    return false;
}

// Function to get employee ID from user ID
function getEmployeeIdFromUserId($conn, $user_id) {
    $user_id = $conn->real_escape_string($user_id);
    
    // Get the employee_id from users table first
    $query = "SELECT employee_id FROM users WHERE id = '$user_id'";
    $result = $conn->query($query);
    
    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        $employee_id_from_user = $user['employee_id'];
        
        // Now find the corresponding id in employees table
        $employeeQuery = "SELECT id FROM employees WHERE employee_id = '$employee_id_from_user'";
        $employeeResult = $conn->query($employeeQuery);
        
        if ($employeeResult && $employeeResult->num_rows > 0) {
            $employee = $employeeResult->fetch_assoc();
            return $employee['id']; // This is the correct ID for the foreign key
        }
    }
    
    // Fallback: Get first admin user's employee ID from employees table
    $adminQuery = "SELECT e.id FROM employees e 
                  JOIN users u ON e.employee_id = u.employee_id 
                  WHERE u.role IN ('super_admin', 'hr_manager') 
                  LIMIT 1";
    $adminResult = $conn->query($adminQuery);
    if ($adminResult && $adminResult->num_rows > 0) {
        $admin = $adminResult->fetch_assoc();
        return $admin['id'];
    }
    
    return 1; // Final fallback
}

// Function to get allowance amount
function getAllowanceAmount($conn, $emp_id, $allowance_type_id) {
    $emp_id = $conn->real_escape_string($emp_id);
    $allowance_type_id = $conn->real_escape_string($allowance_type_id);
    
    $scaleQuery = "SELECT scale_id FROM employees WHERE id = '$emp_id'";
    $scaleResult = $conn->query($scaleQuery);
    
    if ($scaleResult && $scaleResult->num_rows > 0) {
        $employee = $scaleResult->fetch_assoc();
        $scale_id = $employee['scale_id'];
        
        $amountQuery = "SELECT ";
        if ($allowance_type_id == 1) { // House allowance
            $amountQuery .= "house_allowance";
        } else if ($allowance_type_id == 2) { // Commuter allowance
            $amountQuery .= "commuter_allowance";
        } else if ($allowance_type_id == 3 || $allowance_type_id == 6) { // Dirty allowance
            $amountQuery .= "dirty_allowance";
        } else if ($allowance_type_id == 5) { // Leave allowance
            $amountQuery .= "leave_allowance";
        } else {
            $amountQuery .= "0";
        }
        $amountQuery .= " as amount FROM salary_bands WHERE scale_id = '$scale_id'";
        
        $amountResult = $conn->query($amountQuery);
        if ($amountResult && $amountResult->num_rows > 0) {
            $amountData = $amountResult->fetch_assoc();
            return ['success' => true, 'amount' => $amountData['amount']];
        } else {
            return ['success' => false, 'message' => 'No salary band found for this scale'];
        }
    } else {
        return ['success' => false, 'message' => 'Employee not found or no scale assigned'];
    }
}

// Database connection
$conn = getConnection();

// Get the employee ID for the current user
$current_employee_id = getEmployeeIdFromUserId($conn, $user['id']);

// Handle allowance type actions
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['add_allowance_type']) && hasPermission('hr_manager')) {
        $type_name = $conn->real_escape_string($_POST['type_name']);
        $description = $conn->real_escape_string($_POST['description']);
        $is_active = isset($_POST['is_active']) ? 1 : 0;
        
        $insertQuery = "INSERT INTO allowance_types (type_name, description, is_active, created_at, updated_at) 
                        VALUES ('$type_name', '$description', $is_active, NOW(), NOW())";
        
        if ($conn->query($insertQuery)) {
            $_SESSION['flash_message'] = "Allowance type added successfully";
            $_SESSION['flash_type'] = "success";
            header("Location: allowances.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error adding allowance type: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['update_allowance_type']) && hasPermission('hr_manager')) {
        $allowance_type_id = $conn->real_escape_string($_POST['allowance_type_id']);
        $type_name = $conn->real_escape_string($_POST['type_name']);
        $description = $conn->real_escape_string($_POST['description']);
        $is_active = isset($_POST['is_active']) ? 1 : 0;
        
        $updateQuery = "UPDATE allowance_types SET 
                        type_name = '$type_name',
                        description = '$description',
                        is_active = $is_active,
                        updated_at = NOW()
                        WHERE allowance_type_id = '$allowance_type_id'";
        
        if ($conn->query($updateQuery)) {
            $_SESSION['flash_message'] = "Allowance type updated successfully";
            $_SESSION['flash_type'] = "success";
            header("Location: allowances.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error updating allowance type: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['add_allowance']) && hasPermission('hr_manager')) {
        $emp_id = $conn->real_escape_string($_POST['emp_id']);
        $allowance_type_id = $conn->real_escape_string($_POST['allowance_type_id']);
        $effective_date = $conn->real_escape_string($_POST['effective_date']);
        $end_date = !empty($_POST['end_date']) ? "'" . $conn->real_escape_string($_POST['end_date']) . "'" : "NULL";
        $status = $conn->real_escape_string($_POST['status']);
        $created_by = $current_employee_id; // Use employee ID instead of user ID
        
        $amountData = getAllowanceAmount($conn, $emp_id, $allowance_type_id);
        if ($amountData['success']) {
            $amount = $amountData['amount'];
            $insertQuery = "INSERT INTO employee_allowances (emp_id, allowance_type_id, amount, effective_date, end_date, status, created_by, created_at, updated_at) 
                            VALUES ('$emp_id', '$allowance_type_id', '$amount', '$effective_date', $end_date, '$status', '$created_by', NOW(), NOW())";
            
            if ($conn->query($insertQuery)) {
                $_SESSION['flash_message'] = "Allowance added successfully based on job group";
                $_SESSION['flash_type'] = "success";
                header("Location: allowances.php");
                exit();
            } else {
                $_SESSION['flash_message'] = "Error adding allowance: " . $conn->error;
                $_SESSION['flash_type'] = "danger";
            }
        } else {
            $_SESSION['flash_message'] = "Error: " . $amountData['message'];
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['update_allowance']) && hasPermission('hr_manager')) {
        $allowance_id = $conn->real_escape_string($_POST['allowance_id']);
        $allowance_type_id = $conn->real_escape_string($_POST['allowance_type_id']);
        $amount = $conn->real_escape_string($_POST['amount']);
        $effective_date = $conn->real_escape_string($_POST['effective_date']);
        $end_date = !empty($_POST['end_date']) ? "'" . $conn->real_escape_string($_POST['end_date']) . "'" : "NULL";
        $status = $conn->real_escape_string($_POST['status']);
        
        $updateQuery = "UPDATE employee_allowances SET 
                        allowance_type_id = '$allowance_type_id',
                        amount = '$amount',
                        effective_date = '$effective_date',
                        end_date = $end_date,
                        status = '$status',
                        updated_at = NOW()
                        WHERE allowance_id = '$allowance_id'";
        
        if ($conn->query($updateQuery)) {
            $_SESSION['flash_message'] = "Allowance updated successfully";
            $_SESSION['flash_type'] = "success";
            header("Location: allowances.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error updating allowance: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['bulk_assign']) && hasPermission('hr_manager')) {
        $allowance_type_id = $conn->real_escape_string($_POST['allowance_type_id']);
        $scale_id = $conn->real_escape_string($_POST['scale_id']);
        $effective_date = $conn->real_escape_string($_POST['effective_date']);
        $status = $conn->real_escape_string($_POST['status']);
        $created_by = $current_employee_id; // Use employee ID instead of user ID
        
        $amountQuery = "SELECT ";
        if ($allowance_type_id == 1) {
            $amountQuery .= "house_allowance";
        } else if ($allowance_type_id == 2) {
            $amountQuery .= "commuter_allowance";
        } else if ($allowance_type_id == 3 || $allowance_type_id == 6) {
            $amountQuery .= "dirty_allowance";
        } else if ($allowance_type_id == 5) {
            $amountQuery .= "leave_allowance";
        } else {
            $amountQuery .= "0";
        }
        $amountQuery .= " as amount FROM salary_bands WHERE scale_id = '$scale_id'";
        
        $amountResult = $conn->query($amountQuery);
        if ($amountResult && $amountResult->num_rows > 0) {
            $amountData = $amountResult->fetch_assoc();
            $amount = $amountData['amount'];
            
            $employeesQuery = "SELECT id FROM employees WHERE scale_id = '$scale_id'";
            $employeesResult = $conn->query($employeesQuery);
            
            $successCount = 0;
            $errorCount = 0;
            
            while ($employee = $employeesResult->fetch_assoc()) {
                $emp_id = $employee['id'];
                
                $checkQuery = "SELECT allowance_id FROM employee_allowances 
                              WHERE emp_id = '$emp_id' AND allowance_type_id = '$allowance_type_id' 
                              AND status = 'active'";
                $checkResult = $conn->query($checkQuery);
                
                if ($checkResult->num_rows == 0) {
                    $insertQuery = "INSERT INTO employee_allowances (emp_id, allowance_type_id, amount, effective_date, status, created_by, created_at, updated_at) 
                                    VALUES ('$emp_id', '$allowance_type_id', '$amount', '$effective_date', '$status', '$created_by', NOW(), NOW())";
                    
                    if ($conn->query($insertQuery)) {
                        $successCount++;
                    } else {
                        $errorCount++;
                    }
                }
            }
            
            $_SESSION['flash_message'] = "Bulk assignment complete: $successCount allowances added, $errorCount errors";
            $_SESSION['flash_type'] = $errorCount > 0 ? "warning" : "success";
            header("Location: allowances.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error: Could not determine allowance amount for this job group";
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['allocate_selected']) && hasPermission('hr_manager')) {
        $period_id = $conn->real_escape_string($_POST['period_id']);
        $allowance_type_id = $conn->real_escape_string($_POST['allowance_type_id']);
        $effective_date = $conn->real_escape_string($_POST['effective_date']);
        $end_date = !empty($_POST['end_date']) ? "'" . $conn->real_escape_string($_POST['end_date']) . "'" : "NULL";
        $status = $conn->real_escape_string($_POST['status']);
        $created_by = $current_employee_id; // Use employee ID instead of user ID
        $use_auto_amount = isset($_POST['use_auto_amount']);
        $fixed_amount = $use_auto_amount ? 0 : $conn->real_escape_string($_POST['amount']);
        $emp_ids = $_POST['emp_ids'] ?? [];
        
        $successCount = 0;
        $errorCount = 0;
        
        foreach ($emp_ids as $emp_id_val) {
            $emp_id = $conn->real_escape_string($emp_id_val);
            
            if ($use_auto_amount) {
                $amountData = getAllowanceAmount($conn, $emp_id, $allowance_type_id);
                if (!$amountData['success']) {
                    $errorCount++;
                    continue;
                }
                $amount = $amountData['amount'];
            } else {
                $amount = $fixed_amount;
            }
            
            $checkQuery = "SELECT allowance_id FROM employee_allowances 
                          WHERE emp_id = '$emp_id' AND allowance_type_id = '$allowance_type_id' 
                          AND period_id = '$period_id' AND status = 'active'";
            $checkResult = $conn->query($checkQuery);
            
            if ($checkResult->num_rows == 0) {
                $insertQuery = "INSERT INTO employee_allowances (period_id, emp_id, allowance_type_id, amount, effective_date, end_date, status, created_by, created_at, updated_at) 
                                VALUES ('$period_id', '$emp_id', '$allowance_type_id', '$amount', '$effective_date', $end_date, '$status', '$created_by', NOW(), NOW())";
                
                if ($conn->query($insertQuery)) {
                    $successCount++;
                } else {
                    $errorCount++;
                }
            }
        }
        
        $_SESSION['flash_message'] = "Allocation complete: $successCount allowances added, $errorCount errors";
        $_SESSION['flash_type'] = $errorCount > 0 ? "warning" : "success";
        header("Location: allowances.php");
        exit();
    }
}

if (isset($_GET['action']) && $_GET['action'] == 'delete_allowance_type' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $deleteQuery = "DELETE FROM allowance_types WHERE allowance_type_id = '$id'";
    if ($conn->query($deleteQuery)) {
        $_SESSION['flash_message'] = "Allowance type deleted successfully";
        $_SESSION['flash_type'] = "success";
        header("Location: allowances.php");
        exit();
    } else {
        $_SESSION['flash_message'] = "Error deleting allowance type: " . $conn->error;
        $_SESSION['flash_type'] = "danger";
    }
}

if (isset($_GET['action']) && $_GET['action'] == 'delete' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $deleteQuery = "DELETE FROM employee_allowances WHERE allowance_id = '$id'";
    if ($conn->query($deleteQuery)) {
        $_SESSION['flash_message'] = "Allowance record deleted successfully";
        $_SESSION['flash_type'] = "success";
        header("Location: allowances.php");
        exit();
    } else {
        $_SESSION['flash_message'] = "Error deleting record: " . $conn->error;
        $_SESSION['flash_type'] = "danger";
    }
}

// Handle inline allowance amount request
$allowanceAmountResponse = null;
if (isset($_POST['get_amount']) && isset($_POST['emp_id']) && isset($_POST['allowance_type_id'])) {
    $allowanceAmountResponse = getAllowanceAmount($conn, $_POST['emp_id'], $_POST['allowance_type_id']);
    header('Content-Type: application/json');
    echo json_encode($allowanceAmountResponse);
    $conn->close();
    exit();
}

// Fetch all employees for dropdown and list
$employees = [];
$employeesQuery = "SELECT id, first_name, last_name, scale_id FROM employees ORDER BY first_name, last_name";
$employeesResult = $conn->query($employeesQuery);
if ($employeesResult && $employeesResult->num_rows > 0) {
    while ($employee = $employeesResult->fetch_assoc()) {
        $employees[] = $employee;
    }
}

// Fetch all allowance types
$allowanceTypes = [];
$typesQuery = "SELECT allowance_type_id, type_name FROM allowance_types WHERE is_active = TRUE ORDER BY type_name";
$typesResult = $conn->query($typesQuery);
if ($typesResult && $typesResult->num_rows > 0) {
    while ($type = $typesResult->fetch_assoc()) {
        $allowanceTypes[$type['allowance_type_id']] = $type['type_name'];
    }
}

// Fetch all allowance types for management
$allAllowanceTypes = [];
$allTypesQuery = "SELECT allowance_type_id, type_name, description, is_active, created_at, updated_at 
                  FROM allowance_types ORDER BY type_name";
$allTypesResult = $conn->query($allTypesQuery);
if ($allTypesResult && $allTypesResult->num_rows > 0) {
    while ($type = $allTypesResult->fetch_assoc()) {
        $allAllowanceTypes[] = $type;
    }
}

// Fetch all periods
$periods = [];
$periodsQuery = "SELECT id, CONCAT(period_name) AS period_name FROM payroll_periods ORDER BY start_date DESC";
$periodsResult = $conn->query($periodsQuery);
if ($periodsResult && $periodsResult->num_rows > 0) {
    while ($period = $periodsResult->fetch_assoc()) {
        $periods[$period['id']] = $period['period_name'];
    }
}

// Fetch all salary bands for bulk assignment
$salaryBands = [];
$bandsQuery = "SELECT scale_id FROM salary_bands ORDER BY scale_id";
$bandsResult = $conn->query($bandsQuery);
if ($bandsResult && $bandsResult->num_rows > 0) {
    while ($band = $bandsResult->fetch_assoc()) {
        $salaryBands[] = $band['scale_id'];
    }
}

// Get record for editing if action is edit
$editRecord = null;
if (isset($_GET['action']) && $_GET['action'] == 'edit' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $editQuery = "SELECT ea.*, e.first_name, e.last_name, e.scale_id, at.type_name 
                  FROM employee_allowances ea
                  JOIN employees e ON ea.emp_id = e.id
                  JOIN allowance_types at ON ea.allowance_type_id = at.allowance_type_id
                  WHERE ea.allowance_id = '$id'";
    $editResult = $conn->query($editQuery);
    if ($editResult && $editResult->num_rows > 0) {
        $editRecord = $editResult->fetch_assoc();
    } else {
        $_SESSION['flash_message'] = "Error fetching record: " . ($editResult ? "No record found" : $conn->error);
        $_SESSION['flash_type'] = "danger";
        header("Location: allowances.php");
        exit();
    }
}

// Get allowance type for editing
$editAllowanceType = null;
if (isset($_GET['action']) && $_GET['action'] == 'edit_allowance_type' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $editQuery = "SELECT * FROM allowance_types WHERE allowance_type_id = '$id'";
    $editResult = $conn->query($editQuery);
    if ($editResult && $editResult->num_rows > 0) {
        $editAllowanceType = $editResult->fetch_assoc();
    } else {
        $_SESSION['flash_message'] = "Error fetching allowance type: " . ($editResult ? "No record found" : $conn->error);
        $_SESSION['flash_type'] = "danger";
        header("Location: allowances.php");
        exit();
    }
}

// Pagination and sorting for allowances
$rowsPerPage = isset($_GET['rows']) && in_array($_GET['rows'], [25, 50, 100, 250, 500]) ? (int)$_GET['rows'] : 25;
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$offset = ($page - 1) * $rowsPerPage;

$sortBy = isset($_GET['sort']) && in_array($_GET['sort'], ['allowance_id', 'emp_id', 'type_name', 'amount', 'status']) ? $_GET['sort'] : 'allowance_id';
$sortOrder = isset($_GET['order']) && strtoupper($_GET['order']) === 'DESC' ? 'DESC' : 'ASC';
$filter = isset($_GET['search']) ? $conn->real_escape_string($_GET['search']) : '';

$whereClause = '';
if ($filter) {
    $whereClause = "WHERE e.first_name LIKE '%$filter%' OR e.last_name LIKE '%$filter%' OR at.type_name LIKE '%$filter%' OR e.scale_id LIKE '%$filter%'";
}

$countQuery = "SELECT COUNT(*) as count FROM employee_allowances ea
               JOIN employees e ON ea.emp_id = e.id
               JOIN allowance_types at ON ea.allowance_type_id = at.allowance_type_id
               $whereClause";
$countResult = $conn->query($countQuery);
$totalRecords = $countResult->fetch_assoc()['count'];
$totalPages = ceil($totalRecords / $rowsPerPage);

$query = "SELECT ea.allowance_id, ea.emp_id, ea.allowance_type_id, ea.amount, ea.effective_date, 
                 ea.end_date, ea.status, e.first_name, e.last_name, e.scale_id, at.type_name 
          FROM employee_allowances ea
          JOIN employees e ON ea.emp_id = e.id
          JOIN allowance_types at ON ea.allowance_type_id = at.allowance_type_id
          $whereClause 
          ORDER BY $sortBy $sortOrder 
          LIMIT $offset, $rowsPerPage";
$result = $conn->query($query);

$allowanceRecords = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $allowanceRecords[] = $row;
    }
} else {
    $_SESSION['flash_message'] = "Error fetching records: " . $conn->error;
    $_SESSION['flash_type'] = "danger";
}

// Pagination and sorting for allowance types
$typesRowsPerPage = isset($_GET['types_rows']) && in_array($_GET['types_rows'], [25, 50, 100]) ? (int)$_GET['types_rows'] : 25;
$typesPage = isset($_GET['types_page']) ? max(1, (int)$_GET['types_page']) : 1;
$typesOffset = ($typesPage - 1) * $typesRowsPerPage;

$typesSortBy = isset($_GET['types_sort']) && in_array($_GET['types_sort'], ['allowance_type_id', 'type_name', 'is_active', 'created_at']) ? $_GET['types_sort'] : 'type_name';
$typesSortOrder = isset($_GET['types_order']) && strtoupper($_GET['types_order']) === 'DESC' ? 'DESC' : 'ASC';
$typesFilter = isset($_GET['types_search']) ? $conn->real_escape_string($_GET['types_search']) : '';

$typesWhereClause = '';
if ($typesFilter) {
    $typesWhereClause = "WHERE type_name LIKE '%$typesFilter%' OR description LIKE '%$typesFilter%'";
}

$typesCountQuery = "SELECT COUNT(*) as count FROM allowance_types $typesWhereClause";
$typesCountResult = $conn->query($typesCountQuery);
$typesTotalRecords = $typesCountResult->fetch_assoc()['count'];
$typesTotalPages = ceil($typesTotalRecords / $typesRowsPerPage);

$typesQuery = "SELECT * FROM allowance_types $typesWhereClause 
               ORDER BY $typesSortBy $typesSortOrder 
               LIMIT $typesOffset, $typesRowsPerPage";
$typesResult = $conn->query($typesQuery);

$allAllowanceTypes = [];
if ($typesResult) {
    while ($row = $typesResult->fetch_assoc()) {
        $allAllowanceTypes[] = $row;
    }
}

$conn->close();

$pageTitle = "Allowances Management";
include 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Allowances - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .bulk-assign-section, .allowance-types-section {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .bulk-assign-section h4, .allowance-types-section h4 {
            margin-top: 0;
            color: #ffffff;
        }

        /* Table Styles */
        .table-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: transparent;
        }

        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .table th {
            background: rgba(255, 255, 255, 0.05);
            color: #ffffff;
        }

        .table tr:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }

        .badge-primary {
            background: #2a5298;
        }

        .badge-warning {
            background: #ffc107;
            color: #1e3c72;
        }

        .badge-secondary {
            background: rgba(255, 255, 255, 0.2);
        }

        .badge-success {
            background: #28a745;
        }

        .badge-danger {
            background: #dc3545;
        }

        /* Table Controls */
        .table-controls {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            flex-wrap: nowrap;
        }

        .table-controls label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #ffffff;
            font-size: 14px;
            white-space: nowrap;
        }

        .table-controls select, .table-controls input {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            background: rgba(255, 255, 255, 0.15);
            color: #ffffff;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .table-controls select:hover, .table-controls input:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        .table-controls input {
            min-width: 150px;
        }

        /* Tabs Styles */
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .tabs a {
            padding: 10px 20px;
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px 8px 0 0;
            background: rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .tabs a:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .tabs a.active {
            background: rgba(255, 255, 255, 0.2);
            font-weight: bold;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

        .pagination-links a {
            margin: 0 5px;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
            z-index: 1000;
        }

        .modal-dialog {
            max-width: 500px;
            margin: 100px auto;
        }

        .modal-content {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            padding: 20px;
            color: #ffffff;
        }

        .modal-header, .modal-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
        }

        .modal-body {
            padding: 15px 0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 5px;
            color: #ffffff;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.2);
            color: #ffffff;
            transition: all 0.3s ease;
        }

        .form-control:hover, .form-control:focus {
            background: rgba(255, 255, 255, 0.3);
            outline: none;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }

            .main-content {
                margin-left: 220px;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .table-controls {
                flex-wrap: wrap;
                gap: 10px;
            }

            .tabs {
                flex-wrap: wrap;
                gap: 5px;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 10px;
            }

            .table-controls {
                flex-direction: column;
                align-items: flex-start;
            }

            .tabs {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
      
        <!-- Main Content -->
        <div class="main-content">
            <div class="content">
                <!-- Main Navigation Tabs -->
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

                <!-- Allowance-Specific Tabs -->
                <div class="tabs mb-3">
                    <a href="allowances.php?tab=types" class="<?php echo (!isset($_GET['tab']) || $_GET['tab'] === 'types') ? 'active' : ''; ?>">
                        Allowance Types
                    </a>
                    <a href="allowances.php?tab=allocate" class="<?php echo (isset($_GET['tab']) && $_GET['tab'] === 'allocate') ? 'active' : ''; ?>">
                        Allocate Allowance
                    </a>
                </div>

                <?php $flash = getFlashMessage(); if ($flash): ?>
                    <div class="alert alert-<?php echo $flash['type']; ?>">
                        <?php echo htmlspecialchars($flash['message']); ?>
                    </div>
                <?php endif; ?>

                <!-- ALLOWANCE TYPES TAB (default) -->
                <?php if (!isset($_GET['tab']) || $_GET['tab'] === 'types'): ?>
                <div class="tab-content active">
                    <?php if (hasPermission('hr_manager')): ?>
                    <div class="allowance-types-section">
                        <div class="d-flex justify-between align-center mb-3">
                            <h3>Allowance Types</h3>
                            <button class="btn btn-primary" onclick="document.getElementById('addTypeModal').style.display='block'">
                                <i class="fas fa-plus"></i> Add Allowance Type
                            </button>
                        </div>
                        <div class="table-controls">
                            <form method="GET" action="allowances.php">
                                <input type="hidden" name="tab" value="types">
                                <label for="types_search">Search:</label>
                                <input type="text" id="types_search" name="types_search" value="<?php echo htmlspecialchars($typesFilter); ?>" placeholder="Search by type name or description">
                                <input type="hidden" name="types_page" value="<?php echo $typesPage; ?>">
                                <input type="hidden" name="types_rows" value="<?php echo $typesRowsPerPage; ?>">
                                <input type="hidden" name="types_sort" value="<?php echo $typesSortBy; ?>">
                                <input type="hidden" name="types_order" value="<?php echo $typesSortOrder; ?>">
                                <button type="submit" class="btn btn-sm btn-primary">Search</button>
                            </form>
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Type Name</th>
                                    <th>Description</th>
                                    <th>Active</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($allAllowanceTypes)): ?>
                                    <tr>
                                        <td colspan="6" class="text-center">No allowance types found</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($allAllowanceTypes as $type): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($type['type_name']); ?></td>
                                        <td><?php echo htmlspecialchars($type['description']); ?></td>
                                        <td><?php echo $type['is_active'] ? 'Yes' : 'No'; ?></td>
                                        <td><?php echo formatDate($type['created_at']); ?></td>
                                        <td><?php echo formatDate($type['updated_at']); ?></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary edit-type-btn" 
                                                    data-id="<?php echo $type['allowance_type_id']; ?>"
                                                    data-type-name="<?php echo htmlspecialchars($type['type_name']); ?>"
                                                    data-description="<?php echo htmlspecialchars($type['description']); ?>"
                                                    data-is-active="<?php echo $type['is_active']; ?>">
                                                Edit
                                            </button>
                                            <button class="btn btn-sm btn-danger delete-type-btn" 
                                                    data-id="<?php echo $type['allowance_type_id']; ?>"
                                                    data-name="<?php echo htmlspecialchars($type['type_name']); ?>">
                                                Delete
                                            </button>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                        <!-- Pagination for Allowance Types -->
                        <div class="pagination">
                            <p>Showing <?php echo min($typesTotalRecords, $typesOffset + 1); ?> to <?php echo min($typesTotalRecords, $typesOffset + $typesRowsPerPage); ?> of <?php echo $typesTotalRecords; ?> entries</p>
                            <div class="pagination-links">
                                <?php if ($typesPage > 1): ?>
                                    <a href="allowances.php?tab=types&types_page=<?php echo $typesPage - 1; ?>&types_rows=<?php echo $typesRowsPerPage; ?>&types_sort=<?php echo $typesSortBy; ?>&types_order=<?php echo $typesSortOrder; ?>&types_search=<?php echo urlencode($typesFilter); ?>" class="btn btn-sm btn-secondary">Previous</a>
                                <?php endif; ?>
                                <?php for ($i = 1; $i <= $typesTotalPages; $i++): ?>
                                    <a href="allowances.php?tab=types&types_page=<?php echo $i; ?>&types_rows=<?php echo $typesRowsPerPage; ?>&types_sort=<?php echo $typesSortBy; ?>&types_order=<?php echo $typesSortOrder; ?>&types_search=<?php echo urlencode($typesFilter); ?>" class="btn btn-sm <?php echo $i == $typesPage ? 'btn-primary' : 'btn-secondary'; ?>"><?php echo $i; ?></a>
                                <?php endfor; ?>
                                <?php if ($typesPage < $typesTotalPages): ?>
                                    <a href="allowances.php?tab=types&types_page=<?php echo $typesPage + 1; ?>&types_rows=<?php echo $typesRowsPerPage; ?>&types_sort=<?php echo $typesSortBy; ?>&types_order=<?php echo $typesSortOrder; ?>&types_search=<?php echo urlencode($typesFilter); ?>" class="btn btn-sm btn-secondary">Next</a>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>

                <!-- ALLOCATE ALLOWANCE TAB -->
                <?php if (isset($_GET['tab']) && $_GET['tab'] === 'allocate'): ?>
                <div class="tab-content active">
                    <?php if (hasPermission('hr_manager')): ?>
                    <div class="bulk-assign-section">
                        <h4>Allocate Allowances to Selected Employees</h4>
                        <form method="POST" action="allowances.php">
                            <input type="hidden" name="allocate_selected" value="1">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="alloc_period_id">Period</label>
                                    <select class="form-control" id="alloc_period_id" name="period_id" required>
                                        <option value="">Select Period</option>
                                        <?php foreach ($periods as $id => $name): ?>
                                            <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="alloc_allowance_type_id">Allowance Type</label>
                                    <select class="form-control" id="alloc_allowance_type_id" name="allowance_type_id" required>
                                        <option value="">Select Allowance Type</option>
                                        <?php foreach ($allowanceTypes as $id => $name): ?>
                                            <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><input type="checkbox" name="use_auto_amount" id="use_auto_amount" onclick="toggleAmountInput()"> Use job group based amount</label>
                                </div>
                                <div class="form-group" id="amount_group">
                                    <label class="form-label" for="alloc_amount">Fixed Amount</label>
                                    <input type="number" step="0.01" class="form-control" id="alloc_amount" name="amount" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="alloc_effective_date">Effective Date</label>
                                    <input type="date" class="form-control" id="alloc_effective_date" name="effective_date" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="alloc_end_date">End Date (Optional)</label>
                                    <input type="date" class="form-control" id="alloc_end_date" name="end_date">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="alloc_status">Status</label>
                                    <select class="form-control" id="alloc_status" name="status" required>
                                        <option value="active">Active</option>
                                        <option value="inactive">Inactive</option>
                                        <option value="pending">Pending</option>
                                    </select>
                                </div>
                            </div>
                            <div class="table-container">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><input type="checkbox" id="select_all" onclick="toggleSelectAll()"></th>
                                            <th>Employee Name</th>
                                            <th>Scale</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($employees as $employee): ?>
                                        <tr>
                                            <td><input type="checkbox" name="emp_ids[]" value="<?php echo $employee['id']; ?>" class="emp-checkbox"></td>
                                            <td><?php echo htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name']); ?></td>
                                            <td><?php echo htmlspecialchars($employee['scale_id'] ?? 'N/A'); ?></td>
                                        </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <button type="submit" class="btn btn-primary">Allocate Allowance</button>
                        </form>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- === MODALS (unchanged, kept at bottom) === -->
    <!-- Add Allowance Modal -->
    <div id="addModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Allowance</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="allowances.php" id="addAllowanceForm">
                    <div class="modal-body">
                        <input type="hidden" name="add_allowance" value="1">
                        <div class="form-group">
                            <label class="form-label" for="add_emp_id">Employee</label>
                            <select class="form-control" id="add_emp_id" name="emp_id" required onchange="updateAllowanceAmount()">
                                <option value="">Select Employee</option>
                                <?php foreach ($employees as $employee): ?>
                                    <option value="<?php echo $employee['id']; ?>"><?php echo htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name'] . ($employee['scale_id'] ? ' (Scale ' . $employee['scale_id'] . ')' : '')); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_allowance_type_id">Allowance Type</label>
                            <select class="form-control" id="add_allowance_type_id" name="allowance_type_id" required onchange="updateAllowanceAmount()">
                                <option value="">Select Allowance Type</option>
                                <?php foreach ($allowanceTypes as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_amount">Amount (Automatically determined by job group)</label>
                            <input type="text" class="form-control" id="add_amount_display" readonly>
                            <small class="text-muted">This amount is based on the employee's job group</small>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="add_effective_date">Effective Date</label>
                                <input type="date" class="form-control" id="add_effective_date" name="effective_date" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="add_end_date">End Date (Optional)</label>
                                <input type="date" class="form-control" id="add_end_date" name="end_date">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_status">Status</label>
                            <select class="form-control" id="add_status" name="status" required>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                                <option value="pending">Pending</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Allowance</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Allowance Modal -->
    <div id="editModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Allowance</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="allowances.php">
                    <div class="modal-body">
                        <input type="hidden" name="allowance_id" id="edit_allowance_id">
                        <input type="hidden" name="update_allowance" value="1">
                        <div class="form-group">
                            <label class="form-label" for="edit_emp_id">Employee</label>
                            <select class="form-control" id="edit_emp_id" name="emp_id" disabled>
                                <?php foreach ($employees as $employee): ?>
                                    <option value="<?php echo $employee['id']; ?>"><?php echo htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name'] . ($employee['scale_id'] ? ' (Scale ' . $employee['scale_id'] . ')' : '')); ?></option>
                                <?php endforeach; ?>
                            </select>
                            <small class="text-muted">Employee cannot be changed</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_allowance_type_id">Allowance Type</label>
                            <select class="form-control" id="edit_allowance_type_id" name="allowance_type_id" required>
                                <option value="">Select Allowance Type</option>
                                <?php foreach ($allowanceTypes as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_amount">Amount</label>
                            <input type="number" step="0.01" class="form-control" id="edit_amount" name="amount" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="edit_effective_date">Effective Date</label>
                                <input type="date" class="form-control" id="edit_effective_date" name="effective_date" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="edit_end_date">End Date (Optional)</label>
                                <input type="date" class="form-control" id="edit_end_date" name="end_date">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_status">Status</label>
                            <select class="form-control" id="edit_status" name="status" required>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                                <option value="pending">Pending</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Allowance</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Allowance Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the allowance record for <span id="delete_allowance_name"></span>?</p>
                    <p class="text-danger"><strong>This action cannot be undone.</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <a id="delete_confirm_btn" href="#" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Allowance Type Modal -->
    <div id="addTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Allowance Type</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="allowances.php">
                    <div class="modal-body">
                        <input type="hidden" name="add_allowance_type" value="1">
                        <div class="form-group">
                            <label class="form-label" for="add_type_name">Type Name</label>
                            <input type="text" class="form-control" id="add_type_name" name="type_name" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_description">Description</label>
                            <textarea class="form-control" id="add_description" name="description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_is_active">Active</label>
                            <input type="checkbox" id="add_is_active" name="is_active" checked>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Allowance Type</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Allowance Type Modal -->
    <div id="editTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Allowance Type</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="allowances.php">
                    <div class="modal-body">
                        <input type="hidden" name="allowance_type_id" id="edit_type_id">
                        <input type="hidden" name="update_allowance_type" value="1">
                        <div class="form-group">
                            <label class="form-label" for="edit_type_name">Type Name</label>
                            <input type="text" class="form-control" id="edit_type_name" name="type_name" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_description">Description</label>
                            <textarea class="form-control" id="edit_description" name="description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_is_active">Active</label>
                            <input type="checkbox" id="edit_is_active" name="is_active">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Allowance Type</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Allowance Type Modal -->
    <div id="deleteTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the allowance type <span id="delete_type_name"></span>?</p>
                    <p class="text-danger"><strong>This action cannot be undone.</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <a id="delete_type_confirm_btn" href="#" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Handle edit button clicks for allowances
        document.querySelectorAll('.edit-btn').forEach(button => {
            button.addEventListener('click', function () {
                const allowanceId = this.getAttribute('data-id');
                const empId = this.getAttribute('data-emp-id');
                const typeId = this.getAttribute('data-type-id');
                const amount = this.getAttribute('data-amount');
                const effectiveDate = this.getAttribute('data-effective-date');
                const endDate = this.getAttribute('data-end-date');
                const status = this.getAttribute('data-status');
                document.getElementById('edit_allowance_id').value = allowanceId;
                document.getElementById('edit_emp_id').value = empId;
                document.getElementById('edit_allowance_type_id').value = typeId;
                document.getElementById('edit_amount').value = amount;
                document.getElementById('edit_effective_date').value = effectiveDate;
                document.getElementById('edit_end_date').value = endDate;
                document.getElementById('edit_status').value = status;
                document.getElementById('editModal').style.display = 'block';
            });
        });
        // Handle delete button clicks for allowances
        document.querySelectorAll('.delete-btn').forEach(button => {
            button.addEventListener('click', function () {
                const allowanceId = this.getAttribute('data-id');
                const name = this.getAttribute('data-name');
                document.getElementById('delete_allowance_name').textContent = name;
                document.getElementById('delete_confirm_btn').href = `allowances.php?action=delete&id=${allowanceId}`;
                document.getElementById('deleteModal').style.display = 'block';
            });
        });
        // Handle edit button clicks for allowance types
        document.querySelectorAll('.edit-type-btn').forEach(button => {
            button.addEventListener('click', function () {
                const typeId = this.getAttribute('data-id');
                const typeName = this.getAttribute('data-type-name');
                const description = this.getAttribute('data-description');
                const isActive = this.getAttribute('data-is-active') === '1';
                document.getElementById('edit_type_id').value = typeId;
                document.getElementById('edit_type_name').value = typeName;
                document.getElementById('edit_description').value = description;
                document.getElementById('edit_is_active').checked = isActive;
                document.getElementById('editTypeModal').style.display = 'block';
            });
        });
        // Handle delete button clicks for allowance types
        document.querySelectorAll('.delete-type-btn').forEach(button => {
            button.addEventListener('click', function () {
                const typeId = this.getAttribute('data-id');
                const name = this.getAttribute('data-name');
                document.getElementById('delete_type_name').textContent = name;
                document.getElementById('delete_type_confirm_btn').href = `allowances.php?action=delete_allowance_type&id=${typeId}`;
                document.getElementById('deleteTypeModal').style.display = 'block';
            });
        });
        // Close modals when clicking on X
        document.querySelectorAll('.close').forEach(button => {
            button.addEventListener('click', function () {
                this.closest('.modal').style.display = 'none';
            });
        });
        // Close modals when clicking outside
        window.addEventListener('click', function (event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        });
        // Open add modal for allowances
        document.querySelector('[onclick*="addModal"]').addEventListener('click', function () {
            document.getElementById('addModal').style.display = 'block';
        });
        // Open add modal for allowance types
        document.querySelector('[onclick*="addTypeModal"]').addEventListener('click', function () {
            document.getElementById('addTypeModal').style.display = 'block';
        });
        // Function to update allowance amount based on employee and allowance type
        function updateAllowanceAmount() {
            const empId = document.getElementById('add_emp_id').value;
            const allowanceTypeId = document.getElementById('add_allowance_type_id').value;
            const amountDisplay = document.getElementById('add_amount_display');
            if (!empId || !allowanceTypeId) {
                amountDisplay.value = '';
                return;
            }
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'allowances.php', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (this.status === 200) {
                    const response = JSON.parse(this.responseText);
                    if (response.success) {
                        amountDisplay.value = '₦' + response.amount.toLocaleString();
                    } else {
                        amountDisplay.value = 'Error: ' + response.message;
                    }
                } else {
                    amountDisplay.value = 'Error fetching amount';
                }
            };
            xhr.send(`get_amount=1&emp_id=${encodeURIComponent(empId)}&allowance_type_id=${encodeURIComponent(allowanceTypeId)}`);
        }
        // Toggle amount input for allocation
        function toggleAmountInput() {
            const checkbox = document.getElementById('use_auto_amount');
            const amountGroup = document.getElementById('amount_group');
            const amountInput = document.getElementById('alloc_amount');
            amountGroup.style.display = checkbox.checked ? 'none' : 'block';
            amountInput.required = !checkbox.checked;
        }
        // Toggle select all checkboxes
        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('select_all');
            const checkboxes = document.querySelectorAll('.emp-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
        }
    </script>
</body>
</html>