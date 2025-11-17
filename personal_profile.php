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

require_once 'auth_check.php';
require_once 'config.php';
require_once 'auth.php';

// Get database connection
$conn = getConnection();

// Create uploads directories if they don't exist
$uploadDir = 'uploads/documents/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}
$profileUploadDir = 'uploads/profile_images/';
if (!file_exists($profileUploadDir)) {
    mkdir($profileUploadDir, 0777, true);
}

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// personal_profile.php — SECURE PROFILE ACCESS
$requested_token = $_GET['token'] ?? null;
$current_user_emp_id = null;
$display_employee = null;

// Get current user's employee ID
if (isset($_SESSION['user_id'])) {
    $stmt = $conn->prepare("SELECT e.id FROM employees e JOIN users u ON u.employee_id = e.employee_id WHERE u.id = ?");
    $stmt->bind_param("i", $_SESSION['user_id']);
    $stmt->execute();
    $result = $stmt->get_result()->fetch_assoc();
    $current_user_emp_id = $result['id'] ?? null;
}

$is_viewing_other = false;

if ($requested_token) {
    // HR/super_admin viewing someone else's profile via token
    if (hasPermission('hr_manager') || hasPermission('super_admin')) {
        $stmt = $conn->prepare("SELECT e.*, d.name as department_name, s.name as section_name FROM employees e LEFT JOIN departments d ON e.department_id = d.id LEFT JOIN sections s ON e.section_id = s.id WHERE e.profile_token = ?");
        $stmt->bind_param("s", $requested_token);
        $stmt->execute();
        $display_employee = $stmt->get_result()->fetch_assoc();
        $is_viewing_other = true;
        if (!$display_employee) {
            redirectWithMessage('employees.php', 'Employee profile not found.', 'danger');
            exit();
        }
    } else {
        redirectWithMessage('employees.php', 'Access denied.', 'danger');
        exit();
    }
} elseif (isset($_GET['view_employee']) && (hasPermission('hr_manager') || hasPermission('dept_head') || hasPermission('super_admin'))) {
    // HR/dept_head/super_admin viewing specific employee
    $viewing_employee_id = (int)$_GET['view_employee'];
    $emp_query = "SELECT e.*, d.name as department_name, s.name as section_name FROM employees e LEFT JOIN departments d ON e.department_id = d.id LEFT JOIN sections s ON e.section_id = s.id WHERE e.id = ?";
    $emp_stmt = $conn->prepare($emp_query);
    $emp_stmt->bind_param("i", $viewing_employee_id);
    $emp_stmt->execute();
    $display_employee = $emp_stmt->get_result()->fetch_assoc();
    $is_viewing_other = true;
    if (!$display_employee) {
        redirectWithMessage('employees.php', 'Employee not found.', 'danger');
        exit();
    }
} else {
    // Viewing own profile
    if (!$current_user_emp_id) {
        redirectWithMessage('login.php', 'Please log in.', 'danger');
        exit();
    }
    $stmt = $conn->prepare("SELECT e.*, d.name as department_name, s.name as section_name FROM employees e LEFT JOIN departments d ON e.department_id = d.id LEFT JOIN sections s ON e.section_id = s.id WHERE e.id = ?");
    $stmt->bind_param("i", $current_user_emp_id);
    $stmt->execute();
    $display_employee = $stmt->get_result()->fetch_assoc();
}

if (!$display_employee) {
    redirectWithMessage('employees.php', 'Profile unavailable.', 'danger');
    exit();
}

// Fetch current user for password change (only for own profile)
$current_user = null;
if (!$is_viewing_other && isset($_SESSION['user_id'])) {
    $user_stmt = $conn->prepare("SELECT * FROM users WHERE id = ?");
    $user_stmt->bind_param("i", $user['id']);
    $user_stmt->execute();
    $current_user = $user_stmt->get_result()->fetch_assoc();
    $employee_id_str = $current_user['employee_id'];
}

// Check if user can manage documents and dependencies
function canManageDocumentsAndDependencies() {
    return hasPermission('hr_manager') || hasPermission('super_admin');
}

// Helper functions
function getEmployeeTypeBadge($type) {
    $badges = [
        'full_time' => 'badge-primary',
        'part_time' => 'badge-info',
        'contract' => 'badge-warning',
        'temporary' => 'badge-secondary',
        'officer' => 'badge-primary',
        'section_head' => 'badge-info',
        'manager' => 'badge-success',
        'hr_manager' => 'badge-success',
        'dept_head' => 'badge-info',
        'managing_director' => 'badge-primary',
        'bod_chairman' => 'badge-primary'
    ];
    return $badges[$type] ?? 'badge-light';
}

function getEmployeeStatusBadge($status) {
    $badges = [
        'active' => 'badge-success',
        'on_leave' => 'badge-warning',
        'terminated' => 'badge-danger',
        'resigned' => 'badge-secondary',
        'inactive' => 'badge-secondary',
        'fired' => 'badge-danger',
        'retired' => 'badge-secondary'
    ];
    return $badges[$status] ?? 'badge-light';
}

function formatDate($date) {
    if (!$date || $date == '0000-00-00') return 'N/A';
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

function redirectWithMessage($url, $message, $type = 'info') {
    $_SESSION['flash_message'] = $message;
    $_SESSION['flash_type'] = $type;
    header("Location: $url");
    exit();
}

function sanitizeInput($data) {
    if ($data === null) {
        return '';
    }
    return htmlspecialchars(stripslashes(trim($data)));
}

// Parse next of kin JSON with error handling
$next_of_kin_list = [];
if (!empty($display_employee['next_of_kin'])) {
    $nok_data = $display_employee['next_of_kin'];
    
    // Check if it's already a valid JSON array
    if (is_array($nok_data)) {
        $next_of_kin_list = $nok_data;
    } 
    // Check if it's a JSON string
    else if (is_string($nok_data)) {
        // Try to decode as JSON
        $decoded = json_decode($nok_data, true);
        
        if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
            $next_of_kin_list = $decoded;
        } else {
            // Handle malformed JSON - try to extract data manually
            preg_match_all('/"name":"([^"]*)","relationship":"([^"]*)","contact":"([^"]*)"/', $nok_data, $matches);
            
            if (!empty($matches[1])) {
                for ($i = 0; $i < count($matches[1]); $i++) {
                    $next_of_kin_list[] = [
                        'name' => $matches[1][$i],
                        'relationship' => $matches[2][$i],
                        'contact' => $matches[3][$i]
                    ];
                }
            }
        }
    }
}

// Fix malformed next_of_kin data
$fix_stmt = $conn->prepare("SELECT id, next_of_kin FROM employees WHERE next_of_kin IS NOT NULL AND next_of_kin != ''");
$fix_stmt->execute();
$result = $fix_stmt->get_result();

while ($row = $result->fetch_assoc()) {
    $nok_data = $row['next_of_kin'];
    $fixed_data = null;
    
    // Try to parse as JSON first
    $decoded = json_decode($nok_data, true);
    
    if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
        // Valid JSON, no need to fix
        continue;
    }
    
    // Try to fix common issues
    if (strpos($nok_data, '[{') === 0 && substr($nok_data, -1) !== ']') {
        // Missing closing bracket
        $fixed_data = $nok_data . ']';
    } else if (preg_match('/\{[^}]+\}/', $nok_data)) {
        // Might be a single object instead of array
        $fixed_data = '[' . $nok_data . ']';
    }
    
    if ($fixed_data) {
        // Try to validate the fixed JSON
        $test_decode = json_decode($fixed_data, true);
        if (json_last_error() === JSON_ERROR_NONE) {
            $update_stmt = $conn->prepare("UPDATE employees SET next_of_kin = ? WHERE id = ?");
            $update_stmt->bind_param("si", $fixed_data, $row['id']);
            $update_stmt->execute();
        }
    }
}

// Fetch employee dependencies
$dependencies = [];
if (isset($display_employee['id'])) {
    $dep_stmt = $conn->prepare("SELECT * FROM dependencies WHERE employee_id = ? ORDER BY created_at DESC");
    $dep_stmt->bind_param("i", $display_employee['id']);
    $dep_stmt->execute();
    $dep_result = $dep_stmt->get_result();
    $dependencies = $dep_result->fetch_all(MYSQLI_ASSOC);
}

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action'])) {
        $action = $_POST['action'];
        if ($action === 'change_password' && !$is_viewing_other) {
            $old_password = sanitizeInput($_POST['old_password']);
            $new_password = sanitizeInput($_POST['new_password']);
            $confirm_password = sanitizeInput($_POST['confirm_password']);
            if ($new_password !== $confirm_password) {
                $error = 'New passwords do not match.';
            } elseif (strlen($new_password) < 8) {
                $error = 'New password must be at least 8 characters long.';
            } else {
                $current_hash = $current_user['password'];
                if (!password_verify($old_password, $current_hash)) {
                    $error = 'Incorrect old password.';
                } else {
                    $new_hash = password_hash($new_password, PASSWORD_DEFAULT);
                    $update_stmt = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
                    $update_stmt->bind_param("si", $new_hash, $user['id']);
                    if ($update_stmt->execute()) {
                        redirectWithMessage('personal_profile.php', 'Password changed successfully!', 'success');
                    } else {
                        $error = 'Error changing password.';
                    }
                }
            }
        } elseif ($action === 'upload_document' && canManageDocumentsAndDependencies()) {
            $employee_id = $_POST['employee_id'];
            $document_name = sanitizeInput($_POST['document_name']);
            if (isset($_FILES['document_file']) && $_FILES['document_file']['error'] === UPLOAD_ERR_OK) {
                $file = $_FILES['document_file'];
                $fileType = mime_content_type($file['tmp_name']);
                if ($fileType !== 'application/pdf') {
                    $error = 'Only PDF files are allowed.';
                } else {
                    $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
                    $fileName = uniqid() . '.' . $extension;
                    $filePath = $uploadDir . $fileName;
                    if (move_uploaded_file($file['tmp_name'], $filePath)) {
                        $stmt = $conn->prepare("INSERT INTO employee_documents (employee_id, document_name, file_name) VALUES (?, ?, ?)");
                        $stmt->bind_param("iss", $employee_id, $document_name, $fileName);
                        if ($stmt->execute()) {
                            redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Document uploaded successfully!', 'success');
                        } else {
                            $error = 'Error saving document information.';
                        }
                    } else {
                        $error = 'Error uploading file.';
                    }
                }
            } else {
                $error = 'Please select a valid PDF file.';
            }
        } elseif ($action === 'delete_document' && canManageDocumentsAndDependencies()) {
            $document_id = $_POST['document_id'];
            $stmt = $conn->prepare("SELECT file_name FROM employee_documents WHERE id = ?");
            $stmt->bind_param("i", $document_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $document = $result->fetch_assoc();
            if ($document) {
                $filePath = $uploadDir . $document['file_name'];
                if (file_exists($filePath)) {
                    unlink($filePath);
                }
                $delete_stmt = $conn->prepare("DELETE FROM employee_documents WHERE id = ?");
                $delete_stmt->bind_param("i", $document_id);
                if ($delete_stmt->execute()) {
                    redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Document deleted successfully!', 'success');
                } else {
                    $error = 'Error deleting document.';
                }
            }
        } elseif ($action === 'upload_profile_image') {
            $employee_auto_id = $_POST['employee_id'];
            $emp_stmt = $conn->prepare("SELECT employee_id, profile_image_url FROM employees WHERE id = ?");
            $emp_stmt->bind_param("i", $employee_auto_id);
            $emp_stmt->execute();
            $emp_result = $emp_stmt->get_result();
            $emp = $emp_result->fetch_assoc();
            $emp_string_id = $emp['employee_id'];
            $old_image_url = $emp['profile_image_url'];
            if (!canManageDocumentsAndDependencies() && $emp_string_id != $current_user['employee_id']) {
                $error = 'Unauthorized to upload profile image.';
            } elseif (isset($_FILES['profile_image']) && $_FILES['profile_image']['error'] === UPLOAD_ERR_OK) {
                $file = $_FILES['profile_image'];
                $allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
                $fileType = mime_content_type($file['tmp_name']);
                if (in_array($fileType, $allowed_types)) {
                    $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
                    $fileName = uniqid() . '.' . $extension;
                    $filePath = $profileUploadDir . $fileName;
                    $relativePath = 'uploads/profile_images/' . $fileName;
                    if (move_uploaded_file($file['tmp_name'], $filePath)) {
                        if ($old_image_url && file_exists($old_image_url)) {
                            unlink($old_image_url);
                        }
                        $update_stmt = $conn->prepare("UPDATE employees SET profile_image_url = ? WHERE id = ?");
                        $update_stmt->bind_param("si", $relativePath, $employee_auto_id);
                        if ($update_stmt->execute()) {
                            redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Profile image uploaded successfully!', 'success');
                        } else {
                            $error = 'Error updating profile image.';
                        }
                    } else {
                        $error = 'Error uploading file.';
                    }
                } else {
                    $error = 'Only JPEG, PNG, or GIF files are allowed.';
                }
            } else {
                $error = 'Please select a valid image file.';
            }
        } elseif ($action === 'add_dependency' && canManageDocumentsAndDependencies()) {
            $employee_id = $_POST['employee_id'];
            $name = sanitizeInput($_POST['name']);
            $relationship = sanitizeInput($_POST['relationship']);
            $date_of_birth = $_POST['date_of_birth'];
            $gender = sanitizeInput($_POST['gender']);
            $id_no = sanitizeInput($_POST['id_no']);
            $contact = sanitizeInput($_POST['contact']);
            
            // Insert into dependencies table
            $stmt = $conn->prepare("INSERT INTO dependencies (employee_id, name, relationship, date_of_birth, gender, id_no, contact) VALUES (?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("issssss", $employee_id, $name, $relationship, $date_of_birth, $gender, $id_no, $contact);
            $stmt->execute();
            
            // Update next_of_kin JSON
            $emp_stmt = $conn->prepare("SELECT next_of_kin FROM employees WHERE id = ?");
            $emp_stmt->bind_param("i", $employee_id);
            $emp_stmt->execute();
            $result = $emp_stmt->get_result()->fetch_assoc();
            $current_nok = $result['next_of_kin'] ? json_decode($result['next_of_kin'], true) : [];
            if (!is_array($current_nok)) {
                $current_nok = [];
            }
            $current_nok[] = [
                'name' => $name,
                'relationship' => $relationship,
                'contact' => $contact
            ];
            $new_nok_json = json_encode($current_nok);
            $update_stmt = $conn->prepare("UPDATE employees SET next_of_kin = ? WHERE id = ?");
            $update_stmt->bind_param("si", $new_nok_json, $employee_id);
            $update_stmt->execute();
            
            redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Dependency and next of kin added successfully!', 'success');
        } elseif ($action === 'edit_dependency' && canManageDocumentsAndDependencies()) {
            $dep_id = $_POST['dep_id'];
            $name = sanitizeInput($_POST['name']);
            $relationship = sanitizeInput($_POST['relationship']);
            $date_of_birth = $_POST['date_of_birth'];
            $gender = sanitizeInput($_POST['gender']);
            $id_no = sanitizeInput($_POST['id_no']);
            $contact = sanitizeInput($_POST['contact']);
            $stmt = $conn->prepare("UPDATE dependencies SET name=?, relationship=?, date_of_birth=?, gender=?, id_no=?, contact=? WHERE id=?");
            $stmt->bind_param("ssssssi", $name, $relationship, $date_of_birth, $gender, $id_no, $contact, $dep_id);
            if ($stmt->execute()) {
                redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Dependency updated successfully!', 'success');
            } else {
                $error = 'Error updating dependency.';
            }
        } elseif ($action === 'delete_dependency' && canManageDocumentsAndDependencies()) {
            $dep_id = $_POST['dep_id'];
            $delete_stmt = $conn->prepare("DELETE FROM dependencies WHERE id = ?");
            $delete_stmt->bind_param("i", $dep_id);
            if ($delete_stmt->execute()) {
                redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Dependency deleted successfully!', 'success');
            } else {
                $error = 'Error deleting dependency.';
            }
        } elseif ($action === 'add_next_of_kin' && canManageDocumentsAndDependencies()) {
            $employee_id = $_POST['employee_id'];
            $name = sanitizeInput($_POST['name']);
            $relationship = sanitizeInput($_POST['relationship']);
            $contact = sanitizeInput($_POST['contact']);
            
            $emp_stmt = $conn->prepare("SELECT next_of_kin FROM employees WHERE id = ?");
            $emp_stmt->bind_param("i", $employee_id);
            $emp_stmt->execute();
            $result = $emp_stmt->get_result()->fetch_assoc();
            $current_nok = $result['next_of_kin'] ? json_decode($result['next_of_kin'], true) : [];
            if (!is_array($current_nok)) {
                $current_nok = [];
            }
            $current_nok[] = [
                'name' => $name,
                'relationship' => $relationship,
                'contact' => $contact
            ];
            $new_nok_json = json_encode($current_nok);
            $update_stmt = $conn->prepare("UPDATE employees SET next_of_kin = ? WHERE id = ?");
            $update_stmt->bind_param("si", $new_nok_json, $employee_id);
            if ($update_stmt->execute()) {
                redirectWithMessage('personal_profile.php?token=' . ($requested_token ?? '') . '&view_employee=' . ($_GET['view_employee'] ?? ''), 'Next of kin added successfully!', 'success');
            } else {
                $error = 'Error adding next of kin.';
            }
        }
    }
}

// Fetch employee documents
$documents = [];
if (isset($display_employee['id'])) {
    $doc_stmt = $conn->prepare("SELECT * FROM employee_documents WHERE employee_id = ? ORDER BY uploaded_at DESC");
    $doc_stmt->bind_param("i", $display_employee['id']);
    $doc_stmt->execute();
    $doc_result = $doc_stmt->get_result();
    $documents = $doc_result->fetch_all(MYSQLI_ASSOC);
}

include 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .password-match-indicator {
            margin-top: 5px;
            font-size: 14px;
            font-weight: bold;
        }
        .password-match {
            color: #28a745;
        }
        .password-no-match {
            color: #dc3545;
        }
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }
        .strength-weak {
            color: #dc3545;
        }
        .strength-medium {
            color: #ffc107;
        }
        .strength-strong {
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Tabs -->
            <div class="tabs">
                <ul>
                    <li>
                        <a href="personal_profile.php" class="tab-link <?= basename($_SERVER['PHP_SELF']) === 'personal_profile.php' ? 'active' : '' ?>" data-tab="profile">
                            My Profile
                        </a>
                    </li>
                    <?php if (hasPermission('hr_manager') || hasPermission('super_admin')): ?>
                        <li>
                            <a href="employees.php" class="tab-link <?= basename($_SERVER['PHP_SELF']) === 'employees.php' ? 'active' : '' ?>" data-tab="employees">
                                Manage Employees
                            </a>
                        </li>
                    <?php endif; ?>
                </ul>
            </div>
            <!-- Content -->
            <div class="content">
                <?php $flash = getFlashMessage(); if ($flash): ?>
                    <div class="alert alert-<?php echo $flash['type']; ?>">
                        <?php echo htmlspecialchars($flash['message']); ?>
                    </div>
                <?php endif; ?>
                <?php if (isset($error)): ?>
                    <div class="alert alert-danger"><?php echo htmlspecialchars($error); ?></div>
                <?php endif; ?>
                <div id="profile" class="tab-content active">
                    <div class="document-container">
                        <div class="document-header">
                            <h2>Employee Profile</h2>
                            <?php if (canManageDocumentsAndDependencies()): ?>
                                <button onclick="showAddDependencyModal()" class="btn btn-primary">Add Dependency</button>
                                <button onclick="showAddNextOfKinModal()" class="btn btn-primary">Add Next of Kin</button>
                                <button onclick="showUploadModal()" class="btn btn-primary">Upload Document</button>
                            <?php endif; ?>
                        </div>
                        <div class="avatar-container">
                            <?php if (!empty($display_employee['profile_image_url'])): ?>
                                <img src="<?php echo htmlspecialchars($display_employee['profile_image_url']); ?>" alt="Profile Image" class="profile-img">
                            <?php else: ?>
                                <div class="avatar-initials">
                                    <?php echo strtoupper(substr($display_employee['first_name'] ?? '', 0, 1) . substr($display_employee['last_name'] ?? '', 0, 1)); ?>
                                </div>
                            <?php endif; ?>
                            <?php if (!$is_viewing_other || canManageDocumentsAndDependencies()): ?>
                                <button onclick="showProfileUploadModal()" class="btn btn-primary btn-sm" style="margin-top: 10px;">Upload Profile Image</button>
                            <?php endif; ?>
                        </div>
                        <div class="document-content">
                            <div class="label">Employee ID:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['employee_id']); ?></div>
                            <div class="label">Name:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['first_name'] . ' ' . $display_employee['last_name']); ?></div>
                            <div class="label">Email:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['email'] ?? 'N/A'); ?></div>
                            <div class="label">Department:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['department_name'] ?? 'N/A'); ?></div>
                            <div class="label">Section:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['section_name'] ?? 'N/A'); ?></div>
                            <div class="label">Type:</div>
                            <div class="value"><?php echo ucwords(str_replace('_', ' ', $display_employee['employee_type'] ?? 'N/A')); ?></div>
                            <div class="label">Status:</div>
                            <div class="value"><?php echo ucwords($display_employee['employee_status'] ?? 'N/A'); ?></div>
                            <div class="label">Job Group:</div>
                            <div class="value"><?php echo htmlspecialchars($display_employee['job_group'] ?? 'N/A'); ?></div>
                        </div>

                        <!-- Password Change Form - Only visible when viewing own profile -->
                        <?php if (!$is_viewing_other): ?>
                            <div class="password-form" style="margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
                                <h3>Change Password</h3>
                                <form method="POST" action="" id="passwordChangeForm">
                                    <input type="hidden" name="action" value="change_password">
                                    <div class="form-group">
                                        <label for="old_password">Old Password</label>
                                        <input type="password" class="form-control" id="old_password" name="old_password" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="new_password">New Password (minimum 8 characters)</label>
                                        <input type="password" class="form-control" id="new_password" name="new_password" required>
                                        <div id="password-strength" class="password-strength"></div>
                                    </div>
                                    <div class="form-group">
                                        <label for="confirm_password">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" required>
                                        <div id="password-match-indicator" class="password-match-indicator"></div>
                                    </div>
                                    <button type="submit" class="btn btn-primary" id="submitPasswordBtn">Change Password</button>
                                </form>
                            </div>
                        <?php endif; ?>

                        <!-- Next of Kin Section -->
                        <div class="next-of-kin-section" style="margin-top: 30px;">
                            <h3>Next of Kin</h3>
                            <?php if (empty($next_of_kin_list)): ?>
                                <p>No next of kin added yet.</p>
                            <?php else: ?>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Relationship</th>
                                            <th>Contact</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($next_of_kin_list as $nok): ?>
                                            <tr>
                                                <td><?php echo htmlspecialchars($nok['name'] ?? 'N/A'); ?></td>
                                                <td><?php echo htmlspecialchars($nok['relationship'] ?? 'N/A'); ?></td>
                                                <td><?php echo htmlspecialchars($nok['contact'] ?? 'N/A'); ?></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            <?php endif; ?>
                        </div>
                        <!-- Dependencies Section -->
                        <div class="dependencies-section" style="margin-top: 30px;">
                            <h3>Employee Dependencies</h3>
                            <?php if (empty($dependencies)): ?>
                                <p>No dependencies added yet.</p>
                            <?php else: ?>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th>Relationship</th>
                                            <th>Date of Birth</th>
                                            <th>Gender</th>
                                            <th>ID No</th>
                                            <th>Contact</th>
                                            <?php if (canManageDocumentsAndDependencies()): ?>
                                                <th>Action</th>
                                            <?php endif; ?>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($dependencies as $dep): ?>
                                            <tr>
                                                <td><?php echo htmlspecialchars($dep['name']); ?></td>
                                                <td><?php echo htmlspecialchars($dep['relationship']); ?></td>
                                                <td><?php echo formatDate($dep['date_of_birth']); ?></td>
                                                <td><?php echo ucfirst($dep['gender'] ?? 'N/A'); ?></td>
                                                <td><?php echo htmlspecialchars($dep['id_no'] ?? 'N/A'); ?></td>
                                                <td><?php echo htmlspecialchars($dep['contact'] ?? 'N/A'); ?></td>
                                                <?php if (canManageDocumentsAndDependencies()): ?>
                                                    <td>
                                                        <button onclick="showEditDependencyModal(<?php echo htmlspecialchars(json_encode($dep)); ?>)" class="btn btn-sm btn-primary">Edit</button>
                                                        <button onclick="deleteDependency(<?php echo $dep['id']; ?>)" class="btn btn-sm btn-danger">Delete</button>
                                                    </td>
                                                <?php endif; ?>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            <?php endif; ?>
                        </div>
                        <!-- Documents Section -->
                        <div class="documents-section" style="margin-top: 30px;">
                            <h3>Employee Documents</h3>
                            <?php if (empty($documents)): ?>
                                <p>No documents uploaded yet.</p>
                            <?php else: ?>
                                <div class="documents-list">
                                    <?php foreach ($documents as $doc): ?>
                                        <div class="document-item">
                                            <div class="document-name"><?php echo htmlspecialchars($doc['document_name']); ?></div>
                                            <div class="document-actions">
                                                <a href="uploads/documents/<?php echo htmlspecialchars($doc['file_name']); ?>" target="_blank" class="btn btn-sm btn-primary">View</a>
                                                <?php if (canManageDocumentsAndDependencies()): ?>
                                                    <button onclick="deleteDocument(<?php echo $doc['id']; ?>)" class="btn btn-sm btn-danger">Delete</button>
                                                <?php endif; ?>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Upload Document Modal -->
    <?php if (canManageDocumentsAndDependencies()): ?>
        <div id="uploadModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Upload Document</h3>
                    <span class="close" onclick="hideUploadModal()">&times;</span>
                </div>
                <form method="POST" action="" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="upload_document">
                    <input type="hidden" name="employee_id" value="<?php echo $display_employee['id'] ?? ''; ?>">
                    <div class="form-group">
                        <label for="document_name">Document Name</label>
                        <input type="text" class="form-control" id="document_name" name="document_name" required>
                    </div>
                    <div class="form-group">
                        <label for="document_file">Select PDF File</label>
                        <input type="file" class="form-control" id="document_file" name="document_file" accept=".pdf" required>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Upload</button>
                        <button type="button" class="btn btn-secondary" onclick="hideUploadModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    <?php endif; ?>
    <!-- Upload Profile Image Modal -->
    <div id="profileUploadModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Upload Profile Image</h3>
                <span class="close" onclick="hideProfileUploadModal()">&times;</span>
            </div>
            <form method="POST" action="" enctype="multipart/form-data">
                <input type="hidden" name="action" value="upload_profile_image">
                <input type="hidden" name="employee_id" value="<?php echo $display_employee['id'] ?? ''; ?>">
                <div class="form-group">
                    <label for="profile_image">Select Image (JPEG, PNG, GIF)</label>
                    <input type="file" class="form-control" id="profile_image" name="profile_image" accept="image/jpeg, image/png, image/gif" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Upload</button>
                    <button type="button" class="btn btn-secondary" onclick="hideProfileUploadModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <!-- Add Dependency Modal -->
    <?php if (canManageDocumentsAndDependencies()): ?>
        <div id="addDependencyModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add Dependency</h3>
                    <span class="close" onclick="hideAddDependencyModal()">&times;</span>
                </div>
                <form method="POST" action="">
                    <input type="hidden" name="action" value="add_dependency">
                    <input type="hidden" name="employee_id" value="<?php echo $display_employee['id'] ?? ''; ?>">
                    <div class="form-group">
                        <label for="dep_name">Name</label>
                        <input type="text" class="form-control" id="dep_name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="dep_relationship">Relationship</label>
                        <input type="text" class="form-control" id="dep_relationship" name="relationship" required>
                    </div>
                    <div class="form-group">
                        <label for="dep_date_of_birth">Date of Birth</label>
                        <input type="date" class="form-control" id="dep_date_of_birth" name="date_of_birth" required>
                    </div>
                    <div class="form-group">
                        <label for="dep_gender">Gender</label>
                        <select class="form-control" id="dep_gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="dep_id_no">ID No</label>
                        <input type="text" class="form-control" id="dep_id_no" name="id_no">
                    </div>
                    <div class="form-group">
                        <label for="dep_contact">Contact</label>
                        <input type="text" class="form-control" id="dep_contact" name="contact">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Add</button>
                        <button type="button" class="btn btn-secondary" onclick="hideAddDependencyModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    <?php endif; ?>
    <!-- Edit Dependency Modal -->
    <?php if (canManageDocumentsAndDependencies()): ?>
        <div id="editDependencyModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Edit Dependency</h3>
                    <span class="close" onclick="hideEditDependencyModal()">&times;</span>
                </div>
                <form method="POST" action="">
                    <input type="hidden" name="action" value="edit_dependency">
                    <input type="hidden" id="edit_dep_id" name="dep_id">
                    <div class="form-group">
                        <label for="edit_dep_name">Name</label>
                        <input type="text" class="form-control" id="edit_dep_name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_dep_relationship">Relationship</label>
                        <input type="text" class="form-control" id="edit_dep_relationship" name="relationship" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_dep_date_of_birth">Date of Birth</label>
                        <input type="date" class="form-control" id="edit_dep_date_of_birth" name="date_of_birth" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_dep_gender">Gender</label>
                        <select class="form-control" id="edit_dep_gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="edit_dep_id_no">ID No</label>
                        <input type="text" class="form-control" id="edit_dep_id_no" name="id_no">
                    </div>
                    <div class="form-group">
                        <label for="edit_dep_contact">Contact</label>
                        <input type="text" class="form-control" id="edit_dep_contact" name="contact">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Update</button>
                        <button type="button" class="btn btn-secondary" onclick="hideEditDependencyModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    <?php endif; ?>
    <!-- Add Next of Kin Modal -->
    <?php if (canManageDocumentsAndDependencies()): ?>
        <div id="addNextOfKinModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add Next of Kin</h3>
                    <span class="close" onclick="hideAddNextOfKinModal()">&times;</span>
                </div>
                <form method="POST" action="">
                    <input type="hidden" name="action" value="add_next_of_kin">
                    <input type="hidden" name="employee_id" value="<?php echo $display_employee['id'] ?? ''; ?>">
                    <div class="form-group">
                        <label for="nok_name">Name</label>
                        <input type="text" class="form-control" id="nok_name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="nok_relationship">Relationship</label>
                        <input type="text" class="form-control" id="nok_relationship" name="relationship" required>
                    </div>
                    <div class="form-group">
                        <label for="nok_contact">Contact</label>
                        <input type="text" class="form-control" id="nok_contact" name="contact">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Add</button>
                        <button type="button" class="btn btn-secondary" onclick="hideAddNextOfKinModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    <?php endif; ?>
    <script>
        // Password matching and strength validation
        const newPassword = document.getElementById('new_password');
        const confirmPassword = document.getElementById('confirm_password');
        const matchIndicator = document.getElementById('password-match-indicator');
        const strengthIndicator = document.getElementById('password-strength');
        const submitBtn = document.getElementById('submitPasswordBtn');

        function checkPasswordStrength(password) {
            let strength = 0;
            if (password.length >= 8) strength++;
            if (password.length >= 12) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z\d]/.test(password)) strength++;

            if (password.length < 8) {
                return { level: 'Too Short', className: 'strength-weak', score: 0 };
            } else if (strength <= 2) {
                return { level: 'Weak', className: 'strength-weak', score: 1 };
            } else if (strength <= 3) {
                return { level: 'Medium', className: 'strength-medium', score: 2 };
            } else {
                return { level: 'Strong', className: 'strength-strong', score: 3 };
            }
        }

        if (newPassword) {
            newPassword.addEventListener('input', function() {
                const password = this.value;
                if (password.length > 0) {
                    const strength = checkPasswordStrength(password);
                    strengthIndicator.textContent = `Password Strength: ${strength.level}`;
                    strengthIndicator.className = `password-strength ${strength.className}`;
                } else {
                    strengthIndicator.textContent = '';
                }
                checkPasswordMatch();
            });
        }

        if (confirmPassword) {
            confirmPassword.addEventListener('input', checkPasswordMatch);
        }

        function checkPasswordMatch() {
            const newPass = newPassword.value;
            const confirmPass = confirmPassword.value;

            if (confirmPass.length === 0) {
                matchIndicator.textContent = '';
                matchIndicator.className = 'password-match-indicator';
                return;
            }

            if (newPass === confirmPass && newPass.length >= 8) {
                matchIndicator.textContent = '✓ Passwords match';
                matchIndicator.className = 'password-match-indicator password-match';
            } else if (newPass === confirmPass && newPass.length < 8) {
                matchIndicator.textContent = '✓ Passwords match (but too short)';
                matchIndicator.className = 'password-match-indicator password-no-match';
            } else {
                matchIndicator.textContent = '✗ Passwords do not match';
                matchIndicator.className = 'password-match-indicator password-no-match';
            }
        }

        <?php if (canManageDocumentsAndDependencies()): ?>
            function showUploadModal() {
                document.getElementById('uploadModal').style.display = 'block';
            }
            function hideUploadModal() {
                document.getElementById('uploadModal').style.display = 'none';
            }
            function showAddDependencyModal() {
                document.getElementById('addDependencyModal').style.display = 'block';
            }
            function hideAddDependencyModal() {
                document.getElementById('addDependencyModal').style.display = 'none';
            }
            function showAddNextOfKinModal() {
                document.getElementById('addNextOfKinModal').style.display = 'block';
            }
            function hideAddNextOfKinModal() {
                document.getElementById('addNextOfKinModal').style.display = 'none';
            }
            function showEditDependencyModal(dep) {
                document.getElementById('edit_dep_id').value = dep.id;
                document.getElementById('edit_dep_name').value = dep.name;
                document.getElementById('edit_dep_relationship').value = dep.relationship;
                document.getElementById('edit_dep_date_of_birth').value = dep.date_of_birth;
                document.getElementById('edit_dep_gender').value = dep.gender;
                document.getElementById('edit_dep_id_no').value = dep.id_no;
                document.getElementById('edit_dep_contact').value = dep.contact;
                document.getElementById('editDependencyModal').style.display = 'block';
            }
            function hideEditDependencyModal() {
                document.getElementById('editDependencyModal').style.display = 'none';
            }
            function deleteDocument(docId) {
                if (confirm('Are you sure you want to delete this document?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '';
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete_document';
                    form.appendChild(actionInput);
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'document_id';
                    idInput.value = docId;
                    form.appendChild(idInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            function deleteDependency(depId) {
                if (confirm('Are you sure you want to delete this dependency?')) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '';
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete_dependency';
                    form.appendChild(actionInput);
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'dep_id';
                    idInput.value = depId;
                    form.appendChild(idInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        <?php endif; ?>
        function showProfileUploadModal() {
            document.getElementById('profileUploadModal').style.display = 'block';
        }
        function hideProfileUploadModal() {
            document.getElementById('profileUploadModal').style.display = 'none';
        }
        window.onclick = function(event) {
            <?php if (canManageDocumentsAndDependencies()): ?>
                const uploadModal = document.getElementById('uploadModal');
                const addDependencyModal = document.getElementById('addDependencyModal');
                const editDependencyModal = document.getElementById('editDependencyModal');
                const addNextOfKinModal = document.getElementById('addNextOfKinModal');
                if (event.target == uploadModal) {
                    hideUploadModal();
                } else if (event.target == addDependencyModal) {
                    hideAddDependencyModal();
                } else if (event.target == editDependencyModal) {
                    hideEditDependencyModal();
                } else if (event.target == addNextOfKinModal) {
                    hideAddNextOfKinModal();
                }
            <?php endif; ?>
            const profileUploadModal = document.getElementById('profileUploadModal');
            if (event.target == profileUploadModal) {
                hideProfileUploadModal();
            }
        }
    </script>
</body>
</html>