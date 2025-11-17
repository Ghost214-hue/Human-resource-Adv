<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_start();

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Check if user is logged in
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
require_once 'header.php';
require_once 'config.php';
require_once 'auth.php';
require_once 'nav_bar.php';

// Load Composer's autoloader
require 'vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$conn = getConnection();

// Function to send appraisal notification email
function sendAppraisalNotification($appraisal_id, $conn) {
    require 'email_config.php';
    
    // Get employee email and details
    $emailStmt = $conn->prepare("
        SELECT e.email, e.first_name, e.last_name, ea.appraisal_cycle_id, ac.name as cycle_name,
               a.first_name as appraiser_first, a.last_name as appraiser_last
        FROM employee_appraisals ea
        JOIN employees e ON ea.employee_id = e.id
        JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id
        JOIN employees a ON ea.appraiser_id = a.id
        WHERE ea.id = ?
    ");
    $emailStmt->bind_param("i", $appraisal_id);
    $emailStmt->execute();
    $emailResult = $emailStmt->get_result();
    
    if ($emailData = $emailResult->fetch_assoc()) {
        $to_email = $emailData['email'];
        $employee_name = $emailData['first_name'] . ' ' . $emailData['last_name'];
        $cycle_name = $emailData['cycle_name'];
        $appraiser_name = $emailData['appraiser_first'] . ' ' . $emailData['appraiser_last'];
        
        try {
            // Create PHPMailer instance
            $mail = new PHPMailer(true);
            
            // Server settings
            $mail->isSMTP();
            $mail->Host = SMTP_HOST;
            $mail->SMTPAuth = true;
            $mail->Username = SMTP_USERNAME;
            $mail->Password = SMTP_PASSWORD;
            $mail->SMTPSecure = SMTP_ENCRYPTION;
            $mail->Port = SMTP_PORT;
            
            // Recipients
            $mail->setFrom(EMAIL_FROM, EMAIL_FROM_NAME);
            $mail->addAddress($to_email, $employee_name);
            
            // Content
            $mail->isHTML(true);
            $mail->Subject = 'Performance Appraisal Ready for Your Review - ' . $cycle_name;
            
            $appraisal_url = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . 
                             "://$_SERVER[HTTP_HOST]" . dirname($_SERVER['PHP_SELF']) . 
                             "/employee_appraisal.php?appraisal_id=" . $appraisal_id;
            
            $mail->Body = "
                <html>
                <body style='font-family: Arial, sans-serif; line-height: 1.6;'>
                    <div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>
                        <h2 style='color: #2c3e50;'>Performance Appraisal Notification</h2>
                        <p>Dear $employee_name,</p>
                        <p>Your performance appraisal for <strong>$cycle_name</strong> has been completed by $appraiser_name and is now ready for your review.</p>
                        <p>Please log in to the HR Management System to view your appraisal and provide your comments.</p>
                        <div style='text-align: center; margin: 25px 0;'>
                            <a href='$appraisal_url' style='background-color: #4CAF50; color: white; padding: 12px 24px; text-align: center; text-decoration: none; display: inline-block; border-radius: 5px; font-weight: bold;'>View Appraisal</a>
                        </div>
                        <p>If you have any questions, please contact HR or your appraiser.</p>
                        <br>
                        <p>Best regards,<br>HR Management Team</p>
                        <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;'>
                        <p style='font-size: 12px; color: #7f8c8d;'>
                            This is an automated notification. Please do not reply to this email.
                        </p>
                    </div>
                </body>
                </html>
            ";
            
            $mail->AltBody = "Dear $employee_name,\n\nYour performance appraisal for $cycle_name has been completed by $appraiser_name and is now ready for your review.\n\nPlease log in to the HR Management System to view your appraisal and provide your comments.\n\nAppraisal URL: $appraisal_url\n\nIf you have any questions, please contact HR or your appraiser.\n\nBest regards,\nHR Management Team";
            
            $mail->send();
            return true;
        } catch (Exception $e) {
            error_log("Email could not be sent. Mailer Error: {$mail->ErrorInfo}");
            return false;
        }
    }
    return false;
}

// Get user's employee record with null checks
$userEmployeeQuery = "SELECT e.*, d.id as department_id, s.id as section_id, ss.id as subsection_id
                     FROM employees e
                     LEFT JOIN users u ON u.employee_id = e.employee_id 
                     LEFT JOIN departments d ON e.department_id = d.id
                     LEFT JOIN sections s ON e.section_id = s.id
                     LEFT JOIN subsections ss ON e.subsection_id = ss.id
                     WHERE u.id = ?";
$stmt = $conn->prepare($userEmployeeQuery);
$stmt->bind_param("i", $user['id']);
$stmt->execute();
$currentEmployee = $stmt->get_result()->fetch_assoc();

if (!$currentEmployee) {
    $_SESSION['flash_message'] = 'Employee record not found. Please contact HR.';
    $_SESSION['flash_type'] = 'danger';
    header("Location: dashboard.php");
    exit();
}

// SECURE ACCESS CONTROL - Validate employee access using profile tokens
function canAccessEmployee($conn, $currentEmployee, $target_employee_id) {
    // HR managers and super admins can access all employees
    if (hasPermission('hr_manager') || hasPermission('super_admin') || hasPermission('managing_director')) {
        return true;
    }
    
    // Get target employee details
    $targetStmt = $conn->prepare("
        SELECT e.*, d.id as department_id, s.id as section_id, ss.id as subsection_id
        FROM employees e
        LEFT JOIN departments d ON e.department_id = d.id
        LEFT JOIN sections s ON e.section_id = s.id
        LEFT JOIN subsections ss ON e.subsection_id = ss.id
        WHERE e.id = ?
    ");
    $targetStmt->bind_param("i", $target_employee_id);
    $targetStmt->execute();
    $targetEmployee = $targetStmt->get_result()->fetch_assoc();
    
    if (!$targetEmployee) {
        return false;
    }
    
    // Check access based on user role and organizational hierarchy
    switch ($_SESSION['user_role']) {
        case 'section_head':
            return !empty($currentEmployee['section_id']) && 
                   $targetEmployee['section_id'] == $currentEmployee['section_id'];
            
        case 'sub_section_head':
            return !empty($currentEmployee['subsection_id']) && 
                   $targetEmployee['subsection_id'] == $currentEmployee['subsection_id'];
            
        case 'dept_head':
            return !empty($currentEmployee['department_id']) && 
                   $targetEmployee['department_id'] == $currentEmployee['department_id'];
            
        case 'manager':
            return !empty($currentEmployee['section_id']) && 
                   $targetEmployee['section_id'] == $currentEmployee['section_id'];
            
        default:
            return false;
    }
}

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        switch ($_POST['action']) {
            case 'save_scores':
                $appraisal_id = $_POST['appraisal_id'];
                $scores = $_POST['scores'] ?? [];
                $comments = $_POST['comments'] ?? [];
                
                // Verify the current user is the appraiser for this appraisal
                $verifyStmt = $conn->prepare("SELECT appraiser_id FROM employee_appraisals WHERE id = ?");
                $verifyStmt->bind_param("i", $appraisal_id);
                $verifyStmt->execute();
                $verifyResult = $verifyStmt->get_result();
                
                if ($verifyResult->num_rows === 0 || $verifyResult->fetch_assoc()['appraiser_id'] != $currentEmployee['id']) {
                    $_SESSION['flash_message'] = 'Unauthorized access.';
                    $_SESSION['flash_type'] = 'danger';
                    header("Location: performance_appraisal.php");
                    exit();
                }
                
                foreach ($scores as $indicator_id => $score) {
                    $comment = $comments[$indicator_id] ?? '';
                    
                    $scoreStmt = $conn->prepare("
                        INSERT INTO appraisal_scores (employee_appraisal_id, performance_indicator_id, score, appraiser_comment)
                        VALUES (?, ?, ?, ?)
                        ON DUPLICATE KEY UPDATE 
                        score = VALUES(score), 
                        appraiser_comment = VALUES(appraiser_comment),
                        updated_at = CURRENT_TIMESTAMP
                    ");
                    $scoreStmt->bind_param("iids", $appraisal_id, $indicator_id, $score, $comment);
                    $scoreStmt->execute();
                }
                
                // Check if we're changing status from draft to awaiting_employee
                $statusCheckStmt = $conn->prepare("SELECT status FROM employee_appraisals WHERE id = ?");
                $statusCheckStmt->bind_param("i", $appraisal_id);
                $statusCheckStmt->execute();
                $statusResult = $statusCheckStmt->get_result();
                $currentStatus = $statusResult->fetch_assoc()['status'];
                
                $statusChanged = false;
                if ($currentStatus === 'draft') {
                    // Update status to awaiting_employee
                    $updateStmt = $conn->prepare("UPDATE employee_appraisals SET status = 'awaiting_employee', updated_at = CURRENT_TIMESTAMP WHERE id = ?");
                    $updateStmt->bind_param("i", $appraisal_id);
                    $updateStmt->execute();
                    $statusChanged = true;
                    
                    // Send email notification
                    $emailSent = sendAppraisalNotification($appraisal_id, $conn);
                } else {
                    // Just update timestamp
                    $updateStmt = $conn->prepare("UPDATE employee_appraisals SET updated_at = CURRENT_TIMESTAMP WHERE id = ?");
                    $updateStmt->bind_param("i", $appraisal_id);
                    $updateStmt->execute();
                }
                
                $_SESSION['flash_message'] = 'Appraisal scores saved successfully. ' . 
                                            ($statusChanged ? 'Notification sent to employee.' : '');
                $_SESSION['flash_type'] = 'success';
                break;
                
            case 'submit_appraisal':
                $appraisal_id = $_POST['appraisal_id'];
                
                // Verify the current user is the appraiser for this appraisal
                $verifyStmt = $conn->prepare("SELECT appraiser_id FROM employee_appraisals WHERE id = ?");
                $verifyStmt->bind_param("i", $appraisal_id);
                $verifyStmt->execute();
                $verifyResult = $verifyStmt->get_result();
                
                if ($verifyResult->num_rows === 0 || $verifyResult->fetch_assoc()['appraiser_id'] != $currentEmployee['id']) {
                    $_SESSION['flash_message'] = 'Unauthorized access.';
                    $_SESSION['flash_type'] = 'danger';
                    header("Location: performance_appraisal.php");
                    exit();
                }
                
                $checkStmt = $conn->prepare("SELECT employee_comment, status FROM employee_appraisals WHERE id = ?");
                $checkStmt->bind_param("i", $appraisal_id);
                $checkStmt->execute();
                $result = $checkStmt->get_result();
                $appraisal = $result->fetch_assoc();
                
                if ($appraisal && !empty($appraisal['employee_comment'])) {
                    // If in awaiting_submission and user has appraisal access, validate and save supervisor comment
                    if ($appraisal['status'] === 'awaiting_submission' && hasAppraisalAccess($user['role'])) {
                        $supervisor_comment = trim($_POST['supervisor_comment'] ?? '');
                        if (empty($supervisor_comment)) {
                            $_SESSION['flash_message'] = 'Supervisor comment is required for submission.';
                            $_SESSION['flash_type'] = 'warning';
                            header("Location: performance_appraisal.php" . (!empty($_GET['employee_token']) ? '?employee_token=' . $_GET['employee_token'] : ''));
                            exit();
                        }
                        
                        // Save supervisor comment
                        $commentStmt = $conn->prepare("
                            UPDATE employee_appraisals 
                            SET supervisors_comment = ?, 
                                supervisors_comment_date = CURRENT_TIMESTAMP,
                                updated_at = CURRENT_TIMESTAMP
                            WHERE id = ? AND status = 'awaiting_submission'
                        ");
                        $commentStmt->bind_param("si", $supervisor_comment, $appraisal_id);
                        $commentStmt->execute();
                    }
                    
                    // Proceed with submission
                    $submitStmt = $conn->prepare("UPDATE employee_appraisals SET status = 'submitted', submitted_at = CURRENT_TIMESTAMP WHERE id = ?");
                    $submitStmt->bind_param("i", $appraisal_id);
                    $submitStmt->execute();
                    
                    $_SESSION['flash_message'] = 'Appraisal submitted successfully.';
                    $_SESSION['flash_type'] = 'success';
                } else {
                    $_SESSION['flash_message'] = 'Cannot submit appraisal. Employee comment is required.';
                    $_SESSION['flash_type'] = 'warning';
                }
                break;
                
            case 'save_employee_comment':
                $appraisal_id = $_POST['appraisal_id'];
                $comment = trim($_POST['employee_comment'] ?? '');
                
                if (!empty($comment)) {
                    $commentStmt = $conn->prepare("UPDATE employee_appraisals 
                                                 SET employee_comment = ?, 
                                                 employee_comment_date = CURRENT_TIMESTAMP,
                                                 status = 'awaiting_submission'
                                                 WHERE id = ?");
                    $commentStmt->bind_param("si", $comment, $appraisal_id);
                    $commentStmt->execute();
                    
                    $_SESSION['flash_message'] = 'Your comments have been saved. Awaiting supervisor review.';
                    $_SESSION['flash_type'] = 'success';
                } else {
                    $_SESSION['flash_message'] = 'Please enter your comments before saving.';
                    $_SESSION['flash_type'] = 'warning';
                }
                break;
        }
        
        header("Location: performance_appraisal.php" . (!empty($_GET['employee_token']) ? '?employee_token=' . $_GET['employee_token'] : ''));
        exit();
    }
}

// SECURE EMPLOYEE SELECTION - Use profile tokens instead of direct IDs
$selected_employee_token = $_GET['employee_token'] ?? null;
$selected_employee_id = null;

if ($selected_employee_token) {
    // Get employee ID from profile token
    $tokenStmt = $conn->prepare("SELECT id FROM employees WHERE profile_token = ?");
    $tokenStmt->bind_param("s", $selected_employee_token);
    $tokenStmt->execute();
    $tokenResult = $tokenStmt->get_result();
    
    if ($tokenResult->num_rows > 0) {
        $selected_employee_id = $tokenResult->fetch_assoc()['id'];
        
        // Validate access to this employee
        if (!canAccessEmployee($conn, $currentEmployee, $selected_employee_id)) {
            $_SESSION['flash_message'] = 'Access denied. You are not authorized to appraise this employee.';
            $_SESSION['flash_type'] = 'danger';
            header("Location: performance_appraisal.php");
            exit();
        }
    } else {
        $_SESSION['flash_message'] = 'Employee not found.';
        $_SESSION['flash_type'] = 'danger';
        header("Location: performance_appraisal.php");
        exit();
    }
}

// Get active appraisal cycles that haven't been submitted for selected employee
$cyclesQuery = "
    SELECT ac.* 
    FROM appraisal_cycles ac
    WHERE ac.status = 'active'
    " . ($selected_employee_id ? "AND NOT EXISTS (
        SELECT 1 FROM employee_appraisals ea
        WHERE ea.appraisal_cycle_id = ac.id
        AND ea.employee_id = ?
        AND ea.status = 'submitted'
    )" : "") . "
    ORDER BY ac.start_date DESC
";

$cyclesStmt = $conn->prepare($cyclesQuery);
if ($selected_employee_id) {
    $cyclesStmt->bind_param("i", $selected_employee_id);
}
$cyclesStmt->execute();
$cycles = $cyclesStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get selected cycle (default to first active cycle)
$selected_cycle_id = $_GET['cycle_id'] ?? ($cycles[0]['id'] ?? null);

// Get employees based on user role with proper null checks - exclude current user
$employeesQuery = "";
$employeesParams = [];

switch ($user['role']) {
    case 'section_head':
        if (!empty($currentEmployee['section_id'])) {
            $employeesQuery = "
                SELECT e.id, e.first_name, e.last_name, e.employee_id, e.profile_token,
                       d.name as department_name, s.name as section_name, 
                       ss.name as subsection_name, e.employee_type as job_role
                FROM employees e
                LEFT JOIN departments d ON e.department_id = d.id
                LEFT JOIN sections s ON e.section_id = s.id
                LEFT JOIN subsections ss ON e.subsection_id = ss.id
                LEFT JOIN users u ON u.employee_id = e.id
                WHERE e.section_id = ? AND e.employee_status = 'active' AND e.id != ?
                ORDER BY e.first_name, e.last_name
            ";
            $employeesParams = [$currentEmployee['section_id'], $currentEmployee['id']];
        }
        break;
        
    case 'sub_section_head':
        if (!empty($currentEmployee['subsection_id'])) {
            $employeesQuery = "
                SELECT e.id, e.first_name, e.last_name, e.employee_id, e.profile_token,
                       d.name as department_name, s.name as section_name, 
                       ss.name as subsection_name, e.employee_type as job_role
                FROM employees e
                LEFT JOIN departments d ON e.department_id = d.id
                LEFT JOIN sections s ON e.section_id = s.id
                LEFT JOIN subsections ss ON e.subsection_id = ss.id
                LEFT JOIN users u ON u.employee_id = e.id
                WHERE e.subsection_id = ? AND e.employee_status = 'active' AND e.id != ?
                ORDER BY e.first_name, e.last_name
            ";
            $employeesParams = [$currentEmployee['subsection_id'], $currentEmployee['id']];
        }
        break;
        
    case 'dept_head':
        if (!empty($currentEmployee['department_id'])) {
            $employeesQuery = "
                SELECT e.id, e.first_name, e.last_name, e.employee_id, e.profile_token,
                       d.name as department_name, s.name as section_name, 
                       ss.name as subsection_name, e.employee_type as job_role
                FROM employees e
                LEFT JOIN departments d ON e.department_id = d.id
                LEFT JOIN sections s ON e.section_id = s.id
                LEFT JOIN subsections ss ON e.subsection_id = ss.id
                LEFT JOIN users u ON u.employee_id = e.id
                WHERE e.department_id = ? AND e.employee_status = 'active' AND e.id != ?
                ORDER BY e.first_name, e.last_name
            ";
            $employeesParams = [$currentEmployee['department_id'], $currentEmployee['id']];
        }
        break;
        
    case 'manager':
        if (!empty($currentEmployee['section_id'])) {
            $employeesQuery = "
                SELECT e.id, e.first_name, e.last_name, e.employee_id, e.profile_token,
                       d.name as department_name, s.name as section_name, 
                       ss.name as subsection_name, e.employee_type as job_role
                FROM employees e
                LEFT JOIN departments d ON e.department_id = d.id
                LEFT JOIN sections s ON e.section_id = s.id
                LEFT JOIN subsections ss ON e.subsection_id = ss.id
                LEFT JOIN users u ON u.employee_id = e.id
                WHERE e.section_id = ? AND e.employee_status = 'active' AND e.id != ?
                ORDER BY e.first_name, e.last_name
            ";
            $employeesParams = [$currentEmployee['section_id'], $currentEmployee['id']];
        }
        break;
        
    case 'hr_manager':
    case 'super_admin':
    case 'managing_director':
        $employeesQuery = "
            SELECT e.id, e.first_name, e.last_name, e.employee_id, e.profile_token,
                   d.name as department_name, s.name as section_name, 
                   ss.name as subsection_name, e.employee_type as job_role
            FROM employees e
            LEFT JOIN departments d ON e.department_id = d.id
            LEFT JOIN sections s ON e.section_id = s.id
            LEFT JOIN subsections ss ON e.subsection_id = ss.id
            LEFT JOIN users u ON u.employee_id = e.id
            WHERE e.employee_status = 'active' AND e.id != ?
            ORDER BY e.first_name, e.last_name
        ";
        $employeesParams = [$currentEmployee['id']];
        break;
}

// Execute the employees query
$employees = [];
if (!empty($employeesQuery)) {
    $employeesStmt = $conn->prepare($employeesQuery);
    if (!empty($employeesParams)) {
        $employeesStmt->bind_param(str_repeat('i', count($employeesParams)), ...$employeesParams);
    }
    $employeesStmt->execute();
    $employees = $employeesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

// Get performance indicators with CORRECTED prioritized filtering
$indicators = [];
if ($selected_employee_id) {
    $appraiseeStmt = $conn->prepare("
        SELECT e.*, d.id as department_id, s.id as section_id, ss.id as subsection_id,
               e.employee_type as job_role
        FROM employees e
        LEFT JOIN departments d ON e.department_id = d.id
        LEFT JOIN sections s ON e.section_id = s.id
        LEFT JOIN subsections ss ON e.subsection_id = ss.id
        LEFT JOIN users u ON u.employee_id = e.id
        WHERE e.id = ?
    ");
    $appraiseeStmt->bind_param("i", $selected_employee_id);
    $appraiseeStmt->execute();
    $appraiseeDetails = $appraiseeStmt->get_result()->fetch_assoc();

    if ($appraiseeDetails) {
        $deptId = $appraiseeDetails['department_id'];
        $sectionId = $appraiseeDetails['section_id'];
        $subsectionId = $appraiseeDetails['subsection_id'];
        $role = $appraiseeDetails['job_role'];

        // FIXED: Build WHERE clause with proper logic for subsection handling
        $whereConditions = ["pi.is_active = 1"];
        $types = "";
        $params = [];

        // Add conditions for different specificity levels
        $conditions = [];
        
        // Most specific: Subsection + Role
        if ($subsectionId) {
            $conditions[] = "(pi.subsection_id = ? AND pi.role = ?)";
            $types .= "is";
            $params[] = $subsectionId;
            $params[] = $role;
        }
        
        // Section + Role
        if ($sectionId) {
            $conditions[] = "(pi.section_id = ? AND pi.role = ? AND pi.subsection_id IS NULL)";
            $types .= "is";
            $params[] = $sectionId;
            $params[] = $role;
        }
        
        // Department + Role
        if ($deptId) {
            $conditions[] = "(pi.department_id = ? AND pi.role = ? AND pi.section_id IS NULL AND pi.subsection_id IS NULL)";
            $types .= "is";
            $params[] = $deptId;
            $params[] = $role;
        }
        
        // Role only (most generic)
        $conditions[] = "(pi.role = ? AND pi.department_id IS NULL AND pi.section_id IS NULL AND pi.subsection_id IS NULL)";
        $types .= "s";
        $params[] = $role;
        
        // Subsection only (without specific role)
        if ($subsectionId) {
            $conditions[] = "(pi.subsection_id = ? AND pi.role IS NULL)";
            $types .= "i";
            $params[] = $subsectionId;
        }
        
        // Section only (without specific role)
        if ($sectionId) {
            $conditions[] = "(pi.section_id = ? AND pi.role IS NULL AND pi.subsection_id IS NULL)";
            $types .= "i";
            $params[] = $sectionId;
        }
        
        // Department only (without specific role)
        if ($deptId) {
            $conditions[] = "(pi.department_id = ? AND pi.role IS NULL AND pi.section_id IS NULL AND pi.subsection_id IS NULL)";
            $types .= "i";
            $params[] = $deptId;
        }

        $whereConditions[] = "(" . implode(" OR ", $conditions) . ")";

        // Build ORDER BY clause for proper prioritization
        $orderByConditions = [];
        
        if ($subsectionId) {
            $orderByConditions[] = "CASE WHEN pi.subsection_id = ? THEN 1 ELSE 0 END DESC";
            $types .= "i";
            $params[] = $subsectionId;
        }
        
        if ($sectionId) {
            $orderByConditions[] = "CASE WHEN pi.section_id = ? THEN 1 ELSE 0 END DESC";
            $types .= "i";
            $params[] = $sectionId;
        }
        
        if ($deptId) {
            $orderByConditions[] = "CASE WHEN pi.department_id = ? THEN 1 ELSE 0 END DESC";
            $types .= "i";
            $params[] = $deptId;
        }
        
        $orderByConditions[] = "CASE WHEN pi.role = ? THEN 1 ELSE 0 END DESC";
        $types .= "s";
        $params[] = $role;

        $indicatorsQuery = "
            SELECT pi.* 
            FROM performance_indicators pi
            WHERE " . implode(" AND ", $whereConditions) . "
            ORDER BY " . implode(", ", $orderByConditions) . ", pi.max_score DESC, pi.name
        ";

        $indicatorsStmt = $conn->prepare($indicatorsQuery);
        if ($indicatorsStmt) {
            $indicatorsStmt->bind_param($types, ...$params);
            $indicatorsStmt->execute();
            $indicators = $indicatorsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
        }
    }
}

// Get existing appraisals for the selected cycle and employee
$appraisals = [];
if ($selected_cycle_id && $selected_employee_id) {
    $appraisalsQuery = "
        SELECT ea.*, e.first_name, e.last_name, e.employee_id as emp_id, ea.supervisors_comment, ea.supervisors_comment_date
        FROM employee_appraisals ea
        JOIN employees e ON ea.employee_id = e.id
        WHERE ea.appraisal_cycle_id = ? AND ea.employee_id = ?
        AND ea.appraiser_id = ?
        AND (ea.status = 'draft' OR ea.status = 'awaiting_submission')
    ";
    
    $appraisalsStmt = $conn->prepare($appraisalsQuery);
    $appraisalsStmt->bind_param("iii", $selected_cycle_id, $selected_employee_id, $currentEmployee['id']);
    $appraisalsStmt->execute();
    $appraisals = $appraisalsStmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

// Create appraisals for selected employee if they don't have one yet
if ($selected_cycle_id && $selected_employee_id) {
    $checkStmt = $conn->prepare("
        SELECT id FROM employee_appraisals 
        WHERE employee_id = ? AND appraisal_cycle_id = ?
    ");
    $checkStmt->bind_param("ii", $selected_employee_id, $selected_cycle_id);
    $checkStmt->execute();
    $result = $checkStmt->get_result();
    
    if ($result->num_rows === 0) {
        $createStmt = $conn->prepare("
            INSERT INTO employee_appraisals 
            (employee_id, appraiser_id, appraisal_cycle_id, status)
            VALUES (?, ?, ?, 'draft')
        ");
        $createStmt->bind_param("iii", $selected_employee_id, $currentEmployee['id'], $selected_cycle_id);
        
        if ($createStmt->execute()) {
            $new_appraisal_id = $createStmt->insert_id;
            header("Location: performance_appraisal.php?cycle_id=$selected_cycle_id&employee_token=$selected_employee_token");
            exit();
        }
    }
}

// Get scores for existing appraisals
$scores_by_appraisal = [];
if (!empty($appraisals)) {
    $appraisal_ids = array_column($appraisals, 'id');
    $placeholders = str_repeat('?,', count($appraisal_ids) - 1) . '?';
    
    $scoresQuery = "
        SELECT as_.*
        FROM appraisal_scores as_
        WHERE as_.employee_appraisal_id IN ($placeholders)
    ";
    
    $scoresStmt = $conn->prepare($scoresQuery);
    $types = str_repeat('i', count($appraisal_ids));
    $scoresStmt->bind_param($types, ...$appraisal_ids);
    $scoresStmt->execute();
    $scores = $scoresStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    
    foreach ($scores as $score) {
        $scores_by_appraisal[$score['employee_appraisal_id']][$score['performance_indicator_id']] = $score;
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Appraisal - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .appraisal-card {
            background: var(--bg-glass);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
        }
        
        .appraisal-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .employee-info h4 {
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }
        
        .employee-details {
            color: var(--text-secondary);
            font-size: 0.875rem;
            line-height: 1.5;
        }
        
        .employee-details strong {
            color: var(--text-primary);
        }
        
        .appraisal-status {
            text-align: right;
            min-width: 200px;
        }
        
        .indicators-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 1.5rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .indicators-table th,
        .indicators-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .indicators-table th {
            background: var(--bg-glass);
            color: var(--text-primary);
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .indicators-table td {
            color: var(--text-secondary);
            font-size: 0.875rem;
            vertical-align: top;
        }
        
        .score-input {
            width: 80px;
            padding: 0.5rem;
            background: var(--bg-glass);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: var(--text-primary);
            text-align: center;
        }
        
        .comment-textarea {
            width: 100%;
            min-height: 60px;
            padding: 0.5rem;
            background: var(--bg-glass);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: var(--text-primary);
            resize: vertical;
            font-family: inherit;
        }
        
        .readonly-field {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.1);
            color: var(--text-muted);
            cursor: not-allowed;
        }
        
        .status-message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-weight: 500;
        }
        
        .status-draft {
            background: rgba(108, 117, 125, 0.1);
            color: var(--secondary-color);
            border: 1px solid rgba(108, 117, 125, 0.3);
        }
        
        .status-awaiting {
            background: rgba(253, 203, 110, 0.1);
            color: var(--warning-color);
            border: 1px solid rgba(253, 203, 110, 0.3);
        }
        
        .status-submitted {
            background: rgba(0, 184, 148, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(0, 184, 148, 0.3);
        }
        
        .status-awaiting-submission {
            background: rgba(23, 162, 184, 0.1);
            color: var(--info-color);
            border: 1px solid rgba(23, 162, 184, 0.3);
        }
        
        .cycle-selector {
            margin-bottom: 2rem;
        }
        
        .weight-badge {
            background: rgba(0, 212, 255, 0.2);
            color: var(--primary-color);
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .employee-selector {
            margin-bottom: 1.5rem;
        }
        
        .form-control {
            display: block;
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: var(--text-primary);
            background-color: var(--bg-glass);
            background-clip: padding-box;
            border: 1px solid var(--border-color);
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            border-radius: 8px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            backdrop-filter: blur(20px);
        }
        
        .form-control:focus {
            color: var(--text-primary);
            background-color: var(--bg-glass);
            border-color: var(--primary-color);
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(0, 212, 255, 0.25);
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .employee-comment-form, .supervisor-comment-form {
            margin-top: 2rem;
            padding: 1.5rem;
            background: var(--bg-glass);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        
        .indicator-scope {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 0.25rem;
            display: inline-block;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .scope-department { 
            color: var(--primary-color); 
            background: rgba(0, 212, 255, 0.1);
        }
        .scope-section { 
            color: var(--warning-color); 
            background: rgba(253, 203, 110, 0.1);
        }
        .scope-subsection { 
            color: var(--info-color); 
            background: rgba(23, 162, 184, 0.1);
        }
        .scope-role { 
            color: var(--success-color); 
            background: rgba(0, 184, 148, 0.1);
        }
        
        .no-appraisals {
            padding: 2rem;
            text-align: center;
            background: var(--bg-glass);
            border-radius: 8px;
            border: 1px dashed var(--border-color);
        }
        
        .no-appraisals h4 {
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        
        .no-appraisals p {
            color: var(--text-secondary);
            margin-bottom: 1rem;
        }
        
        .readonly-comment {
            background: rgba(255, 255, 255, 0.05);
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            line-height: 1.6;
            white-space: pre-wrap;
        }
        
        .form-actions {
            margin-top: 1.5rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-block;
            font-weight: 400;
            line-height: 1.5;
            color: var(--text-primary);
            text-align: center;
            text-decoration: none;
            vertical-align: middle;
            cursor: pointer;
            -webkit-user-select: none;
            -moz-user-select: none;
            user-select: none;
            background-color: transparent;
            border: 1px solid transparent;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            border-radius: 8px;
            transition: all 0.15s ease-in-out;
        }
        
        .btn-primary {
            color: #fff;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-success {
            color: #fff;
            background-color: var(--success-color);
            border-color: var(--success-color);
        }
        
        .btn-info {
            color: #fff;
            background-color: var(--info-color);
            border-color: var(--info-color);
        }
        
        .glass-card {
            background: var(--bg-glass);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-md);
        }
        
        .alert {
            position: relative;
            padding: 1rem 1rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 8px;
        }
        
        .alert-success {
            color: #0f5132;
            background-color: #d1e7dd;
            border-color: #badbcc;
        }
        
        .alert-warning {
            color: #664d03;
            background-color: #fff3cd;
            border-color: #ffecb5;
        }
        
        .alert-info {
            color: #055160;
            background-color: #cff4fc;
            border-color: #b6effb;
        }
        
        .alert-danger {
            color: #842029;
            background-color: #f8d7da;
            border-color: #f5c2c7;
        }
        
        .badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            line-height: 1;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.375rem;
        }
        
        .badge-secondary {
            background-color: #6c757d;
        }
        
        .badge-info {
            background-color: #17a2b8;
        }
        
        .badge-success {
            background-color: #28a745;
        }
        
        .text-muted {
            color: #6c757d !important;
        }
        
        .mt-3 {
            margin-top: 1rem !important;
        }
        
        .mb-3 {
            margin-bottom: 1rem !important;
        }
        
        @media (max-width: 768px) {
            .appraisal-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .appraisal-status {
                text-align: left;
            }
            
            .indicators-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        
        <!-- Main Content Area -->
        <div class="main-content">
            
            <!-- Content -->
            <div class="content">
                <?php if (isset($_SESSION['flash_message']) && isset($_SESSION['flash_type'])): ?>
                    <div class="alert alert-<?php echo htmlspecialchars($_SESSION['flash_type']); ?>">
                        <?php echo htmlspecialchars($_SESSION['flash_message']); ?>
                        <?php
                        // Clear flash message after displaying
                        unset($_SESSION['flash_message']);
                        unset($_SESSION['flash_type']);
                        ?>
                    </div>
                <?php endif; ?>
                
                <div class="leave-tabs">
                    <a href="strategic_plan.php?tab=goals" class="leave-tab">Strategic Plan</a>
                    <a href="employee_appraisal.php" class="leave-tab">Employee Appraisal</a>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager', 'managing_director', 'section_head', 'dept_head' , 'sub_section_head'])): ?>
                        <a href="performance_appraisal.php" class="leave-tab active">Performance Appraisal</a>
                    <?php endif; ?>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager'])): ?>
                        <a href="appraisal_management.php" class="leave-tab">Appraisal Management</a>
                    <?php endif; ?>
                    <a href="completed_appraisals.php" class="leave-tab">Completed Appraisals</a>
                </div>

                <!-- Employee Selector -->
                <div class="employee-selector glass-card">
                    <h3>Select Employee</h3>
                    <div class="form-group">
                        <select id="employee-select" class="form-control" onchange="updateEmployeeSelection()">
                            <option value="">Select an employee...</option>
                            <?php foreach ($employees as $emp): ?>
                                <?php if ($emp['id'] != $currentEmployee['id']): ?>
                                    <option value="<?php echo $emp['profile_token']; ?>" 
                                        <?php echo ($selected_employee_token == $emp['profile_token']) ? 'selected' : ''; ?>>
                                        <?php 
                                        $displayText = htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name'] . ' (' . $emp['employee_id'] . ')');
                                        $displayText .= ' - ' . htmlspecialchars($emp['department_name'] ?? 'N/A');
                                        if ($emp['subsection_name']) {
                                            $displayText .= ' - ' . htmlspecialchars($emp['subsection_name']);
                                        } elseif ($emp['section_name']) {
                                            $displayText .= ' - ' . htmlspecialchars($emp['section_name']);
                                        }
                                        echo $displayText;
                                        ?>
                                    </option>
                                <?php endif; ?>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <!-- Cycle Selector -->
                <div class="cycle-selector glass-card">
                    <h3>Select Appraisal Cycle</h3>
                    <div class="form-group">
                        <select class="form-control" id="cycle-select" onchange="updateCycleSelection()">
                            <option value="">Select a cycle...</option>
                            <?php foreach ($cycles as $cycle): ?>
                                <option value="<?php echo $cycle['id']; ?>" <?php echo ($selected_cycle_id == $cycle['id']) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($cycle['name']); ?> 
                                    (<?php echo date('M d, Y', strtotime($cycle['start_date'])); ?> - <?php echo date('M d, Y', strtotime($cycle['end_date'])); ?>)
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <?php if ($selected_cycle_id && $selected_employee_id): ?>
                    <?php if (!empty($appraisals)): ?>
                        <?php foreach ($appraisals as $appraisal): 
                            $is_readonly = ($appraisal['submitted_at'] !== null);
                            $employee_scores = $scores_by_appraisal[$appraisal['id']] ?? [];
                            
                            // Get employee details
                            $employeeDetails = null;
                            foreach ($employees as $emp) {
                                if ($emp['id'] == $appraisal['employee_id']) {
                                    $employeeDetails = $emp;
                                    break;
                                }
                            }
                        ?>
                            <div class="appraisal-card">
                                <div class="appraisal-header">
                                    <div class="employee-info">
                                        <h4><?php echo htmlspecialchars($appraisal['first_name'] . ' ' . $appraisal['last_name']); ?></h4>
                                        <div class="employee-details">
                                            <strong>Employee ID:</strong> <?php echo htmlspecialchars($appraisal['emp_id']); ?><br>
                                            <strong>Department:</strong> <?php echo htmlspecialchars($employeeDetails['department_name'] ?? 'N/A'); ?><br>
                                            <strong>Section:</strong> <?php echo htmlspecialchars($employeeDetails['section_name'] ?? 'N/A'); ?><br>
                                            <strong>Subsection:</strong> <?php echo htmlspecialchars($employeeDetails['subsection_name'] ?? 'N/A'); ?><br>
                                            <strong>Role:</strong> <?php echo ucwords(str_replace('_', ' ', $employeeDetails['job_role'] ?? 'employee')); ?>
                                        </div>
                                    </div>
                                    <div class="appraisal-status">
                                        <?php if ($appraisal['status'] === 'awaiting_submission'): ?>
                                            <span class="badge badge-info">Awaiting Submission</span>
                                            <div class="status-awaiting-submission status-message">
                                                Employee has commented. Ready for supervisor review and submission.
                                            </div>
                                        <?php elseif ($appraisal['status'] === 'awaiting_employee'): ?>
                                            <span class="badge badge-warning">Awaiting Employee</span>
                                            <div class="status-awaiting status-message">
                                                Waiting for employee to provide comments.
                                            </div>
                                        <?php elseif ($appraisal['status'] === 'submitted'): ?>
                                            <span class="badge badge-success">Submitted</span>
                                            <div class="status-submitted status-message">
                                                Appraisal has been submitted.
                                            </div>
                                        <?php else: ?>
                                            <span class="badge badge-secondary">Draft</span>
                                            <div class="status-draft status-message">
                                                Draft - Not yet shared with employee
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                </div>

                                <?php if (empty($indicators)): ?>
                                    <div class="alert alert-warning">
                                        <strong>No performance indicators found!</strong><br>
                                        Please check that indicators are properly configured for:<br>
                                        - Role: <?php echo htmlspecialchars($employeeDetails['job_role'] ?? 'N/A'); ?><br>
                                        - Department: <?php echo htmlspecialchars($employeeDetails['department_name'] ?? 'N/A'); ?><br>
                                        - Section: <?php echo htmlspecialchars($employeeDetails['section_name'] ?? 'N/A'); ?><br>
                                        - Subsection: <?php echo htmlspecialchars($employeeDetails['subsection_name'] ?? 'N/A'); ?>
                                    </div>
                                <?php else: ?>
                                    <form method="POST" action="">
                                        <input type="hidden" name="action" value="save_scores">
                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                        
                                        <table class="indicators-table">
                                            <thead>
                                                <tr>
                                                    <th>Performance Indicator</th>
                                                    <th width="100">Score</th>
                                                    <th>Appraiser Comment</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach ($indicators as $indicator): 
                                                    $score_data = $employee_scores[$indicator['id']] ?? null;
                                                    $scope_class = '';
                                                    $scope_text = '';
                                                    
                                                    // Determine scope for display
                                                    if ($indicator['subsection_id']) {
                                                        $scope_class = 'scope-subsection';
                                                        $scope_text = 'Subsection';
                                                    } elseif ($indicator['section_id']) {
                                                        $scope_class = 'scope-section';
                                                        $scope_text = 'Section';
                                                    } elseif ($indicator['department_id']) {
                                                        $scope_class = 'scope-department';
                                                        $scope_text = 'Department';
                                                    } elseif ($indicator['role']) {
                                                        $scope_class = 'scope-role';
                                                        $scope_text = 'Role: ' . ucwords(str_replace('_', ' ', $indicator['role']));
                                                    }
                                                ?>
                                                    <tr>
                                                        <td>
                                                            <strong><?php echo htmlspecialchars($indicator['name']); ?></strong>
                                                            <span class="indicator-scope <?php echo $scope_class; ?>">
                                                                <?php echo $scope_text; ?>
                                                            </span>
                                                            <?php if ($indicator['description']): ?>
                                                                <br><small class="text-muted"><?php echo htmlspecialchars($indicator['description']); ?></small>
                                                            <?php endif; ?>
                                                            <div class="text-muted" style="margin-top: 0.25rem; font-size: 0.75rem;">
                                                                Max Score: <?php echo $indicator['max_score']; ?>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <input type="number" 
                                                                   name="scores[<?php echo $indicator['id']; ?>]" 
                                                                   class="score-input <?php echo $is_readonly ? 'readonly-field' : ''; ?>"
                                                                   min="1" max="<?php echo $indicator['max_score']; ?>" 
                                                                   step="0.1"
                                                                   value="<?php echo $score_data ? htmlspecialchars($score_data['score']) : ''; ?>"
                                                                   <?php echo $is_readonly ? 'readonly' : ''; ?>
                                                                   required>
                                                        </td>
                                                        <td>
                                                            <textarea name="comments[<?php echo $indicator['id']; ?>]" 
                                                                      class="comment-textarea <?php echo $is_readonly ? 'readonly-field' : ''; ?>"
                                                                      placeholder="Enter your comment..."
                                                                      <?php echo $is_readonly ? 'readonly' : ''; ?>><?php echo $score_data ? htmlspecialchars($score_data['appraiser_comment']) : ''; ?></textarea>
                                                        </td>
                                                    </tr>
                                                <?php endforeach; ?>
                                            </tbody>
                                        </table>

                                        <?php if (!$is_readonly && $appraisal['status'] !== 'awaiting_submission'): ?>
                                            <div class="form-actions">
                                                <button type="submit" class="btn btn-primary">Save Scores</button>
                                                <?php if ($appraisal['status'] === 'draft'): ?>
                                                    <small class="text-muted" style="align-self: center;">
                                                        Saving will send notification to employee for comments
                                                    </small>
                                                <?php endif; ?>
                                            </div>
                                        <?php endif; ?>
                                    </form>
                                <?php endif; ?>

                                <!-- Employee Comment Section -->
                                <?php if ($appraisal['employee_comment']): ?>
                                    <div class="glass-card mt-3">
                                        <h5>Employee Comment</h5>
                                        <div class="readonly-comment">
                                            <?php echo nl2br(htmlspecialchars($appraisal['employee_comment'])); ?>
                                        </div>
                                        <small class="text-muted">
                                            Commented on <?php echo date('M d, Y H:i', strtotime($appraisal['employee_comment_date'])); ?>
                                        </small>
                                    </div>
                                <?php elseif ($appraisal['status'] === 'awaiting_employee'): ?>
                                    <div class="employee-comment-form">
                                        <h5>Awaiting Employee Comments</h5>
                                        <p class="text-muted">The employee has been notified and will provide their comments soon.</p>
                                    </div>
                                <?php endif; ?>

                                <!-- Submit Appraisal Form -->
                                <?php if ($appraisal['status'] === 'awaiting_submission' && !$is_readonly): ?>
                                    <form method="POST" action="" id="submit-appraisal-form-<?php echo $appraisal['id']; ?>" style="margin-top: 1rem;">
                                        <input type="hidden" name="action" value="submit_appraisal">
                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                        
                                        <?php if (hasAppraisalAccess($user['role'])): ?>
                                            <div class="supervisor-comment-form">
                                                <h5>Supervisor Comment</h5>
                                                <div class="form-group">
                                                    <textarea name="supervisor_comment" id="supervisor-comment-<?php echo $appraisal['id']; ?>" 
                                                              class="form-control" placeholder="Enter your comments as the supervisor..." 
                                                              required><?php echo isset($_POST['supervisor_comment']) ? htmlspecialchars($_POST['supervisor_comment']) : ''; ?></textarea>
                                                </div>
                                            </div>
                                        <?php endif; ?>
                                        
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-success">
                                                Submit Appraisal
                                            </button>
                                        </div>
                                    </form>
                                <?php endif; ?>
                            </div>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <div class="no-appraisals">
                            <h4>No active appraisals for this employee and cycle</h4>
                            <p>All quarters have been submitted or there are no drafts available.</p>
                            <?php if (hasPermission('hr_manager') || hasPermission('super_admin')): ?>
                                <a href="appraisal_management.php" class="btn btn-info mt-3">Manage Appraisals</a>
                            <?php endif; ?>
                        </div>
                    <?php endif; ?>
                <?php elseif ($selected_cycle_id && !$selected_employee_id): ?>
                    <div class="alert alert-warning">
                        Please select an employee to view their appraisals.
                    </div>
                <?php elseif (!$selected_cycle_id): ?>
                    <div class="alert alert-warning">
                        Please select an appraisal cycle to view employee appraisals.
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        function updateEmployeeSelection() {
            const employeeToken = document.getElementById('employee-select').value;
            const cycleId = document.getElementById('cycle-select').value;
            let url = 'performance_appraisal.php?';
            
            if (cycleId) {
                url += 'cycle_id=' + cycleId;
            }
            
            if (employeeToken) {
                url += (cycleId ? '&' : '') + 'employee_token=' + employeeToken;
            }
            
            window.location.href = url;
        }
        
        function updateCycleSelection() {
            const cycleId = document.getElementById('cycle-select').value;
            const employeeToken = document.getElementById('employee-select').value;
            let url = 'performance_appraisal.php?';
            
            if (cycleId) {
                url += 'cycle_id=' + cycleId;
            }
            
            if (employeeToken) {
                url += (cycleId ? '&' : '') + 'employee_token=' + employeeToken;
            }
            
            window.location.href = url;
        }
        
        // Auto-save functionality
        const forms = document.querySelectorAll('form[method="POST"]');
        
        forms.forEach(form => {
            if (form.querySelector('input[name="action"][value="save_scores"]') || 
                form.querySelector('input[name="action"][value="save_employee_comment"]')) {
                const inputs = form.querySelectorAll('input, textarea');
                
                inputs.forEach(input => {
                    if (!input.classList.contains('readonly-field')) {
                        input.addEventListener('change', function() {
                            clearTimeout(this.saveTimeout);
                            this.saveTimeout = setTimeout(() => {
                                const formData = new FormData(form);
                                
                                fetch('performance_appraisal.php', {
                                    method: 'POST',
                                    body: formData
                                }).then(response => {
                                    if (response.ok) {
                                        input.style.borderColor = 'var(--success-color)';
                                        setTimeout(() => {
                                            input.style.borderColor = '';
                                        }, 1000);
                                    }
                                }).catch(error => {
                                    console.error('Auto-save failed:', error);
                                });
                            }, 2000);
                        });
                    }
                });
            }
        });
        
        // Form validation for score inputs
        document.addEventListener('DOMContentLoaded', function() {
            const scoreInputs = document.querySelectorAll('.score-input');
            scoreInputs.forEach(input => {
                input.addEventListener('blur', function() {
                    const maxScore = parseFloat(this.getAttribute('max'));
                    const value = parseFloat(this.value);
                    
                    if (value > maxScore) {
                        this.value = maxScore;
                        alert('Score cannot exceed maximum value of ' + maxScore);
                    }
                    
                    if (value < 1) {
                        this.value = 1;
                        alert('Score cannot be less than 1');
                    }
                });
            });
        });
    </script>
</body>
</html>