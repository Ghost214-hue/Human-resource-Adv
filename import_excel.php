<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['user_id']) || ($_SESSION['user_role'] ?? '') !== 'hr_manager') {
    header("Location: login.php");
    exit();
}

require_once 'config.php';

require_once 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Shared\Date;

$conn = getConnection();

// Helper functions
function getDepartmentId($dept_name) {
    $dept_mapping = [
        'Technical' => 3,
        'Commercial' => 2, 
        'Administration' => 1,
        'Corporate' => 4,
        'FBIL' => 5
    ];
    return $dept_mapping[$dept_name] ?? 1;
}

function getSectionId($section_name, $department_id) {
    $section_mapping = [
        // Technical Department (ID: 3)
        'NRW' => 10,
        'O & M (Water Distribution)' => 8,
        'Production' => 6,
        'Water Treatment' => 7,
        'Sewerage' => 9,
        'construction' => 11,
        'O & M (Water works)' => 8,
        'O& M Distribution' => 8,
        'O & M Distribution' => 8,
        
        // Commercial Department (ID: 2)
        'Revenue' => 4,
        'Accounts' => 5,
        'ICT' => 12,
        'Stores' => 13,
        
        // Administration Department (ID: 1)
        'Admin' => 1,
        'HR' => 2,
        'Audit' => 3,
        'Transport' => 14,
        'M & E' => 15,
        'M& E' => 15,
        'Stores' => 13,
        
        // Corporate Department (ID: 4)
        'Customer Services' => 16,
        'Marketing' => 17,
        
        // FBIL Department (ID: 5)
        'Production' => 18,
        'Marketing' => 17
    ];
    
    return $section_mapping[$section_name] ?? null;
}

function getEmployeeType($designation) {
    $type_mapping = [
        'Managing Director' => 'managing_director',
        'Technical Services Manager' => 'dept_head',
        'Commercial Manager' => 'dept_head',
        'Human Resource Manager' => 'hr_manager',
        'Internal Audit Manager' => 'manager',
        'Monitoring & Evaluation Manager' => 'manager',
        'Corporate Affairs Manager' => 'manager',
        'Asst. Commercial Manager' => 'manager',
        'Asst. Technical Manager' => 'manager',
        'Asst. Human Resource Manager' => 'hr_manager',
        'Region Officer' => 'section_head',
        'Water Production Officer' => 'section_head',
        'Waste Water Officer' => 'section_head',
        'Transport Officer' => 'section_head',
        'Water Inspector' => 'section_head',
        'Debt Controller' => 'section_head',
        'Asst. Customer Relations Officer' => 'section_head',
        'Human Resource Officer' => 'section_head',
        'Pro Poor Officer' => 'section_head',
        'Procurement Officer' => 'section_head',
        'Accountant' => 'section_head',
        'Water Quality Officer' => 'section_head',
        'NRW Officer' => 'section_head',
        'Enforcement Officer' => 'section_head',
        'Revenue Officer' => 'section_head',
        'Environment Officer' => 'section_head',
        'Internal Auditor' => 'section_head',
        'Asst. Sales & Marketing Officer' => 'section_head',
        'Asst. ICT' => 'section_head',
        'Asst. Pro poor Officer' => 'section_head',
        'Asst. Monitoring & Evaluation Officer' => 'section_head',
        'Asst. Accountant' => 'section_head',
        'Asst. Procurement Officer' => 'section_head',
        'Assistant Auditor' => 'section_head',
        'Quality Assurance Officer' => 'section_head',
        'GIS Officer' => 'section_head',
        'ICT Officer' => 'section_head',
        'Snr. ICT Officer' => 'section_head',
        'Snr Water Production Officer' => 'section_head',
        'Development Officer' => 'section_head'
    ];
    
    return $type_mapping[$designation] ?? 'officer';
}

function getJobGroup($designation) {
    if (strpos($designation, 'Manager') !== false || 
        strpos($designation, 'Director') !== false) {
        return '1';
    } elseif (strpos($designation, 'Snr.') !== false || 
              strpos($designation, 'Senior') !== false ||
              strpos($designation, 'Asst. Manager') !== false) {
        return '2';
    } elseif (strpos($designation, 'Officer') !== false && 
              strpos($designation, 'Asst.') === false) {
        return '3';
    } elseif (strpos($designation, 'Asst.') !== false) {
        return '4';
    } else {
        return '5';
    }
}

function parseDate($date_str) {
    if (empty($date_str)) {
        return '1970-01-01'; // Fallback date for empty values
    }
    
    // Handle Excel serialized dates
    if (is_numeric($date_str)) {
        try {
            return Date::excelToDateTimeObject($date_str)->format('Y-m-d');
        } catch (Exception $e) {
            // If not an Excel date, continue with other formats
        }
    }
    
    // Handle year-only format (e.g., "1989")
    if (is_numeric($date_str) && strlen($date_str) == 4) {
        return $date_str . '-01-01';
    }
    
    // Handle DD.MM.YYYY format (e.g., "9.10.1990")
    if (strpos($date_str, '.') !== false) {
        $parts = explode('.', $date_str);
        if (count($parts) == 3) {
            return $parts[2] . '-' . str_pad($parts[1], 2, '0', STR_PAD_LEFT) . '-' . str_pad($parts[0], 2, '0', STR_PAD_LEFT);
        }
    }
    
    // Handle other formats with strtotime
    $timestamp = strtotime($date_str);
    if ($timestamp !== false) {
        return date('Y-m-d', $timestamp);
    }
    
    return '1970-01-01'; // Fallback date for invalid formats
}

function cleanPhone($phone) {
    if (empty($phone)) return '';
    return preg_replace('/[^0-9]/', '', $phone);
}

function extractNames($full_name) {
    $parts = array_filter(explode(' ', trim($full_name)));
    
    if (count($parts) == 1) {
        return [
            'first_name' => $parts[0],
            'last_name' => $parts[0],
            'surname' => $parts[0]
        ];
    }
    
    $first_name = $parts[0] ?? '';
    $last_name = end($parts) ?? '';
    
    $surname_parts = array_slice($parts, 1, -1);
    $surname = implode(' ', $surname_parts);
    
    if (empty($surname)) {
        $surname = $first_name;
    }
    
    return [
        'first_name' => $first_name,
        'last_name' => $last_name,
        'surname' => $surname
    ];
}

function getUserRole($employee_type) {
    switch($employee_type) {
        case 'managing_director':
        case 'bod_chairman':
            return 'super_admin';
        case 'dept_head':
            return 'dept_head';
        case 'hr_manager':
            return 'hr_manager';
        case 'manager':
            return 'manager';
        case 'section_head':
            return 'section_head';
        default:
            return 'employee';
    }
}

// Process Excel upload
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['excel_file'])) {
    $excel_file = $_FILES['excel_file']['tmp_name'];
    $file_type = strtolower(pathinfo($_FILES['excel_file']['name'], PATHINFO_EXTENSION));
    
    // Check file type
    $allowed_types = ['xlsx', 'xls', 'csv'];
    if (!in_array($file_type, $allowed_types)) {
        $_SESSION['flash_message'] = "Error: Please upload a valid Excel file (XLSX, XLS) or CSV.";
        $_SESSION['flash_type'] = 'danger';
        header("Location: import_excel.php");
        exit();
    }
    
    try {
        // Load the Excel file
        $spreadsheet = IOFactory::load($excel_file);
        $worksheet = $spreadsheet->getActiveSheet();
        
        // Get the highest row and column
        $highestRow = $worksheet->getHighestRow();
        $highestColumn = $worksheet->getHighestColumn();
        
        $success_count = 0;
        $error_count = 0;
        $errors = [];
        
        // Start transaction
        $conn->begin_transaction();
        
        // Process each row starting from row 2 (assuming row 1 is headers)
        for ($row = 2; $row <= $highestRow; $row++) {
            $rowData = $worksheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);
            $data = $rowData[0];
            
            // Skip empty rows
            if (empty(trim($data[0] ?? ''))) {
                continue;
            }
            
            $row_data = [
                'employee_id' => trim($data[0] ?? ''),
                'name' => trim($data[1] ?? ''),
                'gender' => trim($data[2] ?? ''),
                'national_id' => trim($data[3] ?? ''),
                'email' => trim($data[4] ?? ''),
                'designation' => trim($data[5] ?? ''),
                'phone' => trim($data[6] ?? ''),
                'date_of_birth' => trim($data[7] ?? ''),
                'employment_type' => trim($data[8] ?? ''),
                'department' => trim($data[9] ?? ''),
                'section' => trim($data[10] ?? ''),
                'job_group' => isset($data[11]) ? trim($data[11]) : ''
            ];
            
            // Skip if essential data is missing
            if (empty($row_data['employee_id']) || empty($row_data['name']) || empty($row_data['email'])) {
                $error_count++;
                $errors[] = "Skipped row $row: Missing essential data (ID, Name, or Email)";
                continue;
            }
            
            // Parse date of birth
            $date_of_birth = parseDate($row_data['date_of_birth']);
            
            // Check if employee already exists
            $check_stmt = $conn->prepare("SELECT id FROM employees WHERE employee_id = ? OR email = ?");
            $check_stmt->bind_param("ss", $row_data['employee_id'], $row_data['email']);
            $check_stmt->execute();
            $check_result = $check_stmt->get_result();
            
            if ($check_result->num_rows > 0) {
                $error_count++;
                $errors[] = "Skipped employee {$row_data['employee_id']}: Already exists in system";
                continue;
            }
            
            // Extract names
            $names = extractNames($row_data['name']);
            
            // Get department and section IDs
            $department_id = getDepartmentId($row_data['department']);
            $section_id = getSectionId($row_data['section'], $department_id);
            
            // Determine employee type and job group
            $employee_type = getEmployeeType($row_data['designation']);
            $job_group = !empty($row_data['job_group']) ? $row_data['job_group'] : getJobGroup($row_data['designation']);
            
            // Set hire date
            $hire_date = date('Y-m-d');
            
            // Clean phone
            $phone = cleanPhone($row_data['phone']);
            
            // Determine employment type
            $employment_type = (strtoupper($row_data['employment_type']) == 'CONTRACT') ? 'contract' : 'permanent';
            
            // Determine gender
            $gender = ($row_data['gender'] == 'M' ? 'male' : 'female');
            
            // Default next of kin
            $next_of_kin = json_encode([]);
            
            // Insert into employees table
            $emp_stmt = $conn->prepare("INSERT INTO employees (employee_id, first_name, last_name, surname, gender, national_id, email, designation, phone, date_of_birth, employment_type, department_id, section_id, employee_type, hire_date, scale_id, next_of_kin, employee_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')");
            
            $emp_stmt->bind_param(
                "sssssssssssiissss",
                $row_data['employee_id'],
                $names['first_name'],
                $names['last_name'],
                $names['surname'],
                $gender,
                $row_data['national_id'],
                $row_data['email'],
                $row_data['designation'],
                $phone,
                $date_of_birth,
                $employment_type,
                $department_id,
                $section_id,
                $employee_type,
                $hire_date,
                $job_group,
                $next_of_kin
            );
            
            if ($emp_stmt->execute()) {
                $new_employee_id = $conn->insert_id;
                
                // Insert into payroll table
                $payroll_stmt = $conn->prepare("INSERT INTO payroll (emp_id, employment_type, status, job_group) VALUES (?, ?, 'active', ?)");
                $payroll_stmt->bind_param("iss", $new_employee_id, $employment_type, $job_group);
                
                if (!$payroll_stmt->execute()) {
                    throw new Exception("Failed to create payroll entry for employee {$row_data['employee_id']}: " . $payroll_stmt->error);
                }
                
                // Insert into users table
                $user_role = getUserRole($employee_type);
                $hashed_password = password_hash($row_data['employee_id'], PASSWORD_DEFAULT);
                
                $user_stmt = $conn->prepare("INSERT INTO users (email, first_name, last_name, gender, password, role, designation, phone, employee_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
                $user_stmt->bind_param(
                    "sssssssss",
                    $row_data['email'],
                    $names['first_name'],
                    $names['last_name'],
                    $gender,
                    $hashed_password,
                    $user_role,
                    $row_data['designation'],
                    $phone,
                    $row_data['employee_id']
                );
                
                if (!$user_stmt->execute()) {
                    // If user creation fails due to duplicate, update instead
                    if ($conn->errno == 1062) {
                        $update_user_stmt = $conn->prepare("UPDATE users SET first_name = ?, last_name = ?, gender = ?, role = ?, designation = ?, phone = ?, employee_id = ?, updated_at = NOW() WHERE email = ?");
                        $update_user_stmt->bind_param(
                            "ssssssss",
                            $names['first_name'],
                            $names['last_name'],
                            $gender,
                            $user_role,
                            $row_data['designation'],
                            $phone,
                            $row_data['employee_id'],
                            $row_data['email']
                        );
                        $update_user_stmt->execute();
                    } else {
                        throw new Exception("Failed to create user account for employee {$row_data['employee_id']}: " . $user_stmt->error);
                    }
                }
                
                $success_count++;
            } else {
                $error_count++;
                $errors[] = "Failed to insert employee {$row_data['employee_id']}: " . $emp_stmt->error;
            }
        }
        
        // Commit transaction
        $conn->commit();
        
        // Set results message
        $message = "Imported $success_count employees successfully.";
        if ($error_count > 0) {
            $message .= " $error_count records had errors.";
        }
        
        $_SESSION['flash_message'] = $message;
        $_SESSION['flash_type'] = $error_count > 0 ? 'warning' : 'success';
        
        if (!empty($errors)) {
            $_SESSION['import_errors'] = $errors;
        }
        
        header("Location: employees.php");
        exit();
        
    } catch (Exception $e) {
        // Rollback transaction on error
        if (isset($conn) && $conn) {
            $conn->rollback();
        }
        
        $_SESSION['flash_message'] = "Error importing file: " . $e->getMessage();
        $_SESSION['flash_type'] = 'danger';
        header("Location: import_excel.php");
        exit();
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Import Employees from Excel</title>
    <style>
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 2px dashed #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .btn-secondary {
            background: #6c757d;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
        .info-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin-top: 20px;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .alert-warning {
            color: #856404;
            background-color: #fff3cd;
            border-color: #ffeaa7;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Import Employees from Excel</h2>
        
        <?php if (isset($_SESSION['flash_message'])): ?>
            <div class="alert alert-<?php echo $_SESSION['flash_type']; ?>">
                <?php echo $_SESSION['flash_message']; ?>
                <?php if (isset($_SESSION['import_errors'])): ?>
                    <h4>Import Errors:</h4>
                    <ul>
                        <?php foreach ($_SESSION['import_errors'] as $error): ?>
                            <li><?php echo htmlspecialchars($error); ?></li>
                        <?php endforeach; ?>
                        <?php unset($_SESSION['import_errors']); ?>
                    </ul>
                <?php endif; ?>
                <?php 
                unset($_SESSION['flash_message']);
                unset($_SESSION['flash_type']);
                ?>
            </div>
        <?php endif; ?>
        
        <form method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="excel_file">Excel File:</label>
                <input type="file" name="excel_file" accept=".xlsx,.xls,.csv" required>
                <small>Select Excel file (XLSX, XLS) or CSV containing employee data</small>
            </div>
            <button type="submit" class="btn btn-primary">Import Employees</button>
            <a href="employees.php" class="btn btn-secondary">Back to Employees</a>
        </form>
        
        <div class="info-box">
            <h3>Excel Format Expected:</h3>
            <p><strong>Required columns in this exact order (Sheet1):</strong></p>
            <ul>
                <li><strong>A:</strong> EMPLOYEE NO. (Employee ID)</li>
                <li><strong>B:</strong> NAME (Full Name)</li>
                <li><strong>C:</strong> GENDER (M/F)</li>
                <li><strong>D:</strong> National ID</li>
                <li><strong>E:</strong> Email Address</li>
                <li><strong>F:</strong> DESIGNATION</li>
                <li><strong>G:</strong> Phone Number</li>
                <li><strong>H:</strong> D.OB (Date of Birth)</li>
                <li><strong>I:</strong> EMPLOYMENT TYPE (P&P/CONTRACT)</li>
                <li><strong>J:</strong> DEPARTMENT</li>
                <li><strong>K:</strong> SECTION</li>
                <li><strong>L:</strong> JOB GROUP (Optional)</li>
            </ul>
            
            <h4>What will be created for each employee:</h4>
            <ul>
                <li>✅ Employee record in employees table</li>
                <li>✅ User account in users table (default password: employee ID)</li>
                <li>✅ Payroll entry in payroll table</li>
                <li>✅ Automatic department/section mapping</li>
                <li>✅ Automatic employee type determination</li>
                <li>✅ Automatic job group assignment</li>
            </ul>
            
            <p><strong>Note:</strong></p>
            <ul>
                <li>File must be in Excel format (XLSX, XLS) or CSV</li>
                <li>First row should contain headers</li>
                <li>Data should start from row 2</li>
                <li>Duplicate employees (by Employee ID or Email) will be skipped</li>
                <li>Date formats are automatically handled; invalid or missing dates will default to 1970-01-01</li>
            </ul>
        </div>
    </div>
</body>
</html>