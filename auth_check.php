<?php
// auth_check.php - Combined authentication check and session validator

// Security headers (matching your login page)
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');
header('X-XSS-Protection: 1; mode=block');
header('Referrer-Policy: strict-origin-when-cross-origin');

// Start session with secure parameters if not already started
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
}

// Check if this is an AJAX session validation request
$isAjaxRequest = isset($_SERVER['HTTP_X_REQUESTED_WITH']) && 
                strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest';

if ($isAjaxRequest) {
    // AJAX request - act as session validator
    header('Content-Type: application/json');
    header('Cache-Control: no-cache, no-store, must-revalidate');
    header('Pragma: no-cache');
    header('Expires: 0');
    
    $response = ['valid' => false];
    
    // Check if user is authenticated (matching your login page checks)
    if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token']) || !isset($_SESSION['login_identifier'])) {
        echo json_encode($response);
        exit();
    }
    
    require_once 'config.php';
    
    $mysqli = getConnection();
    $user_id = (int)$_SESSION['user_id'];
    $token = $_SESSION['session_token'];
    $current_login_identifier = $_SESSION['login_identifier'];
    
    // Quick check for session validity (matching your login page logic)
    $stmt = $mysqli->prepare("SELECT session_token, login_identifier, last_activity, is_active FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    
    if ($user && 
        $user['session_token'] === $token && 
        $user['login_identifier'] === $current_login_identifier &&
        $user['is_active'] == 1) {
        
        $response['valid'] = true;
        
        // Update last activity for this check
        $update_stmt = $mysqli->prepare("UPDATE users SET last_activity = NOW() WHERE id = ?");
        $update_stmt->bind_param("i", $user_id);
        $update_stmt->execute();
        
        // Update session timestamp
        $_SESSION['last_activity'] = time();
    }
    
    echo json_encode($response);
    exit();
}

// ============================================================================
// REGULAR PAGE REQUEST - NORMAL AUTHENTICATION CHECK
// ============================================================================

// Initialize CSRF token if not exists
if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Check if user is authenticated (matching your login page checks)
if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token']) || !isset($_SESSION['login_identifier']) || !isset($_SESSION['ip_address'])) {
    // Log the security event
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('session_validation_failed', $_SESSION['user_id'] ?? 0, 'missing_session_data');
    }
    session_destroy();
    header('Location: login.php?error=' . urlencode('Session expired. Please log in again.'));
    exit();
}

require_once 'config.php';

$mysqli = getConnection();
$user_id = (int)$_SESSION['user_id'];
$token = $_SESSION['session_token'];
$current_login_identifier = $_SESSION['login_identifier'];

// Use prepared statement to get current session data
$stmt = $mysqli->prepare("SELECT session_token, last_activity, is_active, login_identifier FROM users WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

// Validate user exists
if (!$user) {
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('user_not_found', $user_id);
    }
    session_destroy();
    header('Location: login.php?error=' . urlencode('Account not found.'));
    exit();
}

// Validate session token matches
if ($user['session_token'] !== $token) {
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('session_token_mismatch', $user_id);
    }
    
    // Clear the session token in database
    $clear_stmt = $mysqli->prepare("UPDATE users SET session_token = NULL, login_identifier = NULL WHERE id = ?");
    $clear_stmt->bind_param("i", $user_id);
    $clear_stmt->execute();
    
    session_destroy();
    header('Location: login.php?error=' . urlencode('Your session was terminated because you logged in from another device or tab.'));
    exit();
}

// Check if login identifier matches (detects new tab/device login)
if ($user['login_identifier'] !== $current_login_identifier) {
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('login_identifier_mismatch', $user_id);
    }
    
    // This session is from a previous tab/device that was invalidated
    $clear_stmt = $mysqli->prepare("UPDATE users SET session_token = NULL, login_identifier = NULL WHERE id = ?");
    $clear_stmt->bind_param("i", $user_id);
    $clear_stmt->execute();
    
    session_destroy();
    header('Location: login.php?error=' . urlencode('Your session was terminated because you logged in from another device or tab.'));
    exit();
}

// Check if user account is active
if (isset($user['is_active']) && !$user['is_active']) {
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('account_inactive_access_attempt', $user_id);
    }
    session_destroy();
    header('Location: login.php?error=' . urlencode('Your account has been deactivated.'));
    exit();
}

// Enforce 15-minute timeout - FIXED: Use session last_activity instead of database
$inactive_time = 900; // 15 minutes in seconds
$last_activity = $_SESSION['last_activity'] ?? 0;

if (time() - $last_activity > $inactive_time) {
    if (function_exists('logSecurityEvent')) {
        logSecurityEvent('session_timeout', $user_id);
    }
    
    $update_stmt = $mysqli->prepare("UPDATE users SET session_token = NULL, login_identifier = NULL WHERE id = ?");
    $update_stmt->bind_param("i", $user_id);
    $update_stmt->execute();
    
    session_destroy();
    header('Location: login.php?error=' . urlencode('You have been logged out due to inactivity.'));
    exit();
}

// Update last activity timestamp in database
$update_activity_stmt = $mysqli->prepare("UPDATE users SET last_activity = NOW() WHERE id = ?");
$update_activity_stmt->bind_param("i", $user_id);
$update_activity_stmt->execute();

// Update session timestamp and track activity for rate limiting
$_SESSION['last_activity'] = time();
$_SESSION['request_count'] = ($_SESSION['request_count'] ?? 0) + 1;
$_SESSION['last_request'] = time();

// Store current session state for client-side checking
$_SESSION['session_valid'] = true;

// Security logging function (if not defined by calling script)
if (!function_exists('logSecurityEvent')) {
    function logSecurityEvent($event_type, $user_id = 0, $details = '') {
        global $mysqli;
        
        $ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
        $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $details = json_encode([
            'script' => $_SERVER['PHP_SELF'] ?? '',
            'referrer' => $_SERVER['HTTP_REFERER'] ?? '',
            'additional_info' => $details
        ]);
        
        try {
            $stmt = $mysqli->prepare("INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details) VALUES (?, ?, ?, ?, ?)");
            $user_id = $user_id ?: NULL;
            $stmt->bind_param("issss", $user_id, $event_type, $ip_address, $user_agent, $details);
            $stmt->execute();
        } catch (Exception $e) {
            error_log("Security Event: $event_type - User: $user_id - IP: $ip_address");
        }
    }
}
?>