<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_start();

// Start session with secure parameters FIRST
if (session_status() == PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => '',
        'secure' => true,
        'httponly' => true,
        'samesite' => 'Strict'
    ]);
    session_start();
    
    // Initialize CSRF token if not exists
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
}

// Check if user is logged in
if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token']) || !isset($_SESSION['login_identifier'])) {
    header("Location: login.php");
    exit();
}

// After successful login verification in other pages
if (!isset($_SESSION['hr_system_user_id'])) {
    $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
    $_SESSION['hr_system_username'] = $_SESSION['user_name'];
    $_SESSION['hr_system_user_role'] = $_SESSION['user_role'];
}

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php';

// Then include auth files
require_once 'auth_check.php';
require_once 'auth.php';
require_once 'header.php';
require_once 'config.php';

$conn = getConnection();

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// Check if user has permission to access this page
if (!in_array($user['role'], ['hr_manager', 'dept_head', 'section_head', 'sub_section_head', 'manager', 'managing_director', 'super_admin'])) {
    header("Location: leave_management.php");
    exit();
}

// Security function matching your login page
function logSecurityEvent($event_type, $user_id = 0, $details = '') {
    global $conn;
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
    $details = json_encode([
        'script' => $_SERVER['PHP_SELF'] ?? '',
        'referrer' => $_SERVER['HTTP_REFERER'] ?? '',
        'additional_info' => $details
    ]);

    try {
        $stmt = $conn->prepare("INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details) VALUES (?, ?, ?, ?, ?)");
        $user_id = $user_id ?: NULL;
        $stmt->bind_param("issss", $user_id, $event_type, $ip_address, $user_agent, $details);
        $stmt->execute();
    } catch (Exception $e) {
        error_log("Security logging failed: " . $e->getMessage());
    }
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

function formatDate($date) {
    if (!$date) return 'N/A';
    return date('M d, Y', strtotime($date));
}

function getStatusBadgeClass($status) {
    switch ($status) {
        case 'approved': return 'badge-success';
        case 'rejected': return 'badge-danger';
        case 'pending': return 'badge-warning';
        case 'pending_subsection_head': return 'badge-info';
        case 'pending_section_head': return 'badge-info';
        case 'pending_dept_head': return 'badge-primary';
        case 'pending_managing_director': return 'badge-secondary';
        case 'pending_hr': return 'badge-warning';
        default: return 'badge-secondary';
    }
}

function getStatusDisplayName($status) {
    switch ($status) {
        case 'approved': return 'Approved';
        case 'rejected': return 'Rejected';
        case 'pending': return 'Pending';
        case 'pending_subsection_head': return 'Pending Subsection Head Approval';
        case 'pending_section_head': return 'Pending Section Head Approval';
        case 'pending_dept_head': return 'Pending Department Head Approval';
        case 'pending_managing_director': return 'Pending Managing Director Approval';
        case 'pending_hr': return 'Pending HR Approval';
        default: return ucfirst($status);
    }
}

// ✅ FIXED: Enhanced function to ensure balance record exists before updating
function ensureLeaveBalanceExists($conn, $employeeId, $leaveTypeId) {
    // Check if balance record exists for current financial year
    $stmt = $conn->prepare("
        SELECT id FROM employee_leave_balances
        WHERE employee_id = ? AND leave_type_id = ? AND financial_year_id = (
            SELECT id FROM financial_years WHERE is_active = 1 LIMIT 1
        )
        LIMIT 1
    ");
    $stmt->bind_param("ii", $employeeId, $leaveTypeId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        return true; // Balance record exists
    }
    
    // Create balance record if it doesn't exist
    // Get current financial year
    $fyStmt = $conn->prepare("SELECT id FROM financial_years WHERE is_active = 1 LIMIT 1");
    $fyStmt->execute();
    $fyResult = $fyStmt->get_result();
    
    if ($fyResult->num_rows === 0) {
        throw new Exception("No active financial year found. Please contact HR to set up the financial year.");
    }
    
    $financialYear = $fyResult->fetch_assoc();
    $financialYearId = $financialYear['id'];
    
    // Get default allocated days for this leave type
    $ltStmt = $conn->prepare("SELECT default_days FROM leave_types WHERE id = ?");
    $ltStmt->bind_param("i", $leaveTypeId);
    $ltStmt->execute();
    $ltResult = $ltStmt->get_result();
    
    if ($ltResult->num_rows === 0) {
        throw new Exception("Leave type not found in system");
    }
    
    $leaveType = $ltResult->fetch_assoc();
    $allocatedDays = $leaveType['default_days'] ?? 0;
    
    // Create the balance record with proper initial values
    // Initially: used_days = 0, remaining_days = allocated_days, total_days = allocated_days
    $insertStmt = $conn->prepare("
        INSERT INTO employee_leave_balances 
        (employee_id, leave_type_id, financial_year_id, allocated_days, used_days, remaining_days, total_days, created_at, updated_at)
        VALUES (?, ?, ?, ?, 0, ?, ?, NOW(), NOW())
    ");
    $initialRemaining = $allocatedDays;
    $initialTotal = $allocatedDays; // allocated + remaining - used = allocated + allocated - 0
    $insertStmt->bind_param("iiiddd", $employeeId, $leaveTypeId, $financialYearId, $allocatedDays, $initialRemaining, $initialTotal);
    
    if (!$insertStmt->execute()) {
        throw new Exception("Failed to create leave balance record: " . $conn->error);
    }
    
    error_log("Created leave balance record for employee ID: $employeeId, leave type ID: $leaveTypeId");
    return true;
}

// ✅ CORRECTED: Proper leave balance update with clear differentiation
function updateLeaveBalance($conn, $employeeId, $leaveTypeId, $appliedDays, $is_claim_day = false) {
    try {
        $conn->begin_transaction();

        // ✅ Ensure balance record exists before attempting update
        ensureLeaveBalanceExists($conn, $employeeId, $leaveTypeId);

        // Fetch the current balance record
        $stmt = $conn->prepare("
            SELECT id, allocated_days, used_days, remaining_days, total_days
            FROM employee_leave_balances
            WHERE employee_id = ? AND leave_type_id = ?
            ORDER BY financial_year_id DESC
            LIMIT 1
        ");
        $stmt->bind_param("ii", $employeeId, $leaveTypeId);
        $stmt->execute();
        $result = $stmt->get_result();
        $balance = $result->fetch_assoc();

        if (!$balance) {
            throw new Exception("No leave balance record found for employee ID $employeeId and leave type ID $leaveTypeId.");
        }

        $id = $balance['id'];
        $currentAllocated = (float)$balance['allocated_days'];
        $currentUsed = (float)$balance['used_days'];
        $currentRemaining = (float)$balance['remaining_days']; // Balance brought forward (FIXED)
        $currentTotal = (float)$balance['total_days'];

        // Debug logging
        error_log("=== LEAVE BALANCE UPDATE ===");
        error_log("Employee: $employeeId, Leave Type: $leaveTypeId");
        error_log("Applied Days: $appliedDays, Is Claim Day: " . ($is_claim_day ? 'Yes' : 'No'));
        error_log("Before Update - Allocated: $currentAllocated, Used: $currentUsed, Remaining: $currentRemaining, Total: $currentTotal");

        if ($is_claim_day) {
            // ✅ CLAIM A DAY: Add to total days only
            // remaining_days (balance brought forward) remains unchanged
            $newTotal = $currentTotal + $appliedDays;
            
            $update = $conn->prepare("
                UPDATE employee_leave_balances
                SET 
                    total_days = ?,
                    updated_at = NOW()
                WHERE id = ?
            ");
            $update->bind_param("di", $newTotal, $id);
            
            error_log("Claim Day Calculation:");
            error_log("New Total: $newTotal = $currentTotal + $appliedDays");
            error_log("Remaining Days (balance brought forward) remains: $currentRemaining");
            
        } else {
            // ✅ REGULAR LEAVE: Deduct from total days only
            // remaining_days (balance brought forward) remains unchanged
            if ($currentTotal < $appliedDays) {
                throw new Exception("Insufficient leave balance. Available: $currentTotal days, Requested: $appliedDays days");
            }
            
            $newTotal = $currentTotal - $appliedDays;
            $newUsed = $currentUsed + $appliedDays;
            
            $update = $conn->prepare("
                UPDATE employee_leave_balances
                SET 
                    total_days = ?,
                    used_days = ?,
                    updated_at = NOW()
                WHERE id = ?
            ");
            $update->bind_param("ddi", $newTotal, $newUsed, $id);
            
            error_log("Regular Leave Calculation:");
            error_log("New Total: $newTotal = $currentTotal - $appliedDays");
            error_log("New Used: $newUsed = $currentUsed + $appliedDays");
            error_log("Remaining Days (balance brought forward) remains: $currentRemaining");
        }

        if (!$update->execute()) {
            throw new Exception("Failed to execute update: " . $conn->error);
        }

        if ($update->affected_rows === 0) {
            throw new Exception("Failed to update leave balance. No rows affected.");
        }

        // Fetch updated values for verification
        $final = $conn->prepare("
            SELECT allocated_days, used_days, remaining_days, total_days
            FROM employee_leave_balances
            WHERE id = ?
        ");
        $final->bind_param("i", $id);
        $final->execute();
        $updatedBalance = $final->get_result()->fetch_assoc();

        $conn->commit();

        error_log("After Update - Allocated: {$updatedBalance['allocated_days']}, Used: {$updatedBalance['used_days']}, Remaining: {$updatedBalance['remaining_days']}, Total: {$updatedBalance['total_days']}");
        error_log("=== UPDATE COMPLETE ===");

        return [
            'success' => true,
            'allocated_days' => (float)$updatedBalance['allocated_days'],
            'used_days' => (float)$updatedBalance['used_days'],
            'remaining_days' => (float)$updatedBalance['remaining_days'],
            'total_days' => (float)$updatedBalance['total_days']
        ];

    } catch (Exception $e) {
        $conn->rollback();
        error_log("Leave balance update error: " . $e->getMessage());
        return [
            'success' => false,
            'message' => $e->getMessage()
        ];
    }
}

// ✅ NEW: Function to determine which leave type to deduct from
function getTargetLeaveTypeId($conn, $applicationLeaveTypeId) {
    $stmt = $conn->prepare("SELECT id, name, deducted_from_annual FROM leave_types WHERE id = ?");
    $stmt->bind_param("i", $applicationLeaveTypeId);
    $stmt->execute();
    $leaveType = $stmt->get_result()->fetch_assoc();
    
    if (!$leaveType) {
        return $applicationLeaveTypeId; // Fallback to original type
    }
    
    // If this leave type is deducted from annual leave OR it's short leave, use annual leave (id=1)
    if ($leaveType['deducted_from_annual'] == 1 || $applicationLeaveTypeId == 7) { // Assuming 7 is short leave ID
        return 1; // Annual leave
    }
    
    return $applicationLeaveTypeId; // Use the leave type's own balance
}

// Function to recalculate balances if needed
function recalculateLeaveBalances($conn, $employeeId = null) {
    $whereClause = $employeeId ? "WHERE employee_id = ?" : "";
    $params = $employeeId ? [$employeeId] : [];
    $types = $employeeId ? "i" : "";
    
    $stmt = $conn->prepare("
        UPDATE employee_leave_balances 
        SET total_days = allocated_days + remaining_days - used_days,
            updated_at = NOW()
        $whereClause
    ");
    
    if ($employeeId) {
        $stmt->bind_param($types, ...$params);
    }
    
    return $stmt->execute();
}

// Improved Email sending function with better templates
function sendEmail($conn, $toEmail, $toName, $subject, $body) {
    require_once 'email_config.php';
    $mail = new PHPMailer(true);

    try {
        // Server settings
        $mail->isSMTP();
        $mail->Host = SMTP_HOST;
        $mail->SMTPAuth = true;
        $mail->Username = SMTP_USERNAME;
        $mail->Password = SMTP_PASSWORD;
        $mail->SMTPSecure = SMTP_ENCRYPTION;
        $mail->Port = SMTP_PORT;

        // Sender and recipient
        $mail->setFrom(EMAIL_FROM, EMAIL_FROM_NAME);
        $mail->addAddress($toEmail, $toName);

        // Content
        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body = $body;
        $mail->AltBody = strip_tags($body);

        $mail->send();
        return ['success' => true];
    } catch (Exception $e) {
        return ['success' => false, 'message' => "Email could not be sent. Mailer Error: {$mail->ErrorInfo}"];
    }
}

// Function to create professional email template
function createEmailTemplate($recipientName, $title, $message, $leaveDetails = [], $actionRequired = false) {
    $template = "
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #2c3e50; color: white; padding: 20px; text-align: center; }
            .content { background: #f9f9f9; padding: 20px; border-radius: 5px; }
            .footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }
            .leave-details { background: white; padding: 15px; border-radius: 5px; margin: 15px 0; }
            .action-button { background: #3498db; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; }
            .signature { margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; }
        </style>
    </head>
    <body>
        <div class='container'>
            <div class='header'>
                <h2>HR Management System</h2>
            </div>
            <div class='content'>
                <p>Dear $recipientName,</p>
                
                $message
                
                " . (!empty($leaveDetails) ? "
                <div class='leave-details'>
                    <h3>Leave Application Details:</h3>
                    <p><strong>Employee:</strong> {$leaveDetails['first_name']} {$leaveDetails['last_name']}</p>
                    <p><strong>Leave Type:</strong> {$leaveDetails['leave_type']}</p>
                    <p><strong>Start Date:</strong> {$leaveDetails['start_date']}</p>
                    <p><strong>End Date:</strong> {$leaveDetails['end_date']}</p>
                    <p><strong>Duration:</strong> {$leaveDetails['days_requested']} day(s)</p>
                    " . (!empty($leaveDetails['reason']) ? "<p><strong>Reason:</strong> {$leaveDetails['reason']}</p>" : "") . "
                </div>
                " : "") . "
                
                " . ($actionRequired ? "
                <p style='text-align: center; margin: 20px 0;'>
                    <a href='" . (isset($leaveDetails['system_url']) ? $leaveDetails['system_url'] : 'http://your-hr-system.com') . "' class='action-button'>
                        Review Leave Application
                    </a>
                </p>
                <p><em>Please log in to the HR Management System to review and take action on this request.</em></p>
                " : "") . "
                
                <div class='signature'>
                    <p>Best regards,<br>
                    <strong>HR Management System</strong><br>
                    Human Resources Department</p>
                </div>
            </div>
            <div class='footer'>
                <p>This is an automated message. Please do not reply to this email.</p>
            </div>
        </div>
    </body>
    </html>
    ";
    
    return $template;
}

// Improved email functions for different scenarios

// Email for subsection head approval notification to section head
function sendSubsectionApprovalEmail($conn, $sectionHead, $employee, $leaveId, $application) {
    $subject = "Leave Application Requires Your Approval - Pending Section Head Review";
    
    $message = "
    <p>A leave application has been approved by the subsection head and is now awaiting your review as the Section Head.</p>
    <p>The application requires your attention to proceed to the next approval stage.</p>
    ";
    
    $leaveDetails = [
        'employee_name' => $employee['first_name'] . ' ' . $employee['last_name'],
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested'],
        'system_url' => 'http://your-hr-system.com/manage.php'
    ];
    
    $body = createEmailTemplate($sectionHead['name'], $subject, $message, $leaveDetails, true);
    
    return sendEmail($conn, $sectionHead['email'], $sectionHead['name'], $subject, $body);
}

// Email for section head approval notification to department head
function sendSectionApprovalEmail($conn, $deptHead, $employee, $leaveId, $application) {
    $subject = "Leave Application Requires Department Head Approval";
    
    $message = "
    <p>A leave application has been approved by the section head and is now pending your review as the Department Head.</p>
    <p>Your approval is required for this application to proceed further in the approval process.</p>
    ";
    
    $leaveDetails = [
        'employee_name' => $employee['first_name'] . ' ' . $employee['last_name'],
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested'],
        'system_url' => 'http://your-hr-system.com/manage.php'
    ];
    
    $body = createEmailTemplate($deptHead['name'], $subject, $message, $leaveDetails, true);
    
    return sendEmail($conn, $deptHead['email'], $deptHead['name'], $subject, $body);
}

// Email for department head approval notification to managing director (if needed)
function sendDeptApprovalEmail($conn, $managingDirector, $employee, $leaveId, $application) {
    $subject = "Leave Application Requires Managing Director Approval";
    
    $message = "
    <p>A leave application has been approved by the department head and requires your final approval as the Managing Director.</p>
    <p>This application is awaiting your decision to complete the approval process.</p>
    ";
    
    $leaveDetails = [
        'employee_name' => trim(($employee['first_name'] ?? '') . ' ' . ($employee['last_name'] ?? '')),
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested'],
        'system_url' => 'http://your-hr-system.com/manage.php'
    ];
    
    $body = createEmailTemplate($managingDirector['name'], $subject, $message, $leaveDetails, true);
    
    return sendEmail($conn, $managingDirector['email'], $managingDirector['name'], $subject, $body);
}

// Email for HR manager notification
function sendHRNotificationEmail($conn, $hrManager, $employee, $leaveId, $application) {
    $subject = "Leave Application Fully Approved - HR Notification";
    
    $message = "
    <p>A leave application has been fully approved through the complete approval workflow.</p>
    <p>This is for your information and records as the HR Manager.</p>
    ";
    
    $leaveDetails = [
        'employee_name' => trim(($employee['first_name'] ?? '') . ' ' . ($employee['last_name'] ?? '')),
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested']
    ];
    
    $body = createEmailTemplate($hrManager['name'], $subject, $message, $leaveDetails, false);
    
    return sendEmail($conn, $hrManager['email'], $hrManager['name'], $subject, $body);
}

// Email for employee status update (approved)
function sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application, $approverLevel = "") {
    $subject = "Your Leave Application Has Been Approved";
    
    if (!empty($approverLevel)) {
        $message = "
        <p>We are pleased to inform you that your leave application has been approved by the $approverLevel.</p>
        <p>Your request is progressing through the approval workflow.</p>
        ";
    } else {
        $message = "
        <p>We are pleased to inform you that your leave application has been fully approved.</p>
        <p>Your request has been processed successfully and your leave has been officially approved.</p>
        ";
    }
    
    $leaveDetails = [
        'employee_name' => trim(($employee['first_name'] ?? '') . ' ' . ($employee['last_name'] ?? '')),
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested']
    ];
    
    $body = createEmailTemplate($employee['name'], $subject, $message, $leaveDetails, false);
    
    return sendEmail($conn, $employee['email'], $employee['name'], $subject, $body);
}

// Email for employee status update (rejected)
function sendEmployeeRejectionEmail($conn, $employee, $leaveId, $application) {
    $subject = "Update on Your Leave Application";
    
    $message = "
    <p>Regarding your recent leave application, we regret to inform you that it has not been approved.</p>
    <p>For more detailed information about this decision, please contact the Human Resources department.</p>
    <p>We appreciate your understanding and encourage you to reach out if you have any questions or need to discuss alternative arrangements.</p>
    ";
    
    $leaveDetails = [
        'employee_name' => trim(($employee['first_name'] ?? '') . ' ' . ($employee['last_name'] ?? '')),
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested']
    ];
    
    $body = createEmailTemplate($employee['name'], $subject, $message, $leaveDetails, false);
    
    return sendEmail($conn, $employee['email'], $employee['name'], $subject, $body);
}

// Email for pending approval notifications
function sendPendingApprovalEmail($conn, $approver, $employee, $leaveId, $application, $approverRole) {
    $roleTitles = [
        'sub_section_head' => 'Subsection Head',
        'section_head' => 'Section Head',
        'dept_head' => 'Department Head',
        'managing_director' => 'Managing Director',
        'hr_manager' => 'HR Manager'
    ];
    
    $roleTitle = $roleTitles[$approverRole] ?? $approverRole;
    
    $subject = "Action Required: Leave Application Awaiting Your Approval";
    
    $message = "
    <p>A new leave application requires your attention and approval as the $roleTitle.</p>
    <p>Please review the application details below and take appropriate action in the HR Management System.</p>
    <p><strong>Your timely response is appreciated to ensure efficient processing of this leave request.</strong></p>
    ";
    
    $leaveDetails = [
        'employee_name' => trim(($employee['first_name'] ?? '') . ' ' . ($employee['last_name'] ?? '')),
        'leave_type' => $application['leave_type_name'],
        'start_date' => formatDate($application['start_date']),
        'end_date' => formatDate($application['end_date']),
        'days_requested' => $application['days_requested'],
        'system_url' => 'http://your-hr-system.com/manage.php'
    ];
    
    $body = createEmailTemplate($approver['name'], $subject, $message, $leaveDetails, true);
    
    return sendEmail($conn, $approver['email'], $approver['name'], $subject, $body);
}

// Function to fetch email by employee ID
function getEmailByEmployeeId($conn, $employeeId) {
    $query = "SELECT u.email, CONCAT(u.first_name, ' ', u.last_name) AS full_name 
              FROM users u 
              JOIN employees e ON u.employee_id = e.employee_id 
              WHERE e.id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $employeeId);
    $stmt->execute();
    $result = $stmt->get_result()->fetch_assoc();
    return $result ? ['email' => $result['email'], 'name' => $result['full_name']] : null;
}

// Function to fetch approver email by role
function getApproverEmailByRole($conn, $role, $departmentId = null, $sectionId = null) {
    $query = "SELECT u.email, CONCAT(u.first_name, ' ', u.last_name) AS full_name 
              FROM users u 
              JOIN employees e ON u.employee_id = e.employee_id 
              WHERE u.role = ?";
    $params = [$role];
    $types = "s";

    if ($role === 'dept_head' && $departmentId) {
        $query .= " AND e.department_id = ?";
        $params[] = $departmentId;
        $types .= "i";
    } elseif ($role === 'section_head' && $sectionId) {
        $query .= " AND e.section_id = ?";
        $params[] = $sectionId;
        $types .= "i";
    } elseif ($role === 'sub_section_head' && $sectionId) {
        $query .= " AND e.section_id = ?";
        $params[] = $sectionId;
        $types .= "i";
    }

    $stmt = $conn->prepare($query);
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $result = $stmt->get_result()->fetch_assoc();
    return $result ? ['email' => $result['email'], 'name' => $result['full_name']] : null;
}

// Get user's employee record
$userEmployeeQuery = "SELECT e.* FROM employees e 
                      LEFT JOIN users u ON u.employee_id = e.employee_id 
                      WHERE u.id = ?";
$stmt = $conn->prepare($userEmployeeQuery);
$stmt->bind_param("i", $user['id']);
$stmt->execute();
$userEmployee = $stmt->get_result()->fetch_assoc();

// Initialize variables
$success = '';
$error = '';
$pendingLeaves = [];
$approvedLeaves = [];
$rejectedLeaves = [];

// CSRF verification function
function verifyCSRFToken() {
    if (!isset($_GET['csrf_token']) || $_GET['csrf_token'] !== ($_SESSION['csrf_token'] ?? '')) {
        $_SESSION['flash_message'] = "Security token invalid. Please try again.";
        $_SESSION['flash_type'] = "danger";
        logSecurityEvent('csrf_validation_failed', $_SESSION['user_id'] ?? 0, 'manage_leave_action');
        header("Location: manage.php");
        exit();
    }
}

// Handle form submissions and GET actions
if ($_SERVER['REQUEST_METHOD'] === 'POST' || isset($_GET['action'])) {
    // Update session activity for any action
    $_SESSION['last_activity'] = time();
    
    // Handle approval/rejection actions
    if (isset($_GET['action'])) {
        $action = $_GET['action'];
        $leaveId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
        
        // Verify CSRF token for all actions
        verifyCSRFToken();

        // Log the action attempt
        logSecurityEvent('leave_management_action', $_SESSION['user_id'] ?? 0, "action: $action, leave_id: $leaveId");

        // SUBSECTION HEAD APPROVAL
        if ($action === 'subsection_head_approve' && hasPermission('sub_section_head')) {
            try {
                $conn->begin_transaction();

                // Get leave application
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, e.employee_id, e.department_id, e.section_id, e.subsection_id, e.first_name, e.last_name, lt.name as leave_type_name
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if ($application['leave_type_id'] == 9) {
                    throw new Exception("Claim a day leaves can only be approved by the HR manager.");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();

                // Check if application is in correct status and approver has authority
                if ($userEmpRecord && $application && $application['status'] === 'pending_subsection_head') {
                    // Update leave application status to pending_section_head
                    $stmt = $conn->prepare("UPDATE leave_applications SET 
                        status = 'pending_section_head', 
                        subsection_head_approval = 'approved', 
                        subsection_head_approved_by = ?, 
                        subsection_head_approved_at = NOW() 
                        WHERE id = ?");
                    $stmt->bind_param("ii", $userEmpRecord['id'], $leaveId);
                    $stmt->execute();

                    // Fetch employee and section head emails
                    $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);
                    $sectionHead = getApproverEmailByRole($conn, 'section_head', $application['department_id'], $application['section_id']);

                    // Notify employee using improved email template
                    if ($employee) {
                        sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application, "subsection head");
                    }

                    // Notify section head using improved email template
                    if ($sectionHead) {
                        sendPendingApprovalEmail($conn, $sectionHead, $employee, $leaveId, $application, 'section_head');
                    }

                    $conn->commit();
                    $_SESSION['flash_message'] = "Leave application approved by subsection head. Sent to section head.";
                    $_SESSION['flash_type'] = "success";
                    logSecurityEvent('leave_approved_subsection_head', $_SESSION['user_id'], "leave_id: $leaveId");
                } else {
                    $conn->rollback();
                    $_SESSION['flash_message'] = "You are not authorized to approve this leave application.";
                    $_SESSION['flash_type'] = "danger";
                    logSecurityEvent('leave_approval_unauthorized', $_SESSION['user_id'], "leave_id: $leaveId");
                }
            } catch (Exception $e) {
                $conn->rollback();
                $_SESSION['flash_message'] = "Database error: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_approval_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }

        // SECTION HEAD APPROVAL
        if ($action === 'section_head_approve' && hasPermission('section_head')) {
            try {
                $conn->begin_transaction();

                // Get leave application
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, e.employee_id, e.department_id, e.first_name, e.last_name, lt.name as leave_type_name
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if ($application['leave_type_id'] == 9) {
                    throw new Exception("Claim a day leaves can only be approved by the HR manager.");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();

                // Check if application is in correct status and approver has authority
                if ($userEmpRecord && $application && $application['status'] === 'pending_section_head') {
                    // Update leave application status
                    $stmt = $conn->prepare("UPDATE leave_applications SET 
                        status = 'pending_dept_head', 
                        section_head_approval = 'approved', 
                        section_head_approved_by = ?, 
                        section_head_approved_at = NOW() 
                        WHERE id = ?");
                    $stmt->bind_param("ii", $userEmpRecord['id'], $leaveId);
                    $stmt->execute();

                    // Fetch employee and department head emails
                    $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);
                    $deptHead = getApproverEmailByRole($conn, 'dept_head', $application['department_id']);

                    // Notify employee using improved email template
                    if ($employee) {
                        sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application, "section head");
                    }

                    // Notify department head using improved email template
                    if ($deptHead) {
                        sendPendingApprovalEmail($conn, $deptHead, $employee, $leaveId, $application, 'dept_head');
                    }

                    $conn->commit();
                    $_SESSION['flash_message'] = "Leave application approved by section head. Sent to department head.";
                    $_SESSION['flash_type'] = "success";
                    logSecurityEvent('leave_approved_section_head', $_SESSION['user_id'], "leave_id: $leaveId");
                } else {
                    $conn->rollback();
                    $_SESSION['flash_message'] = "You are not authorized to approve this leave application.";
                    $_SESSION['flash_type'] = "danger";
                    logSecurityEvent('leave_approval_unauthorized', $_SESSION['user_id'], "leave_id: $leaveId");
                }
            } catch (Exception $e) {
                $conn->rollback();
                $_SESSION['flash_message'] = "Database error: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_approval_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }

        // DEPARTMENT HEAD APPROVAL - ✅ CORRECTED VERSION
        elseif ($action === 'dept_head_approve' && hasPermission('dept_head')) {
            try {
                $conn->begin_transaction();

                // Get leave application with internal employee ID
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, e.employee_id, e.department_id, e.first_name, e.last_name, lt.name as leave_type_name, lt.id as leave_type_id
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if (!$application) {
                    throw new Exception("Leave application not found");
                }

                if ($application['leave_type_id'] == 9) {
                    throw new Exception("Claim a day leaves can only be approved by the HR manager.");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();

                // Check if application is in correct status (only pending_dept_head now)
                if ($userEmpRecord && $application && $application['status'] === 'pending_dept_head') {
                    // Check if managing director approval is required
                    $newStatus = 'approved';
                    $requiresMDApproval = false;
                    if ($application['leave_type_id'] == 8) { // Example: Leave of absence requires MD approval
                        $newStatus = 'pending_managing_director';
                        $requiresMDApproval = true;
                    }

                    // Update the leave application status
                    $stmt = $conn->prepare("UPDATE leave_applications SET 
                        status = ?, 
                        dept_head_approval = 'approved', 
                        dept_head_approved_by = ?, 
                        dept_head_approved_at = NOW() 
                        WHERE id = ?");
                    $stmt->bind_param("sii", $newStatus, $userEmpRecord['id'], $leaveId);
                    $stmt->execute();

                    // Fetch employee and managing director emails
                    $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);
                    $hrManager = getApproverEmailByRole($conn, 'hr_manager');
                    $managingDirector = $requiresMDApproval ? getApproverEmailByRole($conn, 'managing_director') : null;

                    // Notify employee using improved email template
                    if ($employee) {
                        if ($requiresMDApproval) {
                            sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application, "department head");
                        } else {
                            sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application);
                        }
                    }

                    // Notify managing director if required using improved email template
                    if ($requiresMDApproval && $managingDirector) {
                        sendPendingApprovalEmail($conn, $managingDirector, $employee, $leaveId, $application, 'managing_director');
                    }

                    // Update leave balance if fully approved
                    $message = "Leave application approved successfully.";
                    if (!$requiresMDApproval) {
                        // ✅ CORRECTED: Determine target leave type and whether it's claim day
                        $target_type_id = getTargetLeaveTypeId($conn, $application['leave_type_id']);
                        $is_claim_day = ($application['leave_type_id'] == 9); // Check if it's claim a day
                        $update_needed = true;

                        if ($application['leave_type_id'] == 8) { // Leave of absence, no deduction
                            $update_needed = false;
                        }

                        if ($update_needed) {
                            // ✅ CORRECTED: Use the corrected updateLeaveBalance function
                            $balanceResult = updateLeaveBalance($conn, $application['emp_internal_id'], $target_type_id, $application['days_requested'], $is_claim_day);

                            if (!$balanceResult['success']) {
                                // Log the error but don't fail the approval
                                error_log("Balance update failed for employee {$application['emp_internal_id']}: " . $balanceResult['message']);
                                $message .= " Warning: Leave balance could not be updated - " . $balanceResult['message'];
                            } else {
                                // Check if balance goes negative
                                if (is_numeric($balanceResult['total_days']) && $balanceResult['total_days'] < 0) {
                                    $message .= " Note: Employee has exceeded their allocated leave days (Remaining: " . $balanceResult['total_days'] . ").";
                                }
                            }
                        } else {
                            $message = "Leave application approved successfully. No balance deduction required.";
                        }

                        // Notify HR manager for final approval using improved email template
                        if ($hrManager) {
                            sendHRNotificationEmail($conn, $hrManager, $employee, $leaveId, $application);
                        }
                    }

                    $conn->commit();
                    $_SESSION['flash_message'] = $message;
                    $_SESSION['flash_type'] = "success";
                    logSecurityEvent('leave_approved_dept_head', $_SESSION['user_id'], "leave_id: $leaveId");
                } else {
                    $conn->rollback();
                    $_SESSION['flash_message'] = "You are not authorized to approve this leave application or it is not in the correct status.";
                    $_SESSION['flash_type'] = "danger";
                    logSecurityEvent('leave_approval_unauthorized', $_SESSION['user_id'], "leave_id: $leaveId");
                }
            } catch (Exception $e) {
                $conn->rollback();
                $_SESSION['flash_message'] = "Database error: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_approval_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }

        // MANAGING DIRECTOR APPROVAL - ✅ CORRECTED VERSION
        elseif ($action === 'managing_director_approve' && hasPermission('managing_director')) {
            try {
                $conn->begin_transaction();

                // Get the leave application details
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, e.employee_id, e.first_name, e.last_name, lt.name as leave_type_name, lt.id as leave_type_id
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if (!$application) {
                    throw new Exception("Leave application not found");
                }

                if ($application['leave_type_id'] == 9) {
                    throw new Exception("Claim a day leaves can only be approved by the HR manager.");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();

                // Update the leave application status
                $stmt = $conn->prepare("UPDATE leave_applications SET 
                    status = 'approved', 
                    managing_director_approved_by = ?, 
                    managing_director_approved_at = NOW() 
                    WHERE id = ?");
                $stmt->bind_param("ii", $userEmpRecord['id'], $leaveId);
                $stmt->execute();

                // Fetch employee and HR manager emails
                $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);
                $hrManager = getApproverEmailByRole($conn, 'hr_manager');

                // ✅ CORRECTED: Determine target leave type and whether it's claim day
                $target_type_id = getTargetLeaveTypeId($conn, $application['leave_type_id']);
                $is_claim_day = ($application['leave_type_id'] == 9); // Check if it's claim a day
                $update_needed = true;

                if ($application['leave_type_id'] == 8) { // Leave of absence, no deduction
                    $update_needed = false;
                }

                $message = "Leave approved successfully.";
                if ($update_needed) {
                    // ✅ CORRECTED: Use the corrected updateLeaveBalance function
                    $balanceResult = updateLeaveBalance($conn, $application['emp_internal_id'], $target_type_id, $application['days_requested'], $is_claim_day);

                    if (!$balanceResult['success']) {
                        error_log("Balance update failed: " . $balanceResult['message']);
                        $message .= " Warning: " . $balanceResult['message'];
                    } else {
                        // Check if balance goes negative
                        if (is_numeric($balanceResult['total_days']) && $balanceResult['total_days'] < 0) {
                            $message .= " Note: Employee has exceeded their allocated leave days (Remaining: " . $balanceResult['total_days'] . ").";
                        }
                    }
                } else {
                    $message = "Leave approved successfully. No balance deduction required.";
                }

                // Notify employee using improved email template
                if ($employee) {
                    sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application);
                }

                // Notify HR manager using improved email template
                if ($hrManager) {
                    sendHRNotificationEmail($conn, $hrManager, $employee, $leaveId, $application);
                }

                $conn->commit();
                $_SESSION['flash_message'] = $message;
                $_SESSION['flash_type'] = "success";
                logSecurityEvent('leave_approved_managing_director', $_SESSION['user_id'], "leave_id: $leaveId");
            } catch (Exception $e) {
                $conn->rollback();
                $_SESSION['flash_message'] = "Error approving leave: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_approval_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }

        // HR MANAGER APPROVAL - ✅ CORRECTED VERSION
        elseif ($action === 'hr_approve' && hasPermission('hr_manager')) {
            try {
                $conn->begin_transaction();

                // Get the leave application details
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, lt.name as leave_type_name, lt.id as leave_type_id
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if (!$application) {
                    throw new Exception("Leave application not found");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();
                
                // Update the leave application status
                $stmt = $conn->prepare("UPDATE leave_applications SET 
                    status = 'approved', 
                    hr_approved_by = ?, 
                    hr_approved_at = NOW() 
                    WHERE id = ?");
                $stmt->bind_param("ii", $userEmpRecord['id'], $leaveId);
                $stmt->execute();

                // Fetch employee email
                $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);

                // ✅ CORRECTED: Determine target leave type and whether it's claim day
                $target_type_id = getTargetLeaveTypeId($conn, $application['leave_type_id']);
                $is_claim_day = ($application['leave_type_id'] == 9); // Check if it's claim a day
                $update_needed = true;

                if ($application['leave_type_id'] == 8) { // Leave of absence, no deduction
                    $update_needed = false;
                }

                $message = "Leave approved successfully by HR.";
                if ($update_needed) {
                    // ✅ CORRECTED: Use the corrected updateLeaveBalance function
                    $balanceResult = updateLeaveBalance($conn, $application['emp_internal_id'], $target_type_id, $application['days_requested'], $is_claim_day);

                    if (!$balanceResult['success']) {
                        error_log("Balance update failed: " . $balanceResult['message']);
                        $message .= " Warning: " . $balanceResult['message'];
                    } else {
                        // Check if balance goes negative
                        if (is_numeric($balanceResult['total_days']) && $balanceResult['total_days'] < 0) {
                            $message .= " Note: Employee has exceeded their allocated leave days (Remaining: " . $balanceResult['total_days'] . ").";
                        }
                    }
                } else {
                    $message = "Leave approved successfully by HR. No balance deduction required.";
                }

                // Notify employee (even if it's themselves) using improved email template
                if ($employee) {
                    sendEmployeeApprovalEmail($conn, $employee, $leaveId, $application);
                }

                $conn->commit();
                $_SESSION['flash_message'] = $message;
                $_SESSION['flash_type'] = "success";
                logSecurityEvent('leave_approved_hr', $_SESSION['user_id'], "leave_id: $leaveId");
            } catch (Exception $e) {
                $conn->rollback();
                $_SESSION['flash_message'] = "Error approving leave: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_approval_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }

        // REJECTION HANDLER - MODIFIED TO ALLOW HR SELF-REJECTION
        elseif (($action === 'reject_leave') && 
               (hasPermission('section_head') || hasPermission('dept_head') || 
                hasPermission('managing_director') || hasPermission('hr_manager') || hasPermission('sub_section_head'))) {
            try {
                // Get the leave application details first
                $stmt = $conn->prepare("SELECT la.*, e.id as emp_internal_id, lt.name as leave_type_name
                                        FROM leave_applications la 
                                        JOIN employees e ON la.employee_id = e.id 
                                        JOIN leave_types lt ON la.leave_type_id = lt.id
                                        WHERE la.id = ?");
                $stmt->bind_param("i", $leaveId);
                $stmt->execute();
                $application = $stmt->get_result()->fetch_assoc();

                if (!$application) {
                    throw new Exception("Leave application not found");
                }

                // Get approver employee record
                $userEmpQuery = "SELECT id FROM employees WHERE employee_id = (SELECT employee_id FROM users WHERE id = ?)";
                $stmt = $conn->prepare($userEmpQuery);
                $stmt->bind_param("s", $user['id']);
                $stmt->execute();
                $userEmpRecord = $stmt->get_result()->fetch_assoc();

                // ✅ MODIFIED: REMOVED SELF-REJECTION RESTRICTION FOR HR MANAGER
                // HR managers can now reject their own leave applications

                // Set rejection fields based on who is rejecting
                $rejectedByField = '';
                $timestampField = '';
                if (hasPermission('hr_manager')) {
                    $rejectedByField = 'hr_approved_by';
                    $timestampField = 'hr_approved_at';
                } elseif (hasPermission('managing_director')) {
                    $rejectedByField = 'managing_director_approved_by';
                    $timestampField = 'managing_director_approved_at';
                } elseif (hasPermission('dept_head')) {
                    $rejectedByField = 'dept_head_approved_by';
                    $timestampField = 'dept_head_approved_at';
                } elseif (hasPermission('section_head')) {
                    $rejectedByField = 'section_head_approved_by';
                    $timestampField = 'section_head_approved_at';
                } elseif (hasPermission('sub_section_head')) {
                    $rejectedByField = 'subsection_head_approved_by';
                    $timestampField = 'subsection_head_approved_at';
                }

                $stmt = $conn->prepare("UPDATE leave_applications SET 
                    status = 'rejected', 
                    $rejectedByField = ?, 
                    $timestampField = NOW() 
                    WHERE id = ?");
                $stmt->bind_param("ii", $userEmpRecord['id'], $leaveId);
                $stmt->execute();

                // Fetch employee email
                $employee = getEmailByEmployeeId($conn, $application['emp_internal_id']);

                // Notify employee (even if it's themselves) using improved email template
                if ($employee) {
                    sendEmployeeRejectionEmail($conn, $employee, $leaveId, $application);
                }

                $_SESSION['flash_message'] = "Leave rejected successfully.";
                $_SESSION['flash_type'] = "success";
                logSecurityEvent('leave_rejected', $_SESSION['user_id'], "leave_id: $leaveId");
            } catch (Exception $e) {
                $_SESSION['flash_message'] = "Error rejecting leave: " . $e->getMessage();
                $_SESSION['flash_type'] = "danger";
                logSecurityEvent('leave_rejection_error', $_SESSION['user_id'], "leave_id: $leaveId, error: " . $e->getMessage());
            }
            header("Location: manage.php");
            exit();
        }
    }
}

// Fetch data for displays
try {
    // Role-specific filtering for pending leaves
    if ($user['role'] === 'section_head' && $userEmployee) {
        $sectionId = (int)$userEmployee['section_id'];

        $pendingQuery = "SELECT la.*, e.employee_id as emp_id, e.first_name, e.last_name,
                         lt.name as leave_type_name, d.name as department_name, s.name as section_name
                         FROM leave_applications la
                         JOIN employees e ON la.employee_id = e.id
                         JOIN leave_types lt ON la.leave_type_id = lt.id
                         LEFT JOIN departments d ON e.department_id = d.id
                         LEFT JOIN sections s ON e.section_id = s.id
                         WHERE la.status = 'pending_section_head'
                         AND e.section_id = ?
                         ORDER BY la.applied_at DESC";
        $stmt = $conn->prepare($pendingQuery);
        $stmt->bind_param("i", $sectionId);
        $stmt->execute();
        $pendingResult = $stmt->get_result();
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    } 
    elseif ($user['role'] === 'sub_section_head' && $userEmployee) { 
        $subsectionId = (int)$userEmployee['subsection_id'];

        $pendingQuery = "SELECT la.*, e.employee_id, e.first_name, e.last_name,
                                lt.name AS leave_type_name,
                                d.name AS department_name,
                                s.name AS section_name,
                                sb.name AS subsection_name
                         FROM leave_applications la
                         JOIN employees e ON la.employee_id = e.id
                         JOIN leave_types lt ON la.leave_type_id = lt.id
                         LEFT JOIN departments d ON e.department_id = d.id
                         LEFT JOIN sections s ON e.section_id = s.id
                         LEFT JOIN subsections sb ON e.subsection_id = sb.id
                         WHERE la.status = 'pending_subsection_head'
                           AND e.subsection_id = ?
                         ORDER BY la.applied_at DESC";

        $stmt = $conn->prepare($pendingQuery);
        $stmt->bind_param("i", $subsectionId);
        $stmt->execute();
        $pendingResult = $stmt->get_result();
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    }
    elseif ($user['role'] === 'dept_head' && $userEmployee) {
        $deptId = (int)$userEmployee['department_id'];

        $pendingQuery = "SELECT la.*, e.employee_id, e.first_name, e.last_name,
                        lt.name as leave_type_name, d.name as department_name, s.name as section_name
                        FROM leave_applications la
                        JOIN employees e ON la.employee_id = e.id
                        JOIN leave_types lt ON la.leave_type_id = lt.id
                        LEFT JOIN departments d ON e.department_id = d.id
                        LEFT JOIN sections s ON e.section_id = s.id
                        WHERE la.status = 'pending_dept_head'
                        AND e.department_id = ?
                        ORDER BY la.applied_at DESC";
        $stmt = $conn->prepare($pendingQuery);
        $stmt->bind_param("i", $deptId);
        $stmt->execute();
        $pendingResult = $stmt->get_result();
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    }
    elseif ($user['role'] === 'manager' && $userEmployee) {
        $pendingQuery = "SELECT la.*, e.employee_id, e.first_name, e.last_name,
                        lt.name as leave_type_name, d.name as department_name, s.name as section_name
                        FROM leave_applications la
                        JOIN employees e ON la.employee_id = e.id
                        JOIN leave_types lt ON la.leave_type_id = lt.id
                        LEFT JOIN departments d ON e.department_id = d.id
                        LEFT JOIN sections s ON e.section_id = s.id
                        WHERE la.status IN ('pending_section_head', 'pending_managing_director')
                        AND e.id = ?
                        ORDER BY la.applied_at DESC";
        $stmt = $conn->prepare($pendingQuery);
        $stmt->bind_param("i", $userEmployee['id']);
        $stmt->execute();
        $pendingResult = $stmt->get_result();
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    }
    elseif ($user['role'] === 'managing_director') {
        $pendingQuery = "SELECT la.*, e.employee_id, e.first_name, e.last_name,
                        lt.name as leave_type_name, d.name as department_name, s.name as section_name
                        FROM leave_applications la
                        JOIN employees e ON la.employee_id = e.id
                        JOIN leave_types lt ON la.leave_type_id = lt.id
                        LEFT JOIN departments d ON e.department_id = d.id
                        LEFT JOIN sections s ON e.section_id = s.id
                        WHERE la.status = 'pending_managing_director'
                        ORDER BY la.applied_at DESC";
        $pendingResult = $conn->query($pendingQuery);
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    }
    elseif ($user['role'] === 'hr_manager') {
        // ✅ MODIFIED: HR can now see their own pending applications
        $pendingQuery = "SELECT la.*, e.employee_id, e.first_name, e.last_name,
                        lt.name as leave_type_name, d.name as department_name, s.name as section_name
                        FROM leave_applications la
                        JOIN employees e ON la.employee_id = e.id
                        JOIN leave_types lt ON la.leave_type_id = lt.id
                        LEFT JOIN departments d ON e.department_id = d.id
                        LEFT JOIN sections s ON e.section_id = s.id
                        WHERE la.status IN ('pending_subsection_head', 'pending_section_head', 'pending_dept_head', 'pending_managing_director', 'pending_bod_chair', 'pending_hr')
                        ORDER BY la.applied_at DESC";
        $pendingResult = $conn->query($pendingQuery);
        $pendingLeaves = $pendingResult->fetch_all(MYSQLI_ASSOC);
    }

    // Fetch approved leaves for display
    $approvedQuery = "
    SELECT 
        la.*, 
        e.employee_id, 
        e.first_name, 
        e.last_name,
        lt.name as leave_type_name,
        COALESCE(
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.hr_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.managing_director_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.dept_head_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.section_head_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.subsection_head_approved_by LIMIT 1),
            'System'
        ) as approver_name,
        COALESCE(
            la.hr_approved_at,
            la.managing_director_approved_at,
            la.dept_head_approved_at,
            la.section_head_approved_at,
            la.subsection_head_approved_at
        ) as approval_date
    FROM leave_applications la
    JOIN employees e ON la.employee_id = e.id
    JOIN leave_types lt ON la.leave_type_id = lt.id
    WHERE la.status = 'approved'
    ORDER BY approval_date DESC
    LIMIT 10
    ";
    $approvedResult = $conn->query($approvedQuery);
    $approvedLeaves = $approvedResult->fetch_all(MYSQLI_ASSOC);

    // Fetch rejected leaves for display
    $rejectedQuery = "
    SELECT 
        la.*, 
        e.employee_id, 
        e.first_name, 
        e.last_name,
        lt.name as leave_type_name,
        COALESCE(
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.hr_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.managing_director_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.dept_head_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.section_head_approved_by LIMIT 1),
            (SELECT CONCAT(u.first_name, ' ', u.last_name) 
             FROM users u 
             JOIN employees emp ON u.employee_id = emp.employee_id 
             WHERE emp.id = la.subsection_head_approved_by LIMIT 1),
            'System'
        ) as approver_name,
        COALESCE(
            la.hr_approved_at,
            la.managing_director_approved_at,
            la.dept_head_approved_at,
            la.section_head_approved_at,
            la.subsection_head_approved_at
        ) as rejection_date
    FROM leave_applications la
    JOIN employees e ON la.employee_id = e.id
    JOIN leave_types lt ON la.leave_type_id = lt.id
    WHERE la.status = 'rejected'
    ORDER BY rejection_date DESC
    LIMIT 10
    ";
    $rejectedResult = $conn->query($rejectedQuery);
    $rejectedLeaves = $rejectedResult->fetch_all(MYSQLI_ASSOC);
} catch (Exception $e) {
    $error = "Error fetching data: " . $e->getMessage();
    logSecurityEvent('data_fetch_error', $_SESSION['user_id'], "manage.php: " . $e->getMessage());
}

include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Leave - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .session-update-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #d4edda;
            color: #155724;
            padding: 10px 15px;
            border-radius: 5px;
            border: 1px solid #c3e6cb;
            z-index: 10000;
            display: none;
        }
    </style>
</head>
<body>
   <div class="container">
       
        <!-- Main Content Area -->
        <div class="main-content">
            
            <!-- Content -->
            <div class="content">
                <?php $flash = getFlashMessage(); if ($flash): ?>
                    <div class="alert alert-<?php echo $flash['type']; ?>">
                        <?php echo htmlspecialchars($flash['message']); ?>
                    </div>
                <?php endif; ?>
                
                <?php if ($success): ?>
                    <div class="alert alert-success">
                        <?php echo $success; ?>
                    </div>
                <?php endif; ?>

                <?php if ($error): ?>
                    <div class="alert alert-danger">
                        <?php echo htmlspecialchars($error); ?>
                    </div>
                <?php endif; ?>

                <div class="leave-tabs">
                    <a href="leave_management.php" class="leave-tab">Apply Leave</a>
                    <?php if (in_array($user['role'], ['hr_manager', 'dept_head', 'section_head', 'sub_section_head', 'manager', 'managing_director','super_admin'])): ?>
                    <a href="manage.php" class="leave-tab active">Manage Leave</a>
                    <?php endif; ?>
                    <?php if(in_array($user['role'], ['hr_manager', 'super_admin', 'manager','managing_director'])): ?>
                    <a href="history.php" class="leave-tab">Leave History</a>
                    <a href="holidays.php" class="leave-tab">Holidays</a>
                    <?php endif; ?>
                    <a href="profile.php" class="leave-tab">My Leave Profile</a>
                </div>
                <!-- Manage Leave Tab Content -->
                <div class="tab-content">
                    <h3>Manage Leave Applications</h3>

                    <!-- Pending Leaves -->
                    <div class="table-container mb-4">
                        <h4>Pending Leave Applications</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Leave Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Days</th>
                                    <th>Status</th>
                                    <th>Applied Date</th>
                                    <th>Department/Section</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($pendingLeaves)): ?>
                                    <tr>
                                        <td colspan="9" class="text-center">No pending leave applications</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($pendingLeaves as $leave): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($leave['employee_id'] . ' - ' . $leave['first_name'] . ' ' . $leave['last_name']); ?></td>
                                        <td><?php echo htmlspecialchars($leave['leave_type_name']); ?></td>
                                        <td><?php echo formatDate($leave['start_date']); ?></td>
                                        <td><?php echo formatDate($leave['end_date']); ?></td>
                                        <td><?php echo $leave['days_requested']; ?></td>
                                        <td>
                                            <span class="badge <?php echo getStatusBadgeClass($leave['status']); ?>">
                                                <?php echo getStatusDisplayName($leave['status']); ?>
                                            </span>
                                        </td>
                                        <td><?php echo formatDate($leave['applied_at']); ?></td>
                                        <td><?php echo htmlspecialchars(($leave['department_name'] ?? 'N/A') . ' / ' . ($leave['section_name'] ?? 'N/A')); ?></td>
                                        <td>
                                            <?php if ($user['role'] === 'sub_section_head' && $leave['status'] === 'pending_subsection_head'): ?>
                                                <a href="manage.php?action=subsection_head_approve&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-success btn-sm action-btn"
                                                   onclick="return confirm('Approve this leave application as sub section head?')">Approve</a>
                                                <a href="manage.php?action=reject_leave&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-danger btn-sm action-btn"
                                                   onclick="return confirm('Reject this leave application?')">Reject</a>
                                            <?php elseif ($user['role'] === 'section_head' && $leave['status'] === 'pending_section_head'): ?>
                                                <a href="manage.php?action=section_head_approve&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-success btn-sm action-btn"
                                                   onclick="return confirm('Approve this leave application as section head?')">Approve</a>
                                                <a href="manage.php?action=reject_leave&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-danger btn-sm action-btn"
                                                   onclick="return confirm('Reject this leave application?')">Reject</a>
                                            <?php elseif ($user['role'] === 'dept_head' && $leave['status'] === 'pending_dept_head'): ?>
                                                <a href="manage.php?action=dept_head_approve&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-success btn-sm action-btn"
                                                   onclick="return confirm('Approve this leave application as department head?')">Approve</a>
                                                <a href="manage.php?action=reject_leave&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-danger btn-sm action-btn"
                                                   onclick="return confirm('Reject this leave application?')">Reject</a>
                                            <?php elseif ($user['role'] === 'managing_director' && $leave['status'] === 'pending_managing_director'): ?>
                                                <a href="manage.php?action=managing_director_approve&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-success btn-sm action-btn"
                                                   onclick="return confirm('Approve this leave application as Managing Director?')">Approve</a>
                                                <a href="manage.php?action=reject_leave&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-danger btn-sm action-btn"
                                                   onclick="return confirm('Reject this leave application?')">Reject</a>
                                            <?php elseif ($user['role'] === 'hr_manager'): 
                                                // ✅ MODIFIED: HR can now approve/reject their own applications
                                                // No need to check if it's their own application anymore
                                                ?>
                                                <a href="manage.php?action=hr_approve&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-success btn-sm action-btn"
                                                   onclick="return confirm('Approve this leave application as HR?')">HR Approve</a>
                                                <a href="manage.php?action=reject_leave&id=<?php echo $leave['id']; ?>&csrf_token=<?php echo $_SESSION['csrf_token']; ?>"
                                                   class="btn btn-danger btn-sm action-btn"
                                                   onclick="return confirm('Reject this leave application?')">Reject</a>
                                            <?php else: ?>
                                                <span class="text-muted">No actions available</span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Approved Leaves -->
                    <div class="table-container mb-4">
                        <h4>Recently Approved Leaves</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Leave Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Days</th>
                                    <th>Approved By</th>
                                    <th>Approval Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($approvedLeaves)): ?>
                                    <tr>
                                        <td colspan="8" class="text-center">No approved leaves found</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($approvedLeaves as $leave): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($leave['employee_id'] . ' - ' . $leave['first_name'] . ' ' . $leave['last_name']); ?></td>
                                        <td><?php echo htmlspecialchars($leave['leave_type_name']); ?></td>
                                        <td><?php echo formatDate($leave['start_date']); ?></td>
                                        <td><?php echo formatDate($leave['end_date']); ?></td>
                                        <td><?php echo $leave['days_requested']; ?></td>
                                        <td><?php echo htmlspecialchars($leave['approver_name'] ?? 'System'); ?></td>
                                        <td><?php echo formatDate($leave['approval_date'] ?? 'N/A'); ?></td>
                                        <td><span class="badge badge-success">Approved</span></td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Rejected Leaves -->
                    <div class="table-container">
                        <h4>Recently Rejected Leaves</h4>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Leave Type</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Days</th>
                                    <th>Rejected By</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if (empty($rejectedLeaves)): ?>
                                    <tr>
                                        <td colspan="7" class="text-center">No rejected leaves found</td>
                                    </tr>
                                <?php else: ?>
                                    <?php foreach ($rejectedLeaves as $leave): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($leave['employee_id'] . ' - ' . $leave['first_name'] . ' ' . $leave['last_name']); ?></td>
                                        <td><?php echo htmlspecialchars($leave['leave_type_name']); ?></td>
                                        <td><?php echo formatDate($leave['start_date']); ?></td>
                                        <td><?php echo formatDate($leave['end_date']); ?></td>
                                        <td><?php echo $leave['days_requested']; ?></td>
                                        <td><?php echo htmlspecialchars($leave['approver_name'] ?? 'System'); ?></td>
                                        <td><span class="badge badge-danger">Rejected</span></td>
                                    </tr>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Session Update Notification -->
    <div id="sessionUpdateNotification" class="session-update-notification">
        Session activity updated
    </div>

    <script>
    // Update session activity when user interacts with approve/reject buttons
    document.addEventListener('DOMContentLoaded', function() {
        const actionButtons = document.querySelectorAll('.action-btn');
        const notification = document.getElementById('sessionUpdateNotification');
        
        actionButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Update session activity via AJAX
                fetch('extend_session.php', {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.valid) {
                        // Show notification
                        notification.style.display = 'block';
                        setTimeout(() => {
                            notification.style.display = 'none';
                        }, 2000);
                    }
                })
                .catch(error => console.log('Session update requested'));
            });
        });

        // Also update session activity on page interactions
        const activityEvents = ['click', 'mousemove', 'keypress', 'scroll', 'touchstart'];
        activityEvents.forEach(event => {
            document.addEventListener(event, function() {
                // Debounce the session update to avoid too many requests
                if (window.sessionUpdateTimeout) {
                    clearTimeout(window.sessionUpdateTimeout);
                }
                window.sessionUpdateTimeout = setTimeout(() => {
                    fetch('extend_session.php', {
                        method: 'GET',
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        },
                        credentials: 'same-origin'
                    });
                }, 1000);
            }, { passive: true });
        });
    });
    </script>
</body>
</html>