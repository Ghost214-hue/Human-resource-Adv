<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Security headers
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');
header('X-XSS-Protection: 1; mode=block');
header('Referrer-Policy: strict-origin-when-cross-origin');

// Start session with secure parameters FIRST - This is critical
$isSecure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') 
            || $_SERVER['SERVER_PORT'] == 443
            || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');

if (session_status() == PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => '',
        'secure' => $isSecure,
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}

// Initialize session variables if they don't exist
if (!isset($_SESSION['user_name'])) $_SESSION['user_name'] = '';
if (!isset($_SESSION['user_role'])) $_SESSION['user_role'] = '';
if (!isset($_SESSION['pending_user_id'])) $_SESSION['pending_user_id'] = null;
if (!isset($_SESSION['pending_user_name'])) $_SESSION['pending_user_name'] = '';
if (!isset($_SESSION['pending_user_email'])) $_SESSION['pending_user_email'] = '';
if (!isset($_SESSION['pending_user_role'])) $_SESSION['pending_user_role'] = '';
if (!isset($_SESSION['pending_designation'])) $_SESSION['pending_designation'] = '';
if (!isset($_SESSION['pending_auth_time'])) $_SESSION['pending_auth_time'] = 0;
if (!isset($_SESSION['csrf_token'])) $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
if (!isset($_SESSION['flash_message'])) $_SESSION['flash_message'] = '';
if (!isset($_SESSION['flash_type'])) $_SESSION['flash_type'] = '';

// Include DB connection
require_once 'config.php';

// Check if user has pending authentication
if (!isset($_SESSION['pending_user_id']) || $_SESSION['pending_user_id'] === null || !isset($_SESSION['pending_auth_time'])) {
    $_SESSION['flash_message'] = 'Session expired. Please login again.';
    $_SESSION['flash_type'] = 'warning';
    header("Location: login.php");
    exit();
}

// Validate pending_user_id is a positive integer
$pending_user_id = (int)$_SESSION['pending_user_id'];
if ($pending_user_id <= 0) {
    unset($_SESSION['pending_user_id'], $_SESSION['pending_user_email'], $_SESSION['pending_user_name'], 
          $_SESSION['pending_user_role'], $_SESSION['pending_designation'], $_SESSION['pending_auth_time']);
    $_SESSION['flash_message'] = 'Invalid user session. Please login again.';
    $_SESSION['flash_type'] = 'warning';
    header("Location: login.php");
    exit();
}

// Check if pending auth is still valid (within 10 minutes)
if (time() - $_SESSION['pending_auth_time'] > 600) {
    unset($_SESSION['pending_user_id'], $_SESSION['pending_user_email'], $_SESSION['pending_user_name'], 
          $_SESSION['pending_user_role'], $_SESSION['pending_designation'], $_SESSION['pending_auth_time']);
    $_SESSION['flash_message'] = 'Session expired. Please login again.';
    $_SESSION['flash_type'] = 'warning';
    header("Location: login.php");
    exit();
}

$error = '';
$success = '';

// ===== Security Logging =====
function logSecurityEvent($event_type, $user_id = 0, $details_array = []) {
    $mysqli = getConnection();
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
    $details = json_encode(array_merge([
        'script' => $_SERVER['PHP_SELF'] ?? '',
        'referrer' => $_SERVER['HTTP_REFERER'] ?? ''
    ], $details_array));

    try {
        $stmt = $mysqli->prepare("INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details) VALUES (?, ?, ?, ?, ?)");
        $user_id = $user_id ?: NULL;
        $stmt->bind_param("issss", $user_id, $event_type, $ip_address, $user_agent, $details);
        $stmt->execute();
    } catch (Exception $e) {
        error_log("Security logging failed: " . $e->getMessage());
    }
}

// ===== Browser Fingerprinting =====
function generateBrowserFingerprint() {
    $components = [
        $_SERVER['HTTP_USER_AGENT'] ?? '',
        $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? '',
        $_SERVER['HTTP_ACCEPT_ENCODING'] ?? '',
    ];
    return hash('sha256', implode('|', $components));
}

// ===== Function to verify National ID against employees table =====
function verifyNationalID($user_id, $national_id) {
    $mysqli = getConnection();
    
    try {
        // Get user details including employee_id
        $userStmt = $mysqli->prepare("
            SELECT u.employee_id, e.national_id, e.first_name, e.last_name, e.surname 
            FROM users u 
            LEFT JOIN employees e ON u.employee_id = e.employee_id 
            WHERE u.id = ? AND e.employee_status = 'active'
        ");
        $userStmt->bind_param("i", $user_id);
        $userStmt->execute();
        $userResult = $userStmt->get_result();
        
        if ($userResult->num_rows === 0) {
            error_log("User or employee record not found for user_id: " . $user_id);
            return ['success' => false, 'error' => 'User not found or employee record inactive.'];
        }
        
        $employeeData = $userResult->fetch_assoc();
        $stored_national_id = $employeeData['national_id'];
        $employee_id = $employeeData['employee_id'];
        
        // Debug logging
        error_log("Debug: user_id=$user_id, employee_id=$employee_id");
        error_log("Debug: entered_national_id=$national_id, stored_national_id=$stored_national_id");
        
        // Verify National ID exists
        if (empty($stored_national_id)) {
            error_log("National ID is empty for employee_id: " . $employee_id);
            return ['success' => false, 'error' => 'National ID not found in your employee record. Please contact HR.'];
        }
        
        // Since national_id is INT in database, convert both to integers for comparison
        $entered_national_id_clean = (int) preg_replace('/[^0-9]/', '', $national_id);
        $stored_national_id_clean = (int) $stored_national_id;
        
        error_log("Debug: cleaned_entered_national_id=$entered_national_id_clean, stored_national_id_int=$stored_national_id_clean");
        
        if ($stored_national_id_clean !== $entered_national_id_clean) {
            error_log("National ID mismatch: stored=$stored_national_id_clean, entered=$entered_national_id_clean");
            return ['success' => false, 'error' => 'National ID does not match our records. Please check and try again.'];
        }
        
        error_log("Debug: Verification successful for user_id=$user_id");
        
        return [
            'success' => true, 
            'employee_id' => $employee_id,
            'verified_national_id' => $stored_national_id
        ];
        
    } catch (Exception $e) {
        error_log("Verification system error: " . $e->getMessage());
        return ['success' => false, 'error' => 'Verification system error: ' . $e->getMessage()];
    }
}

// ===== Process Consent Form =====
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        $error = 'Security token invalid. Please refresh the page and try again.';
        logSecurityEvent('csrf_validation_failed', $pending_user_id);
    } else {
        $full_name = trim($_POST['full_name'] ?? '');
        $national_id = trim($_POST['national_id'] ?? '');
        $consent_accepted = isset($_POST['consent_accepted']) && $_POST['consent_accepted'] == '1';

        // Input validation
        if (empty($full_name)) {
            $error = 'Please enter your full name.';
        } elseif (strlen($full_name) < 3) {
            $error = 'Please enter a valid full name (minimum 3 characters).';
        } elseif (empty($national_id)) {
            $error = 'Please enter your national ID number.';
        } elseif (strlen($national_id) < 5) {
            $error = 'Please enter a valid national ID number (minimum 5 characters).';
        } elseif (!preg_match('/^[0-9\s\-]+$/', $national_id)) {
            $error = 'National ID should contain only numbers, spaces and hyphens.';
        } elseif (!$consent_accepted) {
            $error = 'You must accept the data protection terms to continue.';
        } else {
            // Verify National ID against employees table
            $verification_result = verifyNationalID($pending_user_id, $national_id);
            
            if (!$verification_result['success']) {
                $error = $verification_result['error'];
                logSecurityEvent('national_id_verification_failed', $pending_user_id, [
                    'entered_national_id' => $national_id,
                    'error' => $verification_result['error']
                ]);
            } else {
                // National ID verification successful - store consent in database with transaction
                $mysqli = getConnection();
                $user_id = $pending_user_id;
                $ip_address = $_SERVER['REMOTE_ADDR'];
                $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
                
                try {
                    $mysqli->begin_transaction();
                    
                    // Check if consent already exists
                    $check_stmt = $mysqli->prepare("SELECT id FROM user_consents WHERE user_id = ?");
                    $check_stmt->bind_param("i", $user_id);
                    $check_stmt->execute();
                    $exists = $check_stmt->get_result()->num_rows > 0;
                    $check_stmt->close();
                    
                    if ($exists) {
                        // Update existing consent
                        $stmt = $mysqli->prepare("UPDATE user_consents SET full_name = ?, national_id = ?, consent_given = 1, consent_date = NOW(), ip_address = ?, user_agent = ? WHERE user_id = ?");
                        $stmt->bind_param("ssssi", $full_name, $national_id, $ip_address, $user_agent, $user_id);
                    } else {
                        // Insert new consent
                        $stmt = $mysqli->prepare("INSERT INTO user_consents (user_id, full_name, national_id, consent_given, consent_date, ip_address, user_agent) VALUES (?, ?, ?, 1, NOW(), ?, ?)");
                        $stmt->bind_param("issss", $user_id, $full_name, $national_id, $ip_address, $user_agent);
                    }

                    if (!$stmt->execute()) {
                        throw new mysqli_sql_exception("Consent operation failed: " . $mysqli->error);
                    }
                    $stmt->close();
                    
                    $mysqli->commit();
                    
                    // Log successful verification and consent
                    logSecurityEvent('consent_provided_with_verification', $user_id, [
                        'full_name' => $full_name,
                        'national_id_hash' => hash('sha256', $national_id),
                        'employee_id' => $verification_result['employee_id']
                    ]);
                    
                    // Now complete the login process
                    $session_token = bin2hex(random_bytes(32));
                    $login_identifier = bin2hex(random_bytes(32));

                    // Update user session data
                    $update_stmt = $mysqli->prepare("UPDATE users SET session_token = ?, login_identifier = ?, last_activity = NOW() WHERE id = ?");
                    $update_stmt->bind_param("ssi", $session_token, $login_identifier, $user_id);

                    if ($update_stmt->execute()) {
                        logSecurityEvent('login_success_after_verified_consent', $user_id);

                        // Regenerate session ID and set session data
                        session_regenerate_id(true);
                        
                        // Transfer pending data to active session
                        $_SESSION['user_id'] = $_SESSION['pending_user_id'];
                        $_SESSION['user_email'] = $_SESSION['pending_user_email'];
                        $_SESSION['user_name'] = $_SESSION['pending_user_name'];
                        $_SESSION['user_role'] = $_SESSION['pending_user_role'];
                        $_SESSION['designation'] = $_SESSION['pending_designation'];
                        
                        // Store verification info in session
                        $_SESSION['national_id_verified'] = true;
                        $_SESSION['employee_id'] = $verification_result['employee_id'];
                        
                        // Clear pending data
                        unset($_SESSION['pending_user_id'], $_SESSION['pending_user_email'], $_SESSION['pending_user_name'],
                              $_SESSION['pending_user_role'], $_SESSION['pending_designation'], $_SESSION['pending_auth_time']);
                        
                        // Set session tokens
                        $_SESSION['login_time'] = time();
                        $_SESSION['session_token'] = $session_token;
                        $_SESSION['login_identifier'] = $login_identifier;
                        $_SESSION['last_activity'] = time();
                        $_SESSION['ip_address'] = $_SERVER['REMOTE_ADDR'];
                        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
                        $_SESSION['browser_fingerprint'] = generateBrowserFingerprint();
                        $_SESSION['session_valid'] = true;

                        // After successful login verification in other pages
                        $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
                        $_SESSION['hr_system_username'] = $_SESSION['user_name'];
                        $_SESSION['hr_system_user_role'] = $_SESSION['user_role'];

                        // Redirect to dashboard
                        header("Location: dashboard.php");
                        exit();
                    } else {
                        $mysqli->rollback();
                        $error = 'System temporarily unavailable. Please try again later.';
                        logSecurityEvent('login_update_failed_after_verified_consent', $user_id);
                    }
                    
                    $update_stmt->close();
                } catch (mysqli_sql_exception $e) {
                    $mysqli->rollback();
                    $error = 'Database error: ' . $e->getMessage() . '. Please contact support.';
                    logSecurityEvent('consent_db_error', $user_id, ['error' => $e->getMessage()]);
                } catch (Exception $e) {
                    $mysqli->rollback();
                    $error = 'Failed to save consent. Please try again.';
                    logSecurityEvent('consent_save_failed', $user_id, ['error' => $e->getMessage()]);
                }
            }
        }
    }
}

$pending_name = $_SESSION['pending_user_name'] ?? 'User';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Protection Consent - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .consent-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .consent-document {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1.5rem;
            max-height: 400px;
            overflow-y: auto;
            margin-bottom: 1.5rem;
        }
        .consent-document h3 {
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
            color: #4a90e2;
        }
        .consent-document h3:first-child {
            margin-top: 0;
        }
        .consent-document p, .consent-document ul {
            margin-bottom: 1rem;
            line-height: 1.6;
        }
        .consent-document ul {
            padding-left: 1.5rem;
        }
        .consent-checkbox {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        .consent-form-group {
            margin-bottom: 1rem;
        }
        .verification-info {
            background: rgba(0, 184, 148, 0.1);
            border: 1px solid rgba(0, 184, 148, 0.3);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            color: var(--success-color);
        }
        .input-error {
            border-color: #dc3545 !important;
            background-color: rgba(220, 53, 69, 0.05) !important;
        }
        .input-success {
            border-color: #28a745 !important;
            background-color: rgba(40, 167, 69, 0.05) !important;
        }
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="consent-container">
        <div class="glass-card">
            <h2 class="login-title">Data Protection Consent Required</h2>
            <p class="text-center text-muted mb-3">
                Welcome, <?php echo htmlspecialchars($pending_name); ?>. Please review and accept our data protection terms.
            </p>

            <?php if ($error): ?>
                <div class="alert alert-danger mb-3">
                    <?php echo htmlspecialchars($error); ?>
                    <?php if (strpos($error, 'National ID does not match') !== false): ?>
                        <div class="help-text mt-2">
                            <strong>Tip:</strong> Enter only the numeric National ID without any letters or special characters.
                        </div>
                    <?php endif; ?>
                </div>
            <?php endif; ?>

            <div class="verification-info">
                <strong>🔒 Identity Verification Required</strong>
                <p class="mb-0 mt-1">For security purposes, please enter your National ID number exactly as it appears in your employee records. This will be verified against our system.</p>
            </div>

            <div class="consent-document">
                <h3>Employee Data Protection and Consent Policy</h3>
                
                <p>
                    This HR Management System processes and stores personal employee information in accordance with 
                    applicable data protection regulations. By providing consent, you acknowledge and agree to the following:
                </p>

                <h3>1. Data Collection and Use</h3>
                <p>We collect and process the following personal information:</p>
                <ul>
                    <li>Personal identification details (name, email, national ID)</li>
                    <li>Employment information (designation, role, work history)</li>
                    <li>Performance and attendance records</li>
                    <li>Leave and benefits information</li>
                    <li>System access logs and security information</li>
                </ul>

                <h3>2. Purpose of Data Processing</h3>
                <p>Your personal data is used for:</p>
                <ul>
                    <li>Employment administration and HR management</li>
                    <li>Payroll and benefits administration</li>
                    <li>Performance management and development</li>
                    <li>Legal and regulatory compliance</li>
                    <li>System security and access control</li>
                </ul>

                <h3>3. Data Security</h3>
                <p>
                    We implement appropriate technical and organizational measures to protect your personal data against 
                    unauthorized access, alteration, disclosure, or destruction. All data transmissions are encrypted, 
                    and access is restricted to authorized personnel only.
                </p>

                <h3>4. Data Retention</h3>
                <p>
                    Personal data is retained for the duration of your employment and for a period thereafter as required 
                    by law or legitimate business purposes. You may request deletion of your data subject to legal obligations.
                </p>

                <h3>5. Your Rights</h3>
                <p>You have the right to:</p>
                <ul>
                    <li>Access your personal data</li>
                    <li>Request correction of inaccurate data</li>
                    <li>Request deletion of your data (subject to legal requirements)</li>
                    <li>Object to certain processing activities</li>
                    <li>Withdraw consent (which may affect system access)</li>
                </ul>

                <h3>6. Contact Information</h3>
                <p>
                    For questions or concerns regarding your personal data, please contact the HR Department or 
                    Data Protection Officer at your organization.
                </p>
            </div>

            <form method="POST" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" id="consentForm">
                <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">

                <div class="consent-form-group">
                    <label for="full_name">Full Name <span class="text-danger">*</span></label>
                    <input type="text"
                           class="form-control"
                           id="full_name"
                           name="full_name"
                           value="<?php echo isset($_POST['full_name']) ? htmlspecialchars($_POST['full_name']) : htmlspecialchars($pending_name); ?>"
                           required
                           placeholder="Enter your full legal name">
                    <small class="text-muted">Enter your full name as it appears on official documents</small>
                </div>

                <div class="consent-form-group">
                    <label for="national_id">National ID Number <span class="text-danger">*</span></label>
                    <input type="text"
                           class="form-control"
                           id="national_id"
                           name="national_id"
                           value="<?php echo isset($_POST['national_id']) ? htmlspecialchars($_POST['national_id']) : ''; ?>"
                           required
                           placeholder="Enter your national ID number (numbers only)"
                           pattern="[0-9\s\-]+"
                           title="Please enter only numbers, spaces, or hyphens">
                    <small class="text-muted">
                        Enter the numeric National ID exactly as recorded in your employee file.<br>
                        <strong>Note:</strong> Only numbers are accepted (e.g., 1234567890)
                    </small>
                </div>

                <div class="consent-checkbox">
                    <div class="form-check">
                        <input type="checkbox"
                               class="form-check-input"
                               id="consent_accepted"
                               name="consent_accepted"
                               value="1"
                               required>
                        <label class="form-check-label" for="consent_accepted">
                            <strong>I have read and accept the data protection terms</strong>
                        </label>
                    </div>
                    <p class="text-muted mt-2" style="font-size: 0.875rem; margin-bottom: 0;">
                        By checking this box, you confirm that you have read, understood, and agree to the terms 
                        outlined above regarding the collection, processing, and storage of your personal data.
                    </p>
                </div>

                <button type="submit" class="btn btn-primary w-100" id="submitBtn">
                    Accept Terms and Continue to Dashboard
                </button>
            </form>

            <div class="text-center mt-3">
                <p class="text-muted" style="font-size: 0.875rem;">
                    <strong>Note:</strong> You must accept these terms and verify your identity to access the HR system.
                </p>
                <a href="logout.php" class="text-danger" style="font-size: 0.875rem;">
                    Cancel and Return to Login
                </a>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const nameField = document.getElementById('full_name');
            const nationalIdField = document.getElementById('national_id');
            const consentForm = document.getElementById('consentForm');
            const submitBtn = document.getElementById('submitBtn');
            
            if (nameField) nameField.focus();

            // Auto-format national ID input (remove non-numeric characters except spaces and hyphens)
            nationalIdField.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9\s\-]/g, '');
            });

            // Real-time validation feedback
            nationalIdField.addEventListener('blur', function() {
                const cleanValue = this.value.replace(/[^0-9]/g, '');
                if (cleanValue.length >= 5) {
                    this.classList.add('input-success');
                    this.classList.remove('input-error');
                } else {
                    this.classList.add('input-error');
                    this.classList.remove('input-success');
                }
            });

            nameField.addEventListener('blur', function() {
                if (this.value.length >= 3) {
                    this.classList.add('input-success');
                    this.classList.remove('input-error');
                } else {
                    this.classList.add('input-error');
                    this.classList.remove('input-success');
                }
            });

            // Form submission enhancement
            consentForm.addEventListener('submit', function(e) {
                const nationalId = nationalIdField.value.replace(/[^0-9]/g, '');
                const fullName = nameField.value.trim();
                
                if (nationalId.length < 5) {
                    e.preventDefault();
                    nationalIdField.classList.add('input-error');
                    nationalIdField.focus();
                    alert('Please enter a valid National ID with at least 5 digits.');
                    return;
                }
                
                if (fullName.length < 3) {
                    e.preventDefault();
                    nameField.classList.add('input-error');
                    nameField.focus();
                    return;
                }
                
                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Verifying and Processing...';
            });

            // Auto-hide alerts
            document.querySelectorAll('.alert').forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });

            // Prevent back navigation after consent
            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }

            // Warn before leaving
            let formSubmitted = false;
            consentForm.addEventListener('submit', function() {
                formSubmitted = true;
            });

            window.addEventListener('beforeunload', function(e) {
                if (!formSubmitted) {
                    e.preventDefault();
                    e.returnValue = 'You have not completed the consent process. Are you sure you want to leave?';
                    return e.returnValue;
                }
            });
        });
    </script>
</body>
</html>