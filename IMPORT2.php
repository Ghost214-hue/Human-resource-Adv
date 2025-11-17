<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
set_time_limit(300); // 5 minutes for large files

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

require_once 'config.php';

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


$import_log = [];
$success_count = 0;
$error_count = 0;

// Handle file upload
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['csv_file'])) {
    $file = $_FILES['csv_file'];
    
    // Validate file
    if ($file['error'] !== UPLOAD_ERR_OK) {
        die('Error uploading file: ' . $file['error']);
    }
    
    $file_extension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    
    if ($file_extension !== 'csv') {
        die('Invalid file type. Please upload a CSV file (.csv)');
    }
    
    try {
        // Open CSV file
        $handle = fopen($file['tmp_name'], 'r');
        
        if ($handle === false) {
            die('Error opening CSV file');
        }
        
        // Get header row
        $headers = fgetcsv($handle);
        
        if ($headers === false) {
            die('CSV file is empty or invalid');
        }
        
        // Clean headers - remove BOM, trim, normalize spaces
        $headers = array_map(function($header) {
            // Remove BOM if present
            $header = preg_replace('/[\x00-\x1F\x80-\xFF]/', '', $header);
            // Trim whitespace
            $header = trim($header);
            // Normalize multiple spaces to single space
            $header = preg_replace('/\s+/', ' ', $header);
            return $header;
        }, $headers);
        
        // Helper function for flexible column matching
        function findColumn($headers, $variations) {
            foreach ($variations as $variation) {
                $index = array_search($variation, $headers);
                if ($index !== false) {
                    return $index;
                }
            }
            return false;
        }
        
        // Map column names to indices with multiple variations
        $column_map = [
            'employee_no' => findColumn($headers, ['EMPLOYEE NO.', 'EMPLOYEE NO', 'Employee No.', 'Employee No']),
            'first_name' => findColumn($headers, ['FIRST NAME', 'First Name', 'FirstName']),
            'last_name' => findColumn($headers, ['LAST NAME', 'Last Name', 'LastName']),
            'surname' => findColumn($headers, ['SURNAME', 'Surname', 'Sur Name']),
            'national_id' => findColumn($headers, ['National ID', 'NATIONAL ID', 'NationalID', 'ID Number']),
            'email' => findColumn($headers, ['Email Address', 'EMAIL ADDRESS', 'Email', 'EMAIL']),
            'designation' => findColumn($headers, ['DESIGNATION', 'Designation', 'Position']),
            'phone' => findColumn($headers, ['Phone Number', 'PHONE NUMBER', 'Phone', 'PHONE']),
            'date_of_birth' => findColumn($headers, ['Date of birth', 'DATE OF BIRTH', 'DOB', 'Birth Date']),
            'hire_date' => findColumn($headers, ['Hire date', 'HIRE DATE', 'Hire Date', 'Date Hired']),
            'address' => findColumn($headers, ['Address', 'ADDRESS']),
            'employment_type' => findColumn($headers, ['EMPLOYMENT TYPE', 'Employment Type', 'EmploymentType']),
            'employee_type' => findColumn($headers, ['EMPLOYEE TYPE', 'Employee Type', 'EmployeeType']),
            'department_id' => findColumn($headers, ['DEPARTMENT ID', 'Department ID', 'DepartmentID', 'Dept ID']),
            'section_id' => findColumn($headers, ['SECTION ID', 'Section ID', 'SectionID']),
            'employee_status' => findColumn($headers, ['EMPLOYEE STATUS', 'Employee Status', 'EmployeeStatus', 'Status']),
            'job_group' => findColumn($headers, ['JOB GROUP', 'Job Group', 'JobGroup', 'Grade']),
             'gender' => findColumn($headers, ['GENDER'])
        ];
        
        // Validate that all required columns exist
        $missing_columns = [];
        foreach ($column_map as $field => $index) {
            if ($index === false) {
                $missing_columns[] = str_replace('_', ' ', ucwords($field, '_'));
            }
        }
        
        if (!empty($missing_columns)) {
            fclose($handle);
            echo '<div class="alert alert-danger">';
            echo '<h4>❌ Missing required columns:</h4>';
            echo '<p>The following columns could not be found in your CSV file:</p>';
            echo '<ul>';
            foreach ($missing_columns as $col) {
                echo '<li><strong>' . htmlspecialchars($col) . '</strong></li>';
            }
            echo '</ul>';
            echo '<h4>Headers found in your CSV file:</h4>';
            echo '<ul>';
            foreach ($headers as $i => $header) {
                echo '<li>Column ' . ($i + 1) . ': <strong>' . htmlspecialchars($header) . '</strong></li>';
            }
            echo '</ul>';
            echo '<p><a href="import_employees.php" class="btn btn-secondary">Try Again</a></p>';
            echo '</div>';
            die();
        }
        
        $row_number = 1;
        
        // Process each row
        while (($row = fgetcsv($handle)) !== false) {
            $row_number++;
            
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
                $gender = trim($row[$column_map['gender']] ?? '');
                
                // Handle date fields (expecting format: YYYY-MM-DD or DD/MM/YYYY or MM/DD/YYYY)
                $date_of_birth = '';
                if (!empty($row[$column_map['date_of_birth']])) {
                    $dob = trim($row[$column_map['date_of_birth']]);
                    $date_of_birth = date('Y-m-d', strtotime($dob));
                }
                
                $hire_date = '';
                if (!empty($row[$column_map['hire_date']])) {
                    $hdate = trim($row[$column_map['hire_date']]);
                    $hire_date = date('Y-m-d', strtotime($hdate));
                }
                
                // Validate required fields
                if (empty($employee_id) || empty($first_name) || empty($last_name) || empty($email)) {
                    $import_log[] = "Row $row_number: Skipped - Missing required fields (Employee ID, First Name, Last Name, or Email)";
                    $error_count++;
                    continue;
                }
                
                // Validate email format
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    $import_log[] = "Row $row_number: Skipped - Invalid email format: $email";
                    $error_count++;
                    continue;
                }
                
                // Normalize department and section IDs
                $department_id = !empty($department_id) && is_numeric($department_id) ? (int)$department_id : null;
                $section_id = !empty($section_id) && is_numeric($section_id) ? (int)$section_id : null;
                
                // Set gender as empty (add GENDER column to CSV if needed)
                $gender = '';
                
                // Start transaction
                $conn->begin_transaction();
                
                // Check if employee already exists
                $check_stmt = $conn->prepare("SELECT id FROM employees WHERE employee_id = ? OR email = ?");
                $check_stmt->bind_param("ss", $employee_id, $email);
                $check_stmt->execute();
                $existing = $check_stmt->get_result();
                
                if ($existing->num_rows > 0) {
                    $import_log[] = "Row $row_number: Skipped - Employee ID '$employee_id' or Email '$email' already exists";
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
                
                $import_log[] = "Row $row_number: ✓ Successfully imported - $first_name $last_name (ID: $employee_id)";
                $success_count++;
                
            } catch (Exception $e) {
                $conn->rollback();
                $import_log[] = "Row $row_number: ✗ Error - " . $e->getMessage();
                $error_count++;
            }
        }
        
        fclose($handle);
        
    } catch (Exception $e) {
        die('Error processing CSV file: ' . $e->getMessage());
    }
}

include 'header.php';
include 'nav_bar.php';
?>

<div class="container">
    <div class="main-content">
        <h2>Import Employees from CSV</h2>
        
        <?php if (!empty($import_log)): ?>
            <div class="import-results">
                <h3>Import Summary</h3>
                <div style="display: flex; gap: 20px; margin-bottom: 20px;">
                    <div style="flex: 1; padding: 15px; background: #d4edda; border: 1px solid #c3e6cb; border-radius: 5px;">
                        <strong style="color: #155724; font-size: 24px;"><?php echo $success_count; ?></strong>
                        <p style="margin: 5px 0 0 0; color: #155724;">Successfully Imported</p>
                    </div>
                    <div style="flex: 1; padding: 15px; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 5px;">
                        <strong style="color: #721c24; font-size: 24px;"><?php echo $error_count; ?></strong>
                        <p style="margin: 5px 0 0 0; color: #721c24;">Failed/Skipped</p>
                    </div>
                </div>
                
                <div class="import-log">
                    <h4>Detailed Log:</h4>
                    <div style="max-height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; background: #f9f9f9; font-family: monospace; font-size: 13px;">
                        <?php foreach ($import_log as $log): ?>
                            <div style="padding: 5px; border-bottom: 1px solid #eee;">
                                <?php echo htmlspecialchars($log); ?>
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
                    <h4>📋 Instructions:</h4>
                    <ol>
                        <li><strong>Convert your Excel file to CSV:</strong>
                            <ul>
                                <li>Open your Excel file</li>
                                <li>Click File → Save As</li>
                                <li>Choose "CSV (Comma delimited) (*.csv)" as the file type</li>
                                <li>Save the file</li>
                            </ul>
                        </li>
                        <li><strong>Your CSV file must contain these exact column headers:</strong>
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
                        <li><strong>Valid values:</strong>
                            <ul>
                                <li><strong>Employee Type:</strong> officer, section_head, manager, hr_manager, dept_head, managing_director, bod_chairman</li>
                                <li><strong>Employment Type:</strong> permanent, contract, temporary, intern</li>
                                <li><strong>Employee Status:</strong> active, inactive, resigned, fired, retired</li>
                            </ul>
                        </li>
                        <li>Default password for all imported users will be their <strong>Employee ID</strong></li>
                    </ol>
                </div>
                
                <form method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
                    <div class="form-group">
                        <label for="csv_file"><strong>Select CSV File</strong></label>
                        <input type="file" name="csv_file" id="csv_file" accept=".csv" required class="form-control">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">📤 Import Employees</button>
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

.alert-info ul, .alert-info ol {
    margin-left: 20px;
}

.alert-info li {
    margin-bottom: 5px;
}
</style>

<?php include 'footer.php'; ?>