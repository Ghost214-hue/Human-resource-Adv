<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
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
require_once  'auth.php';

$user = [
    'first_name' => $_SESSION['user_name'] ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => $_SESSION['user_name'] ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];


function getDeductionStatusBadge($status) {
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

function getEmployeeIdFromUserId($conn, $user_id) {
    $user_id = $conn->real_escape_string($user_id);
    $query = "SELECT employee_id FROM users WHERE id = '$user_id'";
    $result = $conn->query($query);
    if ($result && $result->num_rows > 0) {
        $user = $result->fetch_assoc();
        $employee_id_from_user = $user['employee_id'];
        $employeeQuery = "SELECT id FROM employees WHERE employee_id = '$employee_id_from_user'";
        $employeeResult = $conn->query($employeeQuery);
        if ($employeeResult && $employeeResult->num_rows > 0) {
            return $employeeResult->fetch_assoc()['id'];
        }
    }
    $adminQuery = "SELECT e.id FROM employees e 
                  JOIN users u ON e.employee_id = u.employee_id 
                  WHERE u.role IN ('super_admin', 'hr_manager') 
                  LIMIT 1";
    $adminResult = $conn->query($adminQuery);
    if ($adminResult && $adminResult->num_rows > 0) {
        $admin = $adminResult->fetch_assoc();
        return $admin['id'];
    }
    return 1;
}

function getDeductionAmount($conn, $emp_id, $deduction_type_id) {
    $emp_id = $conn->real_escape_string($emp_id);
    $deduction_type_id = $conn->real_escape_string($deduction_type_id);
    
    $typeQuery = "SELECT calculation_method, calculation_details FROM deduction_types WHERE deduction_type_id = '$deduction_type_id'";
    $typeResult = $conn->query($typeQuery);
    
    if ($typeResult && $typeResult->num_rows > 0) {
        $typeData = $typeResult->fetch_assoc();
        $calculation_method = $typeData['calculation_method'];
        $calculation_details = !empty($typeData['calculation_details']) ? json_decode($typeData['calculation_details'], true) : null;
        
        if (!$calculation_details) {
            return ['success' => false, 'message' => 'Invalid or missing calculation details'];
        }
        
        if ($calculation_method === 'fixed') {
            return ['success' => true, 'amount' => $calculation_details['amount'], 'method' => 'fixed', 'details' => $typeData['calculation_details']];
        } elseif ($calculation_method === 'percentage') {
            $component = $calculation_details['component'];
            $percentage = $calculation_details['percentage'];
            $base_amount = 0;
            
            // Map deduction components to payroll table columns
            $componentMap = [
                'basic_salary' => 'salary',
                'gross_salary' => 'Gross_pay',
                'allowances_total' => 'total_allowances'
            ];
            
            if (in_array($component, ['basic_salary', 'gross_salary', 'allowances_total'])) {
                $column = $componentMap[$component];
                $amountQuery = "SELECT $column AS amount FROM payroll WHERE emp_id = '$emp_id' LIMIT 1";
                $amountResult = $conn->query($amountQuery);
                
                if ($amountResult && $amountResult->num_rows > 0) {
                    $amountData = $amountResult->fetch_assoc();
                    $base_amount = $amountData['amount'] ?? 0;
                    if ($base_amount === null || $base_amount <= 0) {
                        return ['success' => false, 'message' => "No valid $column found for employee ID $emp_id"];
                    }
                } else {
                    return ['success' => false, 'message' => "No payroll record found for employee ID $emp_id"];
                }
            } elseif (in_array($component, ['loan_principal', 'loan_balance'])) {
                $col = ($component === 'loan_principal') ? 'principal_amount' : 'remaining_balance';
                $loanQuery = "SELECT $col AS amount FROM employee_loans WHERE emp_id = '$emp_id' ORDER BY created_at DESC LIMIT 1";
                $loanResult = $conn->query($loanQuery);
                
                if ($loanResult && $loanResult->num_rows > 0) {
                    $loanData = $loanResult->fetch_assoc();
                    $base_amount = $loanData['amount'] ?? 0;
                    if ($base_amount === null || $base_amount <= 0) {
                        return ['success' => false, 'message' => "No valid $col found for employee ID $emp_id"];
                    }
                } else {
                    return ['success' => false, 'message' => "No loan record found for employee ID $emp_id"];
                }
            } else {
                return ['success' => false, 'message' => "Invalid component '$component' for percentage calculation"];
            }
            
            $deduction_amount = ($base_amount * $percentage) / 100;
            return ['success' => true, 'amount' => $deduction_amount, 'method' => 'percentage', 'details' => $typeData['calculation_details']];
        } elseif ($calculation_method === 'formula') {
            return ['success' => false, 'message' => 'Formula-based deductions require custom evaluation'];
        }
    }
    return ['success' => false, 'message' => 'Deduction type not found'];
}

$conn = getConnection();
$current_employee_id = getEmployeeIdFromUserId($conn, $user['id']);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['add_deduction_type']) && hasPermission('hr_manager')) {
        $type_name = $conn->real_escape_string($_POST['type_name']);
        $description = $conn->real_escape_string($_POST['description']);
        $calculation_type = $conn->real_escape_string($_POST['calculation_type']);
        $is_active = isset($_POST['is_active']) ? 1 : 0;
        $save_as_template = isset($_POST['save_as_template']) ? 1 : 0;
        
        $calculation_details = ['type' => $calculation_type];
        switch($calculation_type) {
            case 'fixed':
                $calculation_details['amount'] = (float)$_POST['fixed_amount'];
                break;
            case 'percentage':
                $calculation_details['percentage'] = (float)$_POST['percentage_value'];
                $calculation_details['component'] = $conn->real_escape_string($_POST['salary_component']);
                break;
            case 'formula':
                $calculation_details['formula'] = $conn->real_escape_string($_POST['formula']);
                break;
        }
        $calculation_json = $conn->real_escape_string(json_encode($calculation_details));
        
        $insertQuery = "INSERT INTO deduction_types (type_name, description, calculation_method, calculation_details, is_active, created_at, updated_at) 
                        VALUES ('$type_name', '$description', '$calculation_type', '$calculation_json', $is_active, NOW(), NOW())";
        
        if ($conn->query($insertQuery)) {
            $deduction_type_id = $conn->insert_id;
            
            if ($save_as_template) {
                $template_query = "INSERT INTO deduction_templates 
                                  (template_name, description, calculation_type, calculation_details, 
                                   created_by, created_at) 
                                  VALUES ('$type_name', '$description', '$calculation_type', 
                                          '$calculation_json', '$current_employee_id', NOW())";
                $conn->query($template_query);
            }
            
            $_SESSION['flash_message'] = "Deduction type added successfully";
            $_SESSION['flash_type'] = "success";
            header("Location: deductions.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error adding deduction type: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
    }
    
    if (isset($_POST['allocate_selected']) && hasPermission('hr_manager')) {
        error_log("POST Data: " . print_r($_POST, true)); // Debug POST data
        $period_id = $conn->real_escape_string($_POST['period_id']);
        $deduction_type_id = $conn->real_escape_string($_POST['deduction_type_id']);
        $effective_date = $conn->real_escape_string($_POST['effective_date']);
        $end_date = !empty($_POST['end_date']) ? "'" . $conn->real_escape_string($_POST['end_date']) . "'" : "NULL";
        $status = $conn->real_escape_string($_POST['status']);
        $created_by = $current_employee_id;
        $use_auto_amount = isset($_POST['use_auto_amount']);
        $fixed_amount = $use_auto_amount ? 0 : $conn->real_escape_string($_POST['amount']);
        $emp_ids = $_POST['emp_ids'] ?? [];
        
        // Validate inputs
        $period_check = $conn->query("SELECT id FROM payroll_periods WHERE id = '$period_id'");
        if (!$period_check || $period_check->num_rows == 0) {
            $_SESSION['flash_message'] = "Invalid payroll period selected";
            $_SESSION['flash_type'] = "danger";
            header("Location: deductions.php");
            exit();
        }
        
        $deduction_type_check = $conn->query("SELECT deduction_type_id FROM deduction_types WHERE deduction_type_id = '$deduction_type_id'");
        if (!$deduction_type_check || $deduction_type_check->num_rows == 0) {
            $_SESSION['flash_message'] = "Invalid deduction type selected";
            $_SESSION['flash_type'] = "danger";
            header("Location: deductions.php");
            exit();
        }
        
        $created_by_check = $conn->query("SELECT id FROM employees WHERE id = '$created_by'");
        if (!$created_by_check || $created_by_check->num_rows == 0) {
            $_SESSION['flash_message'] = "Invalid created_by employee ID";
            $_SESSION['flash_type'] = "danger";
            header("Location: deductions.php");
            exit();
        }
        
        $successCount = 0;
        $errorCount = 0;
        $errorMessages = [];
        
        foreach ($emp_ids as $emp_id_val) {
            $emp_id = $conn->real_escape_string($emp_id_val);
            
            // Validate employee
            $emp_check = $conn->query("SELECT id FROM employees WHERE id = '$emp_id'");
            if (!$emp_check || $emp_check->num_rows == 0) {
                $errorCount++;
                $errorMessages[] = "Employee ID $emp_id: Invalid employee";
                continue;
            }
            
            if ($use_auto_amount) {
                $amountData = getDeductionAmount($conn, $emp_id, $deduction_type_id);
                if (!$amountData['success']) {
                    $errorCount++;
                    $errorMessages[] = "Employee ID $emp_id: " . $amountData['message'];
                    continue;
                }
                $amount = $amountData['amount'];
                $deduction_method = $amountData['method'];
                $calculation_details_json = $amountData['details'];
            } else {
                $amount = $fixed_amount;
                $deduction_method = 'fixed';
                $calculation_details_json = json_encode(['type' => 'fixed', 'amount' => $fixed_amount]);
            }
            
            $checkQuery = "SELECT deduction_id FROM employee_deductions 
                          WHERE emp_id = '$emp_id' AND deduction_type_id = '$deduction_type_id' 
                          AND period_id = '$period_id' AND status = 'active'";
            $checkResult = $conn->query($checkQuery);
            
            if ($checkResult->num_rows == 0) {
                $insertQuery = "INSERT INTO employee_deductions 
                                (period_id, emp_id, deduction_type_id, amount, effective_date, end_date, status, created_by, created_at, updated_at, deduction_method, calculation_details) 
                                VALUES ('$period_id', '$emp_id', '$deduction_type_id', '$amount', '$effective_date', $end_date, '$status', '$created_by', NOW(), NOW(), '$deduction_method', '$calculation_details_json')";
                
                if ($conn->query($insertQuery)) {
                    $successCount++;
                } else {
                    $errorCount++;
                    $errorMessages[] = "Employee ID $emp_id: " . $conn->error;
                }
            }
        }
        
        $_SESSION['flash_message'] = "Allocation complete: $successCount deductions added, $errorCount errors. " . implode("; ", $errorMessages);
        $_SESSION['flash_type'] = $errorCount > 0 ? "warning" : "success";
        header("Location: deductions.php");
        exit();
    }
    
    if (isset($_POST['update_deduction_type']) && hasPermission('hr_manager')) {
        $deduction_type_id = $conn->real_escape_string($_POST['deduction_type_id']);
        $type_name = $conn->real_escape_string($_POST['type_name']);
        $description = $conn->real_escape_string($_POST['description']);
        $calculation_type = $conn->real_escape_string($_POST['calculation_type']);
        $is_active = isset($_POST['is_active']) ? 1 : 0;
        $save_as_template = isset($_POST['save_as_template']) ? 1 : 0;
        
        $calculation_details = ['type' => $calculation_type];
        switch($calculation_type) {
            case 'fixed':
                $calculation_details['amount'] = (float)$_POST['fixed_amount'];
                break;
            case 'percentage':
                $calculation_details['percentage'] = (float)$_POST['percentage_value'];
                $calculation_details['component'] = $conn->real_escape_string($_POST['salary_component']);
                break;
            case 'formula':
                $calculation_details['formula'] = $conn->real_escape_string($_POST['formula']);
                break;
        }
        $calculation_json = $conn->real_escape_string(json_encode($calculation_details));
        
        $updateQuery = "UPDATE deduction_types SET 
                        type_name = '$type_name',
                        description = '$description',
                        calculation_method = '$calculation_type',
                        calculation_details = '$calculation_json',
                        is_active = $is_active,
                        updated_at = NOW()
                        WHERE deduction_type_id = '$deduction_type_id'";
        
        if ($conn->query($updateQuery)) {
            if ($save_as_template) {
                $template_query = "INSERT INTO deduction_templates 
                                  (template_name, description, calculation_type, calculation_details, 
                                   created_by, created_at) 
                                  VALUES ('$type_name', '$description', '$calculation_type', 
                                          '$calculation_json', '$current_employee_id', NOW())";
                $conn->query($template_query);
            }
            
            $_SESSION['flash_message'] = "Deduction type updated successfully";
            $_SESSION['flash_type'] = "success";
            header("Location: deductions.php");
            exit();
        } else {
            $_SESSION['flash_message'] = "Error updating deduction type: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
    }
}

if (isset($_GET['action']) && $_GET['action'] == 'delete_deduction_type' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $deleteQuery = "DELETE FROM deduction_types WHERE deduction_type_id = '$id'";
    if ($conn->query($deleteQuery)) {
        $_SESSION['flash_message'] = "Deduction type deleted successfully";
        $_SESSION['flash_type'] = "success";
        header("Location: deductions.php");
        exit();
    } else {
        $_SESSION['flash_message'] = "Error deleting deduction type: " . $conn->error;
        $_SESSION['flash_type'] = "danger";
    }
}

$editDeductionType = null;
if (isset($_GET['action']) && $_GET['action'] == 'edit_deduction_type' && isset($_GET['id']) && hasPermission('hr_manager')) {
    $id = $conn->real_escape_string($_GET['id']);
    $editQuery = "SELECT * FROM deduction_types WHERE deduction_type_id = '$id'";
    $editResult = $conn->query($editQuery);
    if ($editResult && $editResult->num_rows > 0) {
        $editDeductionType = $editResult->fetch_assoc();
    } else {
        $_SESSION['flash_message'] = "Error fetching deduction type: " . ($editResult ? "No record found" : $conn->error);
        $_SESSION['flash_type'] = "danger";
        header("Location: deductions.php");
        exit();
    }
}

$rowsPerPage = isset($_GET['rows']) && in_array($_GET['rows'], [25, 50, 100, 250, 500]) ? (int)$_GET['rows'] : 25;
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$offset = ($page - 1) * $rowsPerPage;

$sortBy = isset($_GET['sort']) && in_array($_GET['sort'], ['deduction_type_id', 'type_name', 'is_active', 'created_at']) ? $_GET['sort'] : 'type_name';
$sortOrder = isset($_GET['order']) && strtoupper($_GET['order']) === 'DESC' ? 'DESC' : 'ASC';
$filter = isset($_GET['search']) ? $conn->real_escape_string($_GET['search']) : '';

$whereClause = '';
if ($filter) {
    $whereClause = "WHERE type_name LIKE '%$filter%' OR description LIKE '%$filter%'";
}

$countQuery = "SELECT COUNT(*) as count FROM deduction_types $whereClause";
$countResult = $conn->query($countQuery);
$totalRecords = $countResult->fetch_assoc()['count'];
$totalPages = ceil($totalRecords / $rowsPerPage);

$query = "SELECT * FROM deduction_types $whereClause 
          ORDER BY $sortBy $sortOrder 
          LIMIT $offset, $rowsPerPage";
$result = $conn->query($query);

$deductionTypes = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $deductionTypes[] = $row;
    }
}

$templates = [];
$template_query = "SELECT * FROM deduction_templates ORDER BY created_at DESC";
$template_result = $conn->query($template_query);
if ($template_result) {
    while ($row = $template_result->fetch_assoc()) {
        $templates[] = $row;
    }
}

$employees = [];
$employee_query = "SELECT id, employee_id, CONCAT(first_name, ' ', last_name) as name, scale_id FROM employees ORDER BY name";
$employee_result = $conn->query($employee_query);
if ($employee_result) {
    while ($row = $employee_result->fetch_assoc()) {
        $employees[] = $row;
    }
}

$periods = [];
$periodsQuery = "SELECT id, CONCAT(period_name) AS period_name FROM payroll_periods ORDER BY start_date DESC";
$periodsResult = $conn->query($periodsQuery);
if ($periodsResult && $periodsResult->num_rows > 0) {
    while ($period = $periodsResult->fetch_assoc()) {
        $periods[$period['id']] = $period['period_name'];
    }
}

$conn->close();

$pageTitle = "Deductions Management";
require_once 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deductions - HR Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <style>
        .bulk-assign-section, .deduction-types-section {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .bulk-assign-section h4, .deduction-types-section h4 {
            margin-top: 0;
            color: #ffffff;
        }

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

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

        .pagination-links a {
            margin: 0 5px;
        }

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
            max-width: 600px;
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

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .deduction-type-selector {
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
            text-align: center;
        }

        .type-card:hover {
            background: rgba(255, 255, 255, 0.12);
            border-color: #4e73df;
            transform: translateY(-3px);
        }

        .type-card.selected {
            background: rgba(78, 115, 223, 0.25);
            border-color: #4e73df;
        }

        .type-card i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #4e73df;
        }

        .type-card h5 {
            margin: 8px 0;
            color: #ffffff;
            font-size: 14px;
        }

        .type-card p {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin: 0;
        }

        .dynamic-form-section {
            display: none;
        }

        .dynamic-form-section.active {
            display: block;
        }

        .formula-builder {
            background: rgba(0, 0, 0, 0.3);
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }

        .variable-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 12px;
        }

        .variable-chip {
            background: rgba(78, 115, 223, 0.35);
            border: 1px solid #4e73df;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            color: #ffffff;
        }

        .variable-chip:hover {
            background: rgba(78, 115, 223, 0.6);
        }

        .formula-input {
            font-family: 'Courier New', monospace;
            background: rgba(0, 0, 0, 0.5);
            color: #00ff00;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 10px;
            border-radius: 6px;
            width: 100%;
            min-height: 80px;
            resize: vertical;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .template-section {
            background: rgba(255, 255, 255, 0.06);
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
        }

        .template-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 12px;
            margin-top: 15px;
        }

        .template-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .template-card:hover {
            background: rgba(78, 115, 223, 0.3);
            transform: translateY(-3px);
        }

        .template-card h6 {
            margin: 0 0 8px;
            font-size: 15px;
            color: #ffffff;
        }

        .template-card p {
            margin: 0;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
        }

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

            .deduction-type-selector {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
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
        <div class="sidebar">
            <div class="sidebar-brand">
                <h1>HR System</h1>
                <p>Management Portal</p>
            </div>
            <nav class="nav">
                <ul>
                    <li><a href="dashboard.php"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="employees.php"><i class="fas fa-users"></i> Employees</a></li>
                    <?php if (hasPermission('hr_manager')): ?>
                    <li><a href="departments.php"><i class="fas fa-building"></i> Departments</a></li>
                    <li><a href="admin.php"><i class="fas fa-cog"></i> Admin</a></li>
                    <li><a href="reports.php"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <?php endif; ?>
                    <li><a href="leave_management.php"><i class="fas fa-calendar-alt"></i> Leave Management</a></li>
                    <li><a href="payroll_management.php"><i class="fas fa-money-check"></i> Payroll</a></li>
                </ul>
            </nav>
        </div>
        <div class="main-content">
            <div class="content">
                <!-- Main Navigation Tabs -->
                <div class="tabs">
                    <a href="payroll_management.php">Payroll Management</a>
                    <a href="deductions.php" class="active">Deductions</a>
                    <a href="allowances.php">Allowances</a>
                    <a href="add_bank.php">Banks</a>
                    <a href="periods.php">Periods</a>
                </div>

                <!-- Deduction-Specific Tabs -->
                <div class="tabs mb-3">
                    <a href="deductions.php?tab=types" class="<?php echo (!isset($_GET['tab']) || $_GET['tab'] === 'types') ? 'active' : ''; ?>">
                        Deduction Types
                    </a>
                    <a href="deductions.php?tab=allocate" class="<?php echo (isset($_GET['tab']) && $_GET['tab'] === 'allocate') ? 'active' : ''; ?>">
                        Allocate Deduction
                    </a>
                </div>

                <?php $flash = getFlashMessage(); if ($flash): ?>
                    <div class="alert alert-<?php echo $flash['type']; ?>">
                        <i class="fas fa-info-circle"></i> <?php echo htmlspecialchars($flash['message']); ?>
                    </div>
                <?php endif; ?>

                <!-- DEDUCTION TYPES TAB (default) -->
                <?php if (!isset($_GET['tab']) || $_GET['tab'] === 'types'): ?>
                <div class="tab-content active">
                    <?php if (hasPermission('hr_manager')): ?>
                    <div class="deduction-types-section">
                        <div class="d-flex justify-between align-center mb-3">
                            <h3>Deduction Types</h3>
                            <button class="btn btn-primary" onclick="openAddModal()">
                                <i class="fas fa-plus"></i> Add Deduction Type
                            </button>
                        </div>
                        <?php if (!empty($templates)): ?>
                        <div class="template-section">
                            <h4><i class="fas fa-bookmark"></i> Quick Templates</h4>
                            <div class="template-list">
                                <?php foreach ($templates as $template): ?>
                                <div class="template-card" onclick='loadTemplate(<?php echo json_encode($template); ?>)'>
                                    <h6><?php echo htmlspecialchars($template['template_name'] ?? 'Unnamed'); ?></h6>
                                    <p><?php echo htmlspecialchars(substr($template['description'] ?? '', 0, 60)) . (strlen($template['description'] ?? '') > 60 ? '...' : ''); ?></p>
                                </div>
                                <?php endforeach; ?>
                            </div>
                        </div>
                        <?php endif; ?>
                        <div class="table-controls">
                            <form method="GET" action="deductions.php">
                                <input type="hidden" name="tab" value="types">
                                <label for="search">Search:</label>
                                <input type="text" id="search" name="search" value="<?php echo htmlspecialchars($filter); ?>" placeholder="Search by type name or description">
                                <input type="hidden" name="page" value="<?php echo $page; ?>">
                                <input type="hidden" name="rows" value="<?php echo $rowsPerPage; ?>">
                                <input type="hidden" name="sort" value="<?php echo $sortBy; ?>">
                                <input type="hidden" name="order" value="<?php echo $sortOrder; ?>">
                                <button type="submit" class="btn btn-sm btn-primary">Search</button>
                            </form>
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Type Name</th>
                                    <th>Description</th>
                                    <th>Calculation Method</th>
                                    <th>Active</th>
                                    <th>Created At</th>
                                    <th>Updated At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($deductionTypes)): ?>
                                    <tr>
                                        <td colspan="7" class="text-center">No deduction types found</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($deductionTypes as $type): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($type['type_name']); ?></td>
                                        <td><?php echo htmlspecialchars($type['description']); ?></td>
                                        <td><?php echo htmlspecialchars(ucfirst($type['calculation_method'])); ?></td>
                                        <td><?php echo $type['is_active'] ? 'Yes' : 'No'; ?></td>
                                        <td><?php echo formatDate($type['created_at']); ?></td>
                                        <td><?php echo formatDate($type['updated_at']); ?></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary edit-type-btn" 
                                                    data-id="<?php echo $type['deduction_type_id']; ?>"
                                                    data-type-name="<?php echo htmlspecialchars($type['type_name']); ?>"
                                                    data-description="<?php echo htmlspecialchars($type['description']); ?>"
                                                    data-calculation-type="<?php echo htmlspecialchars($type['calculation_method']); ?>"
                                                    data-calculation-details='<?php echo htmlspecialchars($type['calculation_details']); ?>'
                                                    data-is-active="<?php echo $type['is_active']; ?>">
                                                Edit
                                            </button>
                                            <button class="btn btn-sm btn-danger delete-type-btn" 
                                                    data-id="<?php echo $type['deduction_type_id']; ?>"
                                                    data-name="<?php echo htmlspecialchars($type['type_name']); ?>">
                                                Delete
                                            </button>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <p>Showing <?php echo min($totalRecords, $offset + 1); ?> to <?php echo min($totalRecords, $offset + $rowsPerPage); ?> of <?php echo $totalRecords; ?> entries</p>
                            <div class="pagination-links">
                                <?php if ($page > 1): ?>
                                    <a href="deductions.php?tab=types&page=<?php echo $page - 1; ?>&rows=<?php echo $rowsPerPage; ?>&sort=<?php echo $sortBy; ?>&order=<?php echo $sortOrder; ?>&search=<?php echo urlencode($filter); ?>" class="btn btn-sm btn-secondary">Previous</a>
                                <?php endif; ?>
                                <?php for ($i = 1; $i <= $totalPages; $i++): ?>
                                    <a href="deductions.php?tab=types&page=<?php echo $i; ?>&rows=<?php echo $rowsPerPage; ?>&sort=<?php echo $sortBy; ?>&order=<?php echo $sortOrder; ?>&search=<?php echo urlencode($filter); ?>" class="btn btn-sm <?php echo $i == $page ? 'btn-primary' : 'btn-secondary'; ?>"><?php echo $i; ?></a>
                                <?php endfor; ?>
                                <?php if ($page < $totalPages): ?>
                                    <a href="deductions.php?tab=types&page=<?php echo $page + 1; ?>&rows=<?php echo $rowsPerPage; ?>&sort=<?php echo $sortBy; ?>&order=<?php echo $sortOrder; ?>&search=<?php echo urlencode($filter); ?>" class="btn btn-sm btn-secondary">Next</a>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>

                <!-- ALLOCATE DEDUCTION TAB -->
                <?php if (isset($_GET['tab']) && $_GET['tab'] === 'allocate'): ?>
                <div class="tab-content active">
                    <?php if (hasPermission('hr_manager')): ?>
                    <div class="bulk-assign-section">
                        <h4>Allocate Deductions to Selected Employees</h4>
                        <form method="POST" action="deductions.php">
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
                                    <label class="form-label" for="alloc_deduction_type_id">Deduction Type</label>
                                    <select class="form-control" id="alloc_deduction_type_id" name="deduction_type_id" required>
                                        <option value="">Select Deduction Type</option>
                                        <?php foreach ($deductionTypes as $type): ?>
                                            <option value="<?php echo $type['deduction_type_id']; ?>"><?php echo htmlspecialchars($type['type_name']); ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><input type="checkbox" name="use_auto_amount" id="use_auto_amount" onclick="toggleAmountInput()"> Use calculation-based amount</label>
                                </div>
                                <div class="form-group" id="amount_group">
                                    <label class="form-label" for="alloc_amount">Fixed Amount</label>
                                    <input type="number" step="0.01" class="form-control" id="alloc_amount" name="amount" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="alloc_effective_date">Start Date</label>
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
                                            <td><?php echo htmlspecialchars($employee['name']); ?></td>
                                            <td><?php echo htmlspecialchars($employee['scale_id'] ?? 'N/A'); ?></td>
                                        </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <button type="submit" class="btn btn-primary">Allocate Deduction</button>
                        </form>
                    </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- === MODALS (unchanged, kept at bottom) === -->
    <div id="addTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Deduction Type</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="deductions.php" id="addDeductionTypeForm">
                    <div class="modal-body">
                        <input type="hidden" name="add_deduction_type" value="1">
                        <input type="hidden" name="calculation_type" id="add_calculation_type" value="fixed">
                        <div class="form-group">
                            <label class="form-label" for="add_type_name">Type Name</label>
                            <input type="text" class="form-control" id="add_type_name" name="type_name" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_description">Description</label>
                            <textarea class="form-control" id="add_description" name="description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Calculation Type</label>
                            <div class="deduction-type-selector">
                                <div class="type-card selected" data-type="fixed" onclick="selectDeductionType('fixed', 'add')">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <h5>Fixed Amount</h5>
                                    <p>Static value (e.g., $100)</p>
                                </div>
                                <div class="type-card" data-type="percentage" onclick="selectDeductionType('percentage', 'add')">
                                    <i class="fas fa-percentage"></i>
                                    <h5>Percentage</h5>
                                    <p>% of salary component</p>
                                </div>
                                <div class="type-card" data-type="formula" onclick="selectDeductionType('formula', 'add')">
                                    <i class="fas fa-calculator"></i>
                                    <h5>Formula</h5>
                                    <p>Custom expression</p>
                                </div>
                            </div>
                        </div>
                        <div class="dynamic-form-section active" id="add_fixedSection">
                            <div class="form-group">
                                <label class="form-label">Fixed Amount ($)</label>
                                <input type="number" step="0.01" name="fixed_amount" class="form-control" placeholder="100.00">
                            </div>
                        </div>
                        <div class="dynamic-form-section" id="add_percentageSection">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Percentage (%)</label>
                                    <input type="number" step="0.01" min="0" max="100" name="percentage_value" class="form-control" placeholder="5.00">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Applies to</label>
                                    <select name="salary_component" class="form-control">
                                        <option value="basic_salary">Basic Pay</option>
                                        <option value="gross_salary">Gross Salary</option>
                                        <option value="allowances_total">Total Allowances</option>
                                        <option value="loan_principal">Loan Principal</option>
                                        <option value="loan_balance">Loan Remaining Balance</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="dynamic-form-section" id="add_formulaSection">
                            <div class="formula-builder">
                                <div class="variable-chips">
                                    <div class="variable-chip" data-variable="basic_salary">basic_salary</div>
                                    <div class="variable-chip" data-variable="gross_salary">gross_salary</div>
                                    <div class="variable-chip" data-variable="attendance_days">attendance_days</div>
                                    <div class="variable-chip" data-variable="tax_rate">tax_rate</div>
                                    <div class="variable-chip" data-variable="allowances_total">allowances_total</div>
                                    <div class="variable-chip" data-variable="loan_principal">loan_principal</div>
                                    <div class="variable-chip" data-variable="loan_balance">loan_balance</div>
                                </div>
                                <textarea name="formula" id="add_formula" class="form-control formula-input" placeholder="(basic_salary * 0.1) - tax_rate" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_is_active">Active</label>
                            <input type="checkbox" id="add_is_active" name="is_active" checked>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="add_save_as_template">Save as Template</label>
                            <input type="checkbox" id="add_save_as_template" name="save_as_template" value="1">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Deduction Type</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="editTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Deduction Type</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <form method="POST" action="deductions.php" id="editDeductionTypeForm">
                    <div class="modal-body">
                        <input type="hidden" name="update_deduction_type" value="1">
                        <input type="hidden" name="deduction_type_id" id="edit_deduction_type_id">
                        <input type="hidden" name="calculation_type" id="edit_calculation_type">
                        <div class="form-group">
                            <label class="form-label" for="edit_type_name">Type Name</label>
                            <input type="text" class="form-control" id="edit_type_name" name="type_name" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_description">Description</label>
                            <textarea class="form-control" id="edit_description" name="description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Calculation Type</label>
                            <div class="deduction-type-selector">
                                <div class="type-card" data-type="fixed" onclick="selectDeductionType('fixed', 'edit')">
                                    <i class="fas fa-money-bill-wave"></i>
                                    <h5>Fixed Amount</h5>
                                    <p>Static value (e.g., $100)</p>
                                </div>
                                <div class="type-card" data-type="percentage" onclick="selectDeductionType('percentage', 'edit')">
                                    <i class="fas fa-percentage"></i>
                                    <h5>Percentage</h5>
                                    <p>% of salary component</p>
                                </div>
                                <div class="type-card" data-type="formula" onclick="selectDeductionType('formula', 'edit')">
                                    <i class="fas fa-calculator"></i>
                                    <h5>Formula</h5>
                                    <p>Custom expression</p>
                                </div>
                            </div>
                        </div>
                        <div class="dynamic-form-section" id="edit_fixedSection">
                            <div class="form-group">
                                <label class="form-label">Fixed Amount ($)</label>
                                <input type="number" step="0.01" name="fixed_amount" id="edit_fixed_amount" class="form-control" placeholder="100.00">
                            </div>
                        </div>
                        <div class="dynamic-form-section" id="edit_percentageSection">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Percentage (%)</label>
                                    <input type="number" step="0.01" min="0" max="100" name="percentage_value" id="edit_percentage_value" class="form-control" placeholder="5.00">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Applies to</label>
                                    <select name="salary_component" id="edit_salary_component" class="form-control">
                                        <option value="basic_salary">Basic Pay</option>
                                        <option value="gross_salary">Gross Salary</option>
                                        <option value="allowances_total">Total Allowances</option>
                                        <option value="loan_principal">Loan Principal</option>
                                        <option value="loan_balance">Loan Remaining Balance</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="dynamic-form-section" id="edit_formulaSection">
                            <div class="formula-builder">
                                <div class="variable-chips">
                                    <div class="variable-chip" data-variable="basic_salary">basic_salary</div>
                                    <div class="variable-chip" data-variable="gross_salary">gross_salary</div>
                                    <div class="variable-chip" data-variable="attendance_days">attendance_days</div>
                                    <div class="variable-chip" data-variable="tax_rate">tax_rate</div>
                                    <div class="variable-chip" data-variable="allowances_total">allowances_total</div>
                                    <div class="variable-chip" data-variable="loan_principal">loan_principal</div>
                                    <div class="variable-chip" data-variable="loan_balance">loan_balance</div>
                                </div>
                                <textarea name="formula" id="edit_formula" class="form-control formula-input" placeholder="(basic_salary * 0.1) - tax_rate" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_is_active">Active</label>
                            <input type="checkbox" id="edit_is_active" name="is_active">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="edit_save_as_template">Save as Template</label>
                            <input type="checkbox" id="edit_save_as_template" name="save_as_template" value="1">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Deduction Type</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="deleteTypeModal" class="modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the deduction type <span id="delete_type_name"></span>?</p>
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
        function selectDeductionType(type, prefix) {
            document.getElementById(prefix + '_calculation_type').value = type;
            document.querySelectorAll(`#${prefix}_fixedSection, #${prefix}_percentageSection, #${prefix}_formulaSection`).forEach(el => {
                el.classList.remove('active');
            });
            document.getElementById(prefix + '_' + type + 'Section').classList.add('active');
            document.querySelectorAll(`#${prefix}DeductionTypeForm .type-card`).forEach(card => {
                card.classList.toggle('selected', card.dataset.type === type);
            });
            if (type === 'formula') {
                initializeVariableChips(prefix);
            }
        }
        function insertVariable(varName, prefix) {
            const textarea = document.getElementById(prefix + '_formula');
            if (textarea) {
                const startPos = textarea.selectionStart;
                const endPos = textarea.selectionEnd;
                const currentValue = textarea.value;
                textarea.value = currentValue.substring(0, startPos) + varName + currentValue.substring(endPos);
                textarea.focus();
                textarea.selectionStart = textarea.selectionEnd = startPos + varName.length;
            }
        }
        function initializeVariableChips(prefix) {
            const chips = document.querySelectorAll(`#${prefix}_formulaSection .variable-chip`);
            chips.forEach(chip => {
                chip.removeEventListener('click', chip._clickHandler);
                chip._clickHandler = () => insertVariable(chip.dataset.variable, prefix);
                chip.addEventListener('click', chip._clickHandler);
            });
        }
        function openAddModal() {
            document.getElementById('addTypeModal').style.display = 'block';
            selectDeductionType('fixed', 'add');
            document.getElementById('addDeductionTypeForm').reset();
            document.querySelectorAll('#addDeductionTypeForm .type-card').forEach(card => {
                card.classList.toggle('selected', card.dataset.type === 'fixed');
            });
        }
        function loadTemplate(template) {
            document.getElementById('addTypeModal').style.display = 'block';
            document.getElementById('addDeductionTypeForm').reset();
            setTimeout(() => {
                document.getElementById('add_type_name').value = template.template_name || '';
                document.getElementById('add_description').value = template.description || '';
                document.getElementById('add_save_as_template').checked = true;
                const details = JSON.parse(template.calculation_details || '{}');
                selectDeductionType(details.type || 'fixed', 'add');
                if (details.type === 'fixed') {
                    document.getElementById('add_fixedSection').querySelector('input[name="fixed_amount"]').value = details.amount || '';
                } else if (details.type === 'percentage') {
                    document.getElementById('add_percentageSection').querySelector('input[name="percentage_value"]').value = details.percentage || '';
                    document.getElementById('add_percentageSection').querySelector('select[name="salary_component"]').value = details.component || 'basic_salary';
                } else if (details.type === 'formula') {
                    document.getElementById('add_formula').value = details.formula || '';
                }
            }, 100);
        }
        function openEditModal(button) {
            const typeId = button.dataset.id;
            const typeName = button.dataset.typeName;
            const description = button.dataset.description;
            const calculationType = button.dataset.calculationType;
            const calculationDetails = JSON.parse(button.dataset.calculationDetails || '{}');
            const isActive = button.dataset.isActive === '1';
            document.getElementById('edit_deduction_type_id').value = typeId;
            document.getElementById('edit_type_name').value = typeName;
            document.getElementById('edit_description').value = description;
            document.getElementById('edit_is_active').checked = isActive;
            document.getElementById('edit_calculation_type').value = calculationType;
            selectDeductionType(calculationType, 'edit');
            if (calculationType === 'fixed') {
                document.getElementById('edit_fixed_amount').value = calculationDetails.amount || '';
            } else if (calculationType === 'percentage') {
                document.getElementById('edit_percentage_value').value = calculationDetails.percentage || '';
                document.getElementById('edit_salary_component').value = calculationDetails.component || 'basic_salary';
            } else if (calculationType === 'formula') {
                document.getElementById('edit_formula').value = calculationDetails.formula || '';
            }
            document.getElementById('editTypeModal').style.display = 'block';
        }
        function toggleAmountInput() {
            const checkbox = document.getElementById('use_auto_amount');
            const amountGroup = document.getElementById('amount_group');
            amountGroup.style.display = checkbox.checked ? 'none' : 'block';
            document.getElementById('alloc_amount').required = !checkbox.checked;
        }
        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('select_all');
            const checkboxes = document.querySelectorAll('.emp-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
        }
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.edit-type-btn').forEach(button => {
                button.addEventListener('click', function() {
                    openEditModal(this);
                });
            });
            document.querySelectorAll('.delete-type-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const typeId = this.dataset.id;
                    const name = this.dataset.name;
                    document.getElementById('delete_type_name').textContent = name;
                    document.getElementById('delete_type_confirm_btn').href = `deductions.php?action=delete_deduction_type&id=${typeId}`;
                    document.getElementById('deleteTypeModal').style.display = 'block';
                });
            });
            document.querySelectorAll('.close, [data-dismiss="modal"]').forEach(button => {
                button.addEventListener('click', function() {
                    this.closest('.modal').style.display = 'none';
                });
            });
            window.addEventListener('click', function(event) {
                if (event.target.classList.contains('modal')) {
                    event.target.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>