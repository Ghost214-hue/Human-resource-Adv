<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

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
require_once 'auth.php';
require_once 'config.php';
require 'vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id'],
    'employee_id' => $_SESSION['employee_id'] ?? null
];


// Function to send supervisor notification email
function sendSupervisorNotification($appraisal_id, $conn) {
    require 'email_config.php';
    
    // Get supervisor (appraiser) email and details
    $emailStmt = $conn->prepare("
        SELECT e.email, e.first_name, e.last_name, ea.appraisal_cycle_id, ac.name as cycle_name,
               emp.first_name as employee_first, emp.last_name as employee_last
        FROM employee_appraisals ea
        JOIN employees e ON ea.appraiser_id = e.id
        JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id
        JOIN employees emp ON ea.employee_id = emp.id
        WHERE ea.id = ?
    ");
    $emailStmt->bind_param("i", $appraisal_id);
    $emailStmt->execute();
    $emailResult = $emailStmt->get_result();
    
    if ($emailData = $emailResult->fetch_assoc()) {
        $to_email = $emailData['email'];
        $supervisor_name = $emailData['first_name'] . ' ' . $emailData['last_name'];
        $employee_name = $emailData['employee_first'] . ' ' . $emailData['employee_last'];
        $cycle_name = $emailData['cycle_name'];
        
        try {
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
            $mail->addAddress($to_email, $supervisor_name);
            
            // Content
            $mail->isHTML(true);
            $mail->Subject = 'Employee Comment Submitted - Action Required for ' . $cycle_name;
            
            $appraisal_url = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . 
                             "://$_SERVER[HTTP_HOST]" . dirname($_SERVER['PHP_SELF']) . 
                             "/performance_appraisal.php?appraisal_id=" . $appraisal_id;
            
            $mail->Body = "
                <html>
                <body style='font-family: Arial, sans-serif; line-height: 1.6;'>
                    <div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;'>
                        <h2 style='color: #2c3e50;'>Employee Appraisal Comment Notification</h2>
                        <p>Dear $supervisor_name,</p>
                        <p>$employee_name has submitted their comments for the performance appraisal in the <strong>$cycle_name</strong> cycle.</p>
                        <p>Please log in to the HR Management System to review the employee's comments, provide your supervisor comments, and submit the appraisal.</p>
                        <div style='text-align: center; margin: 25px 0;'>
                            <a href='$appraisal_url' style='background-color: #4CAF50; color: white; padding: 12px 24px; text-align: center; text-decoration: none; display: inline-block; border-radius: 5px; font-weight: bold;'>Review Appraisal</a>
                        </div>
                        <p>If you have any questions, please contact HR.</p>
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
            
            $mail->AltBody = "Dear $supervisor_name,\n\n$employee_name has submitted their comments for the performance appraisal in the $cycle_name cycle.\n\nPlease log in to the HR Management System to review the employee's comments, provide your supervisor comments, and submit the appraisal.\n\nAppraisal URL: $appraisal_url\n\nIf you have any questions, please contact HR.\n\nBest regards,\nHR Management Team";
            
            $mail->send();
            return true;
        } catch (Exception $e) {
            error_log("Supervisor notification email could not be sent. Mailer Error: {$mail->ErrorInfo}");
            return false;
        }
    }
    return false;
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

$conn = getConnection();

// Get current user's employee record
$userEmployeeQuery = "SELECT e.* FROM employees e 
                     LEFT JOIN users u ON u.employee_id = e.employee_id 
                     WHERE u.id = ?";
$stmt = $conn->prepare($userEmployeeQuery);
$stmt->bind_param("i", $user['id']);
$stmt->execute();
$currentEmployee = $stmt->get_result()->fetch_assoc();

if (!$currentEmployee) {
    $_SESSION['flash_message'] = 'Employee record not found.';
    $_SESSION['flash_type'] = 'danger';
    header("Location: dashboard.php");
    exit();
}

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action']) && $_POST['action'] === 'add_comment') {
        $appraisal_id = $_POST['appraisal_id'];
        $employee_comment = trim($_POST['employee_comment']);
        $employee_satisfied = isset($_POST['employee_satisfied']) ? (int)$_POST['employee_satisfied'] : null;
        
        // Validate that comment is provided
        if (empty($employee_comment)) {
            $_SESSION['flash_message'] = 'Please enter a comment.';
            $_SESSION['flash_type'] = 'warning';
            header("Location: employee_appraisal.php");
            exit();
        }
        
        // Validate that satisfaction option is selected
        if (is_null($employee_satisfied)) {
            $_SESSION['flash_message'] = 'Please indicate whether you are satisfied with this appraisal.';
            $_SESSION['flash_type'] = 'warning';
            header("Location: employee_appraisal.php");
            exit();
        }
        
        // Update appraisal with employee comment and satisfaction
        $updateStmt = $conn->prepare("
            UPDATE employee_appraisals 
            SET employee_comment = ?, employee_satisfied = ?, 
                status = 'awaiting_submission', employee_comment_date = CURRENT_TIMESTAMP, 
                updated_at = CURRENT_TIMESTAMP 
            WHERE id = ? AND employee_id = ?
        ");
        $updateStmt->bind_param("siii", $employee_comment, $employee_satisfied, $appraisal_id, $currentEmployee['id']);
        
        if ($updateStmt->execute()) {
            // Send notification to supervisor
            $emailSent = sendSupervisorNotification($appraisal_id, $conn);
            $_SESSION['flash_message'] = 'Your comment has been added successfully.' . 
                                         ($emailSent ? ' Supervisor has been notified.' : ' Failed to notify supervisor.');
            $_SESSION['flash_type'] = $emailSent ? 'success' : 'warning';
        } else {
            $_SESSION['flash_message'] = 'Error saving your comment. Please try again.';
            $_SESSION['flash_type'] = 'danger';
        }
        
        header("Location: employee_appraisal.php");
        exit();
    }
}

// Get employee's appraisals (only 'draft' and 'awaiting_employee' status)
$appraisalsStmt = $conn->prepare("
    SELECT ea.*, ac.name as cycle_name, ac.start_date, ac.end_date,
           e_appraiser.first_name as appraiser_first_name, e_appraiser.last_name as appraiser_last_name
    FROM employee_appraisals ea
    JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id
    JOIN employees e_appraiser ON ea.appraiser_id = e_appraiser.id
    WHERE ea.employee_id = ? AND ea.status IN ('draft', 'awaiting_employee')
    ORDER BY ac.start_date DESC, ea.created_at DESC
");
$appraisalsStmt->bind_param("i", $currentEmployee['id']);
$appraisalsStmt->execute();
$appraisals = $appraisalsStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get performance indicators
$indicatorsStmt = $conn->prepare("SELECT * FROM performance_indicators WHERE is_active = 1 ORDER BY max_score DESC, name");
$indicatorsStmt->execute();
$indicators = $indicatorsStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get scores for all appraisals
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
require_once 'header.php'; 
require_once 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Performance Appraisals - HR Management System</title>
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
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        .cycle-info h4 {
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }
        
        .cycle-details {
            color: var(--text-secondary);
            font-size: 0.875rem;
        }
        
        .appraisal-status {
            text-align: right;
        }
        
        .indicators-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 1.5rem;
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
        }
        
        .score-display {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .comment-section {
            background: rgba(255, 255, 255, 0.03);
            padding: 1.5rem;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            margin-top: 1.5rem;
        }
        
        .comment-textarea {
            width: 100%;
            min-height: 120px;
            padding: 1rem;
            background: var(--bg-glass);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            color: var(--text-primary);
            resize: vertical;
            font-family: inherit;
            line-height: 1.6;
        }
        
        .readonly-comment {
            background: rgba(255, 255, 255, 0.05);
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            color: var(--text-secondary);
            line-height: 1.6;
        }
        
        .weight-badge {
            background: rgba(0, 212, 255, 0.2);
            color: var(--primary-color);
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .total-score {
            background: var(--bg-glass);
            padding: 1rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            margin-bottom: 1rem;
            text-align: center;
        }
        
        .total-score h5 {
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        
        .total-score .score {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .status-draft {
            background-color: rgba(108, 117, 125, 0.2);
            color: #6c757d;
        }
        
        .status-awaiting_employee {
            background-color: rgba(255, 193, 7, 0.2);
            color: #ffc107;
        }
        
        .status-awaiting_submission {
            background-color: rgba(23, 162, 184, 0.2);
            color: #17a2b8;
        }
        
        .status-submitted {
            background-color: rgba(40, 167, 69, 0.2);
            color: #28a745;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: var(--bg-glass);
            border-radius: 16px;
            border: 1px solid var(--border-color);
        }
        
        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            color: var(--text-muted);
        }
        
        .empty-state h3 {
            color: var(--text-primary);
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: var(--text-secondary);
            max-width: 500px;
            margin: 0 auto 1.5rem;
        }
        
        .zero-score {
            opacity: 0.6;
            background-color: rgba(108, 117, 125, 0.1);
        }
        
        .satisfaction-status {
            margin-top: 15px;
            padding: 10px;
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        
        .satisfaction-options {
            margin: 15px 0;
        }
        
        .satisfaction-options label {
            display: block;
            margin-bottom: 10px;
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 8px;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .radio-option input[type="radio"] {
            margin-right: 8px;
            width: 18px;
            height: 18px;
            accent-color: var(--primary-color);
        }
        
        .satisfaction-options .text-muted {
            color: var(--text-muted);
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: block;
        }
        
        .satisfied-text {
            color: #28a745;
            font-weight: 600;
        }
        
        .not-satisfied-text {
            color: #dc3545;
            font-weight: 600;
        }
        
        .form-actions {
            margin-top: 20px;
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

                 <div class="leave-tabs">
                    <a href="strategic_plan.php?tab=goals" class="leave-tab">Strategic Plan</a>
                    <a href="employee_appraisal.php" class="leave-tab active">Employee Appraisal</a>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager', 'managing_director', 'section_head', 'dept_head' , 'sub_section_head'])): ?>
                        <a href="performance_appraisal.php" class="leave-tab">Performance Appraisal</a>
                    <?php endif; ?>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager'])): ?>
                        <a href="appraisal_management.php" class="leave-tab">Appraisal Management</a>
                    <?php endif; ?>
                    <a href="completed_appraisals.php" class="leave-tab">Completed Appraisals</a>
                </div>
                
                <?php if (!empty($appraisals)): ?>
                    <!-- Employee Appraisals -->
                    <?php foreach ($appraisals as $appraisal): 
                        $employee_scores = $scores_by_appraisal[$appraisal['id']] ?? [];
                        $has_scores = !empty($employee_scores);
                        
                        // Calculate total score
                        $total_score = 0;
                    
                        foreach ($indicators as $indicator) {
                            if (isset($employee_scores[$indicator['id']])) {
                                $score = $employee_scores[$indicator['id']]['score'];
                                $total_score += ($score);
                            }
                        }
                        
                        // Format status for display
                        $status_display = ucwords(str_replace('_', ' ', $appraisal['status']));
                        $status_class = 'status-' . $appraisal['status'];
                    ?>
                        <div class="appraisal-card">
                            <div class="appraisal-header">
                                <div class="cycle-info">
                                    <h4><?php echo htmlspecialchars($appraisal['cycle_name']); ?></h4>
                                    <div class="cycle-details">
                                        <strong>Period:</strong> <?php echo date('M d, Y', strtotime($appraisal['start_date'])); ?> - <?php echo date('M d, Y', strtotime($appraisal['end_date'])); ?><br>
                                        <strong>Appraiser:</strong> <?php echo htmlspecialchars($appraisal['appraiser_first_name'] . ' ' . $appraisal['appraiser_last_name']); ?>
                                    </div>
                                </div>
                                <div class="appraisal-status">
                                    <span class="status-badge <?php echo $status_class; ?>"><?php echo $status_display; ?></span>
                                    <?php if ($appraisal['submitted_at']): ?>
                                        <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 0.5rem;">
                                            Submitted on <?php echo date('M d, Y', strtotime($appraisal['submitted_at'])); ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            </div>

                            <?php if ($has_scores): ?>
                                <!-- Total Score Display -->
                                <div class="total-score">
                                    <h5>Overall Score</h5>
                                    <div class="score"><?php echo number_format($total_score, 1); ?></div>
                                </div>

                                <!-- Performance Indicators Table -->
                                <table class="indicators-table">
                                    <thead>
                                        <tr>
                                            <th>Performance Indicator</th>
                                            <th>Score</th>
                                            <th>Appraiser Comment</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php 
                                        foreach ($indicators as $indicator): 
                                            $score_data = $employee_scores[$indicator['id']] ?? null;
                                            
                                            if (!$score_data) {
                                                continue;
                                            }
                                            
                                            $row_class = $score_data['score'] == 0 ? 'zero-score' : '';
                                        ?>
                                            <tr class="<?php echo $row_class; ?>">
                                                <td>
                                                    <strong><?php echo htmlspecialchars($indicator['name']); ?></strong>
                                                    <?php if ($indicator['description']): ?>
                                                        <br><small class="text-muted"><?php echo htmlspecialchars($indicator['description']); ?></small>
                                                    <?php endif; ?>
                                                </td>
                                                <td>
                                                    <span class="score-display"><?php echo htmlspecialchars($score_data['score']); ?>/<?php echo $indicator['max_score']; ?></span>
                                                </td>
                                                <td>
                                                    <?php if ($score_data['appraiser_comment']): ?>
                                                        <?php echo nl2br(htmlspecialchars($score_data['appraiser_comment'])); ?>
                                                    <?php else: ?>
                                                        <span class="text-muted">No comment</span>
                                                    <?php endif; ?>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            <?php else: ?>
                                <div class="alert alert-info">
                                    This appraisal is still in progress. Your appraiser has not yet completed the scoring.
                                </div>
                            <?php endif; ?>

                            <!-- Employee Comment Section -->
                            <div class="comment-section">
                                <h5>Your Feedback</h5>
                                <?php if ($appraisal['employee_comment']): ?>
                                    <!-- Satisfaction Status Display -->
                                    <?php if (!is_null($appraisal['employee_satisfied'])): ?>
                                        <div class="satisfaction-status">
                                            <strong>Satisfaction Status:</strong> 
                                            <?php echo $appraisal['employee_satisfied'] ? 
                                                '<span class="satisfied-text">Satisfied</span>' : 
                                                '<span class="not-satisfied-text">Not Satisfied</span>'; ?>
                                        </div>
                                    <?php endif; ?>
                                    
                                    <div style="margin-top: 15px;">
                                        <label>Your Comment:</label>
                                        <div class="readonly-comment">
                                            <?php echo nl2br(htmlspecialchars($appraisal['employee_comment'])); ?>
                                        </div>
                                        <small class="text-muted">
                                            Added on <?php echo date('M d, Y H:i', strtotime($appraisal['employee_comment_date'])); ?>
                                        </small>
                                    </div>
                                    
                                <?php elseif ($appraisal['status'] === 'awaiting_employee' && $has_scores): ?>
                                    <form method="POST" action="">
                                        <input type="hidden" name="action" value="add_comment">
                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                        
                                        <!-- Satisfaction Options -->
                                        <div class="satisfaction-options">
                                            <label>Are you satisfied with this appraisal? <span style="color: #dc3545;">*</span></label>
                                            <div class="radio-group">
                                                <div class="radio-option">
                                                    <input type="radio" id="satisfied_yes" name="employee_satisfied" value="1" required>
                                                    <label for="satisfied_yes">Satisfied</label>
                                                </div>
                                                <div class="radio-option">
                                                    <input type="radio" id="satisfied_no" name="employee_satisfied" value="0" required>
                                                    <label for="satisfied_no">Not Satisfied</label>
                                                </div>
                                            </div>
                                            <small class="text-muted">Please select one option</small>
                                        </div>
                                        
                                        <!-- Employee Comment -->
                                        <div class="form-group" style="margin-top: 20px;">
                                            <label for="employee_comment">Your Comment: <span style="color: #dc3545;">*</span></label>
                                            <textarea name="employee_comment" 
                                                      id="employee_comment" 
                                                      class="comment-textarea" 
                                                      placeholder="Share your thoughts on the appraisal, any achievements you'd like to highlight, areas for development, or goals for the next period..."
                                                      required></textarea>
                                        </div>
                                        
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">Submit Feedback</button>
                                        </div>
                                    </form>
                                <?php else: ?>
                                    <div class="alert alert-info">
                                        You will be able to add your feedback once your appraiser completes the scoring.
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    
                <?php else: ?>
                    <div class="empty-state">
                        <div class="empty-state-icon">📋</div>
                        <h3>No Active Appraisals</h3>
                        <p>You don't have any appraisals in draft or awaiting your input at the moment. Your supervisor will create appraisals during review periods.</p>
                        <a href="dashboard.php" class="btn btn-primary">Return to Dashboard</a>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>
</body>
</html>