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

// Detect if running on HTTPS or HTTP
$isSecure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') 
            || $_SERVER['SERVER_PORT'] == 443
            || (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');

// Start session with environment-aware secure parameters
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
    session_regenerate_id(true);
}

// Include DB connection and audit logger
require_once 'config.php';

// No need to re-initialize audit logger here since it's already in config.php
// $auditLogger is already available from config.php

// Initialize CSRF token
if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Redirect if already logged in
if (isset($_SESSION['user_id'])) {
    header("Location: dashboard.php");
    exit();
}

$error = '';
$success = '';

// ===== Security Logging =====
function logSecurityEvent($event_type, $user_id = 0, $email = '') {
    $mysqli = getConnection();
    $ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
    $details = json_encode([
        'script' => $_SERVER['PHP_SELF'] ?? '',
        'referrer' => $_SERVER['HTTP_REFERER'] ?? '',
        'email' => $email
    ]);

    try {
        $stmt = $mysqli->prepare("INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details) VALUES (?, ?, ?, ?, ?)");
        $user_id = $user_id ?: NULL;
        $stmt->bind_param("issss", $user_id, $event_type, $ip_address, $user_agent, $details);
        $stmt->execute();
    } catch (Exception $e) {
        error_log("Security logging failed: " . $e->getMessage());
    }
}

// ===== Rate Limiting =====
function checkLoginRateLimit($email) {
    $key = 'login_attempts_' . md5($email . $_SERVER['REMOTE_ADDR']);
    if (!isset($_SESSION[$key])) {
        $_SESSION[$key] = [
            'count' => 1,
            'first_attempt' => time(),
            'last_attempt' => time()
        ];
        return true;
    }

    $attempts = $_SESSION[$key];

    // Reset counter after 15 minutes
    if (time() - $attempts['first_attempt'] > 900) {
        $_SESSION[$key] = [
            'count' => 1,
            'first_attempt' => time(),
            'last_attempt' => time()
        ];
        return true;
    }

    // Block after 5 attempts
    if ($attempts['count'] >= 5) {
        return false;
    }

    $_SESSION[$key]['count']++;
    $_SESSION[$key]['last_attempt'] = time();
    return true;
}

function trackFailedLogin($email) {
    $key = 'login_attempts_' . md5($email . $_SERVER['REMOTE_ADDR']);
    logSecurityEvent('login_failed', 0, $email);
}

function clearLoginAttempts($email) {
    $key = 'login_attempts_' . md5($email . $_SERVER['REMOTE_ADDR']);
    unset($_SESSION[$key]);
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

// ===== User Authentication =====
function authenticateUser($email, $password) {
    $mysqli = getConnection();
    
    // Updated query to check both users table and employees table for active status
    $stmt = $mysqli->prepare("
        SELECT u.id, u.email, u.password, u.role, u.first_name, u.last_name, u.designation, u.is_active,
               e.employee_status, e.employee_id
        FROM users u
        LEFT JOIN employees e ON u.email = e.email
        WHERE u.email = ?
    ");
    
    if (!$stmt) return false;

    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    $stmt->close();

    if ($user) {
        // Check if user account is active in users table
        if (!$user['is_active']) {
            logSecurityEvent('login_attempt_inactive_account', $user['id'], $email);
            return false;
        }

        // Check if employee status is active in employees table
        if ($user['employee_status'] && $user['employee_status'] !== 'active') {
            $status = strtolower($user['employee_status']);
            $statusMessage = '';
            
            switch ($status) {
                case 'inactive':
                    $statusMessage = 'inactive';
                    break;
                case 'terminated':
                case 'fired':
                case 'dismissed':
                    $statusMessage = 'terminated';
                    break;
                case 'retired':
                    $statusMessage = 'retired';
                    break;
                case 'resigned':
                    $statusMessage = 'resigned';
                    break;
                case 'suspended':
                    $statusMessage = 'suspended';
                    break;
                default:
                    $statusMessage = 'not active';
            }
            
            logSecurityEvent('login_attempt_inactive_employee', $user['id'], $email);
            $_SESSION['employee_status_error'] = $user['employee_status'];
            return false;
        }

        // Verify password and upgrade legacy hashes if needed
        if (password_verify($password, $user['password']) || $password === $user['password']) {
            if ($password === $user['password']) {
                $newHash = password_hash($password, PASSWORD_DEFAULT);
                $update = $mysqli->prepare("UPDATE users SET password = ? WHERE id = ?");
                $update->bind_param("si", $newHash, $user['id']);
                $update->execute();
                $update->close();
                logSecurityEvent('password_upgraded', $user['id'], $email);
            }
            return $user;
        }
    }

    return false;
}

// ===== Check User Consent =====
function checkUserConsent($user_id) {
    $mysqli = getConnection();
    $stmt = $mysqli->prepare("SELECT consent_given FROM user_consents WHERE user_id = ? AND consent_given = 1");
    if (!$stmt) return false;
    
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $hasConsent = $result->num_rows > 0;
    $stmt->close();
    
    return $hasConsent;
}

// ===== Get Employee Status Message =====
function getEmployeeStatusMessage($status) {
    $status = strtolower($status);
    switch ($status) {
        case 'inactive':
            return 'Your account is currently inactive. Please contact HR for assistance.';
        case 'terminated':
        case 'fired':
        case 'dismissed':
            return 'Your employment has been terminated. Access to the system is no longer available.';
        case 'retired':
            return 'You have retired from the organization. System access is no longer available.';
        case 'resigned':
            return 'You have resigned from the organization. System access has been revoked.';
        case 'suspended':
            return 'Your account is temporarily suspended. Please contact HR for more information.';
        case 'on_leave':
            return 'You are currently on leave. System access may be restricted.';
        default:
            return 'Your account is not active. Please contact HR department.';
    }
}

// ===== Login Form Processing =====
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        $error = 'Security token invalid. Please refresh the page and try again.';
        logSecurityEvent('csrf_validation_failed', 0, $_POST['email'] ?? '');
    } else {
        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';

        // Input validation
        if (empty($email)) {
            $error = 'Please enter your email address.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'Please enter a valid email address.';
        } elseif (empty($password)) {
            $error = 'Please enter your password.';
        } elseif (!checkLoginRateLimit($email)) {
            $error = 'Too many login attempts. Please wait 15 minutes and try again.';
            logSecurityEvent('rate_limit_exceeded', 0, $email);
        } else {
            $user = authenticateUser($email, $password);

            if ($user) {
                // Check if there's an employee status error
                if (isset($_SESSION['employee_status_error'])) {
                    $employeeStatus = $_SESSION['employee_status_error'];
                    $error = getEmployeeStatusMessage($employeeStatus);
                    unset($_SESSION['employee_status_error']);
                    logSecurityEvent('login_blocked_employee_status', $user['id'], $email);
                    // Log failed login attempt due to employee status
                    trackAction('LOGIN_FAILED', "Login blocked due to employee status: $employeeStatus", [
                        'username' => $email,
                        'user_id' => $user['id']
                    ]);
                } else {
                    clearLoginAttempts($email);
                    logSecurityEvent('login_credentials_validated', $user['id'], $email);
                    
                    // Check if user has provided consent
                    $hasConsent = checkUserConsent($user['id']);
                    
                    if (!$hasConsent) {
                        // Store pending authentication data in session
                        $_SESSION['pending_user_id'] = $user['id'];
                        $_SESSION['pending_user_email'] = $user['email'];
                        $_SESSION['pending_user_name'] = trim($user['first_name'] . ' ' . $user['last_name']);
                        $_SESSION['pending_user_role'] = $user['role'];
                        $_SESSION['pending_designation'] = $user['designation'];
                        $_SESSION['pending_auth_time'] = time();
                        
                        logSecurityEvent('consent_required_redirect', $user['id'], $email);
                        
                        // Redirect to consent page
                        header("Location: consent.php");
                        exit();
                    }
                    
                    // User has consent, proceed with full login
                    $mysqli = getConnection();
                    $session_token = bin2hex(random_bytes(32));
                    $login_identifier = bin2hex(random_bytes(32));

                    // Get proper employee name
                    $employee_name = trim($user['first_name'] . ' ' . $user['last_name']);
                    if (empty($employee_name) || $employee_name === ' ') {
                        // Fallback to getting name from employees table
                        $stmt = $mysqli->prepare("
                            SELECT first_name, last_name 
                            FROM employees 
                            WHERE email = ? OR employee_id = ?
                        ");
                        $employee_id = $user['employee_id'] ?? null;
                        $stmt->bind_param("ss", $user['email'], $employee_id);
                        $stmt->execute();
                        $result = $stmt->get_result();
                        if ($emp = $result->fetch_assoc()) {
                            $employee_name = trim($emp['first_name'] . ' ' . $emp['last_name']);
                        }
                        $stmt->close();
                    }

                    // Update user session data
                    $stmt = $mysqli->prepare("UPDATE users SET session_token = ?, login_identifier = ?, last_activity = NOW() WHERE id = ?");
                    $stmt->bind_param("ssi", $session_token, $login_identifier, $user['id']);

                    if ($stmt->execute()) {
                        logSecurityEvent('login_success', $user['id'], $email);

                        // Regenerate session ID and set session data
                        session_regenerate_id(true);
                        session_unset();

                        $_SESSION['user_id'] = $user['id'];
                        $_SESSION['user_email'] = $user['email'];
                        $_SESSION['user_name'] = $employee_name;
                        $_SESSION['user_role'] = $user['role'];
                        $_SESSION['designation'] = $user['designation'];
                        $_SESSION['employee_id'] = $user['employee_id'] ?? null;
                        $_SESSION['login_time'] = time();
                        $_SESSION['session_token'] = $session_token;
                        $_SESSION['login_identifier'] = $login_identifier;
                        $_SESSION['last_activity'] = time();
                        $_SESSION['ip_address'] = $_SERVER['REMOTE_ADDR'];
                        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
                        $_SESSION['browser_fingerprint'] = generateBrowserFingerprint();
                        $_SESSION['session_valid'] = true;

                        // Set the HR system specific session variables
                        $_SESSION['hr_system_user_id'] = $user['id'];
                        $_SESSION['hr_system_username'] = $employee_name;
                        $_SESSION['hr_system_user_role'] = $user['role'];
                        
                        // Log successful login
                        trackAction('LOGIN_SUCCESS', "User logged in successfully", [
                            'username' => $employee_name,
                            'user_id' => $user['id']
                        ]);
                        
                        // Redirect to dashboard
                        header("Location: dashboard.php");
                        exit();
                    } else {
                        $error = 'System temporarily unavailable. Please try again later.';
                        logSecurityEvent('login_update_failed', $user['id'], $email);
                        trackAction('LOGIN_FAILED', "Login update failed", [
                            'username' => $email,
                            'user_id' => $user['id']
                        ]);
                    }

                    $stmt->close();
                }
            } else {
                $error = 'The email or password you entered is incorrect.';
                trackFailedLogin($email);
                // Log failed login attempt
                trackAction('LOGIN_FAILED', "Failed login attempt", [
                    'username' => $email
                ]);
            }
        }
    }
}

// Flash messages for user feedback
$flash = '';
if (isset($_SESSION['flash_message'])) {
    $flash = $_SESSION['flash_message'];
    $flash_type = $_SESSION['flash_type'] ?? 'info';
    unset($_SESSION['flash_message'], $_SESSION['flash_type']);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Login - MUWASCO HR System</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box glass-card">
            <!-- Logo Section -->
            <div class="login-header">
                <div class="login-logo-container">
                    <img src="muwascologo.png" alt="MUWASCO Logo" class="login-logo">
                    <div class="login-brand-text">
                        <h2>HR Management System</h2>
                        <p>Muranga Water & Sanitation Co. Ltd</p>
                    </div>
                </div>
            </div>

            <p class="text-center text-muted mb-3">
                Secure Employee Portal
            </p>

            <?php if ($error): ?>
                <div class="alert alert-danger mb-3">
                    <?php echo htmlspecialchars($error); ?>
                </div>
            <?php endif; ?>

            <?php if ($success): ?>
                <div class="alert alert-success mb-3">
                    <?php echo htmlspecialchars($success); ?>
                </div>
            <?php endif; ?>

            <?php if ($flash): ?>
                <div class="alert alert-<?php echo htmlspecialchars($flash_type); ?> mb-3">
                    <?php echo htmlspecialchars($flash); ?>
                </div>
            <?php endif; ?>

            <form method="POST" action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>">
                <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($_SESSION['csrf_token']); ?>">

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           class="form-control"
                           id="email"
                           name="email"
                           value="<?php echo isset($_POST['email']) ? htmlspecialchars($_POST['email']) : ''; ?>"
                           required
                           autocomplete="email"
                           placeholder="Enter your company email">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password"
                           class="form-control"
                           id="password"
                           name="password"
                           required
                           autocomplete="current-password"
                           placeholder="Enter your password">
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-sign-in-alt"></i> Sign In to Your Account
                </button>
            </form>

            <div class="text-center mt-3">
                <p class="text-muted" style="font-size: 0.875rem;">
                    <i class="fas fa-life-ring"></i> Need assistance? Contact HR Support
                </p>

                <?php if (isset($_POST['email']) && isset($_SESSION['login_attempts_' . md5($_POST['email'] . $_SERVER['REMOTE_ADDR'])])): 
                    $attempts = $_SESSION['login_attempts_' . md5($_POST['email'] . $_SERVER['REMOTE_ADDR'])];
                    $timeLeft = 900 - (time() - $attempts['first_attempt']);
                    $minutesLeft = ceil($timeLeft / 60);
                ?>
                    <div class="text-danger mt-2" style="font-size: 0.875rem;">
                        <i class="fas fa-shield-alt"></i> Login attempts: <?php echo $attempts['count']; ?>/5<br>
                        <?php if ($timeLeft > 0): ?>
                            <i class="fas fa-clock"></i> Time until reset: <?php echo $minutesLeft; ?> minute(s)
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const emailField = document.getElementById('email');
            if (emailField) emailField.focus();

            document.querySelectorAll('.alert').forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });

            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }
        });
    </script>
</body>
</html>