<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
set_time_limit(300); // 5 minutes for large files

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

require_once 'config.php';

// Include PhpSpreadsheet library
// Make sure you have installed it via composer: composer require phpoffice/phpspreadsheet
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Shared\Date;

// Get database connection
$conn = getConnection();

// Permission check
function hasPermission($requiredRole) {
    $userRole = $_SESSION['user_role'] ?? 'guest';
    $roles = [
        'super_admin' => 5,
        'hr_manager' => 4,
        'managing_director' => 3,
        'dept_head' => 2,
        'section_head' => 1,
        'employee' => 0
    ];
    $userLevel = $roles[$userRole] ?? 0;
    $requiredLevel = $roles[$requiredRole] ?? 0;
    return $userLevel >= $requiredLevel;
}

if (!hasPermission('hr_manager')) {
    die('Access denied. You do not have permission to import employees.');
}

$import_log = [];
$success_count = 0;
$error_count = 0;

// Handle file upload
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['excel_file'])) {
    $file = $_FILES['excel_file'];
    
    // Validate file
    if ($file['error'] !== UPLOAD_ERR_OK) {
        die('Error uploading file: ' . $file['error']);
    }
    
    $allowed_extensions = ['xlsx', 'xls'];
    $file_extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    
    if (!in_array($file_extension, $allowed_extensions)) {
        die('Invalid file type. Please upload an Excel file (.xlsx or .xls)');
    }
    
    try {
        // Load the spreadsheet
        $spreadsheet = IOFactory::load($file['tmp_name']);
        $worksheet = $spreadsheet->getActiveSheet();
        $rows = $worksheet->toArray();
        
        // Get header row (first row)
        $headers = array_map('trim', $rows[0]);
        
        // Map column names to indices
        $column_map = [
            'employee_no' => array_search('EMPLOYEE NO.', $headers),
            'first_name' => array_search('FIRST NAME', $headers),
            'last_name' => array_search('LAST NAME', $headers),
            'surname' => array_search('SURNAME', $headers),
            'national_id' => array_search('National ID', $headers),
            'email' => array_search('Email Address', $headers),
            'designation' => array_search('DESIGNATION', $headers),
            'phone' => array_search('Phone Number', $headers),
            'date_of_birth' => array_search('Date of birth', $headers),
            'hire_date' => array_search('Hire date', $headers),
            'address' => array_search('Address', $headers),
            'employment_type' => array_search('EMPLOYMENT TYPE', $headers),
            'employee_type' => array_search('EMPLOYEE TYPE', $headers),
            'department_id' => array_search('DEPARTMENT ID', $headers),
            'section_id' => array_search('SECTION ID', $headers),
            'employee_status' => array_search('EMPLOYEE STATUS', $headers),
            'job_group' => array_search('JOB GROUP', $headers)
        ];
        
        // Validate that all required columns exist
        $missing_columns = [];
        foreach ($column_map as $field => $index) {
            if ($index === false) {
                $missing_columns[] = $field;
            }
        }
        
        if (!empty($missing_columns)) {
            die('Missing required columns: ' . implode(', ', $missing_columns));
        }
        
        // Process each row (skip header row)
        for ($i = 1; $i < count($rows); $i++) {
            $row = $rows[$i];
            
            // Skip empty rows
            if (empty(array_filter($row))) {
                continue;
            }
            
            try {
                // Extract data from row
                $employee_id = trim($row[$column_map['employee_no']] ?? '');
                $first_name = trim($row[$column_map['first_name']] ?? '');
                $last_name = trim($row[$column_map['last_name']] ?? '');
                $surname = trim($row[$column_map['surname']] ?? '');
                $national_id = trim($row[$column_map['national_id']] ?? '');
                $email = trim($row[$column_map['email']] ?? '');
                $designation = trim($row[$column_map['designation']] ?? 'Employee');
                $phone = trim($row[$column_map['phone']] ?? '');
                $address = trim($row[$column_map['address']] ?? '');
                $employment_type = strtolower(trim($row[$column_map['employment_type']] ?? 'permanent'));
                $employee_type = strtolower(trim($row[$column_map['employee_type']] ?? 'officer'));
                $department_id = trim($row[$column_map['department_id']] ?? '');
                $section_id = trim($row[$column_map['section_id']] ?? '');
                $employee_status = strtolower(trim($row[$column_map['employee_status']] ?? 'active'));
                $job_group = trim($row[$column_map['job_group']] ?? '');
                
                // Handle date fields (Excel dates are serial numbers)
                $date_of_birth = '';
                if (!empty($row[$column_map['date_of_birth']])) {
                    if (is_numeric($row[$column_map['date_of_birth']])) {
                        $date_of_birth = Date::excelToDateTimeObject($row[$column_map['date_of_birth']])->format('Y-m-d');
                    } else {
                        $date_of_birth = date('Y-m-d', strtotime($row[$column_map['date_of_birth']]));
                    }
                }
                
                $hire_date = '';
                if (!empty($row[$column_map['hire_date']])) {
                    if (is_numeric($row[$column_map['hire_date']])) {
                        $hire_date = Date::excelToDateTimeObject($row[$column_map['hire_date']])->format('Y-m-d');
                    } else {
                        $hire_date = date('Y-m-d', strtotime($row[$column_map['hire_date']]));
                    }
                }
                
                // Validate required fields
                if (empty($employee_id) || empty($first_name) || empty($last_name) || empty($email)) {
                    $import_log[] = "Row " . ($i + 1) . ": Skipped - Missing required fields (Employee ID, First Name, Last Name, or Email)";
                    $error_count++;
                    continue;
                }
                
                // Normalize department and section IDs
                $department_id = !empty($department_id) && is_numeric($department_id) ? (int)$department_id : null;
                $section_id = !empty($section_id) && is_numeric($section_id) ? (int)$section_id : null;
                
                // Determine gender from name or set default
                $gender = ''; // You may need to add a GENDER column to your Excel or set a default
                
                // Start transaction
                $conn->begin_transaction();
                
                // Check if employee already exists
                $check_stmt = $conn->prepare("SELECT id FROM employees WHERE employee_id = ? OR email = ?");
                $check_stmt->bind_param("ss", $employee_id, $email);
                $check_stmt->execute();
                $existing = $check_stmt->get_result();
                
                if ($existing->num_rows > 0) {
                    $import_log[] = "Row " . ($i + 1) . ": Skipped - Employee ID '$employee_id' or Email '$email' already exists";
                    $error_count++;
                    $conn->rollback();
                    continue;
                }
                
                // Insert into employees table
                $emp_stmt = $conn->prepare("INSERT INTO employees (
                    employee_id, first_name, last_name, surname, gender, national_id, 
                    phone, email, date_of_birth, designation, department_id, section_id, 
                    employee_type, employment_type, address, hire_date, scale_id, 
                    employee_status, created_at, updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
                
                $emp_stmt->bind_param(
                    "ssssssssssiissssss",
                    $employee_id, $first_name, $last_name, $surname, $gender, $national_id,
                    $phone, $email, $date_of_birth, $designation, $department_id, $section_id,
                    $employee_type, $employment_type, $address, $hire_date, $job_group,
                    $employee_status
                );
                
                if (!$emp_stmt->execute()) {
                    throw new Exception("Employee insert failed: " . $emp_stmt->error);
                }
                
                $new_employee_id = $conn->insert_id;
                
                // Insert into payroll table
                $payroll_status = ($employee_status === 'active') ? 'active' : 'inactive';
                $payroll_stmt = $conn->prepare("INSERT INTO payroll (emp_id, employment_type, status, job_group) VALUES (?, ?, ?, ?)");
                $payroll_stmt->bind_param("isss", $new_employee_id, $employment_type, $payroll_status, $job_group);
                
                if (!$payroll_stmt->execute()) {
                    throw new Exception("Payroll insert failed: " . $payroll_stmt->error);
                }
                
                // Determine user role based on employee type
                $user_role = 'employee';
                switch($employee_type) {
                    case 'managing_director':
                    case 'bod_chairman':
                        $user_role = 'super_admin';
                        break;
                    case 'dept_head':
                        $user_role = 'dept_head';
                        break;
                    case 'hr_manager':
                        $user_role = 'hr_manager';
                        break;
                    case 'manager':
                        $user_role = 'manager';
                        break;
                    case 'section_head':
                        $user_role = 'section_head';
                        break;
                    default:
                        $user_role = 'employee';
                        break;
                }
                
                // Hash password (using employee_id as default password)
                $hashed_password = password_hash($employee_id, PASSWORD_DEFAULT);
                
                // Insert into users table
                $user_stmt = $conn->prepare("INSERT INTO users (
                    email, first_name, last_name, gender, password, role, designation, 
                    phone, address, employee_id, created_at, updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
                
                $user_stmt->bind_param(
                    "ssssssssss",
                    $email, $first_name, $last_name, $gender, $hashed_password, $user_role,
                    $designation, $phone, $address, $employee_id
                );
                
                if (!$user_stmt->execute()) {
                    throw new Exception("User insert failed: " . $user_stmt->error);
                }
                
                // Commit transaction
                $conn->commit();
                
                $import_log[] = "Row " . ($i + 1) . ": Successfully imported - $first_name $last_name (ID: $employee_id)";
                $success_count++;
                
            } catch (Exception $e) {
                $conn->rollback();
                $import_log[] = "Row " . ($i + 1) . ": Error - " . $e->getMessage();
                $error_count++;
            }
        }
        
    } catch (Exception $e) {
        die('Error processing Excel file: ' . $e->getMessage());
    }
}

include 'header.php';
include 'nav_bar.php';
?>

<div class="container">
    <div class="main-content">
        <h2>Import Employees from Excel</h2>
        
        <?php if (!empty($import_log)): ?>
            <div class="import-results">
                <h3>Import Summary</h3>
                <p><strong>Success:</strong> <?php echo $success_count; ?> employees imported</p>
                <p><strong>Errors:</strong> <?php echo $error_count; ?> rows failed</p>
                
                <div class="import-log">
                    <h4>Detailed Log:</h4>
                    <div style="max-height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; background: #f9f9f9;">
                        <?php foreach ($import_log as $log): ?>
                            <div style="padding: 5px; border-bottom: 1px solid #eee;">
                                <?php 
                                    if (strpos($log, 'Successfully') !== false) {
                                        echo '<span style="color: green;">✓</span> ';
                                    } elseif (strpos($log, 'Error') !== false || strpos($log, 'Skipped') !== false) {
                                        echo '<span style="color: red;">✗</span> ';
                                    }
                                    echo htmlspecialchars($log); 
                                ?>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                
                <div style="margin-top: 20px;">
                    <a href="employees.php" class="btn btn-primary">View Employees</a>
                    <a href="import_employees.php" class="btn btn-secondary">Import Another File</a>
                </div>
            </div>
        <?php else: ?>
            <div class="upload-form">
                <div class="alert alert-info">
                    <h4>Instructions:</h4>
                    <ul>
                        <li>Your Excel file must contain the following columns (exact names):
                            <ul>
                                <li>EMPLOYEE NO.</li>
                                <li>FIRST NAME</li>
                                <li>LAST NAME</li>
                                <li>SURNAME</li>
                                <li>National ID</li>
                                <li>Email Address</li>
                                <li>DESIGNATION</li>
                                <li>Phone Number</li>
                                <li>Date of birth</li>
                                <li>Hire date</li>
                                <li>Address</li>
                                <li>EMPLOYMENT TYPE</li>
                                <li>EMPLOYEE TYPE</li>
                                <li>DEPARTMENT ID</li>
                                <li>SECTION ID</li>
                                <li>EMPLOYEE STATUS</li>
                                <li>JOB GROUP</li>
                            </ul>
                        </li>
                        <li>Default password for all imported users will be their Employee ID</li>
                        <li>Employee Type values: officer, section_head, manager, hr_manager, dept_head, managing_director, bod_chairman</li>
                        <li>Employment Type values: permanent, contract, temporary, intern</li>
                        <li>Employee Status values: active, inactive, resigned, fired, retired</li>
                    </ul>
                </div>
                
                <form method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
                    <div class="form-group">
                        <label for="excel_file">Select Excel File (.xlsx or .xls)</label>
                        <input type="file" name="excel_file" id="excel_file" accept=".xlsx,.xls" required class="form-control">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">Import Employees</button>
                        <a href="employees.php" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        <?php endif; ?>
    </div>
</div>

<style>
.import-results {
    background: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.import-log {
    margin-top: 20px;
}

.upload-form {
    background: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.alert-info {
    background-color: #d1ecf1;
    border: 1px solid #bee5eb;
    color: #0c5460;
    padding: 15px;
    border-radius: 5px;
    margin-bottom: 20px;
}

.alert-info ul {
    margin-left: 20px;
}
</style>

<?php include 'footer.php'; ?>