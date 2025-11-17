<?php
// logout.php — secure logout script

// 🛡️ Security headers
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once 'config.php';
 // Make sure this file exists and defines the AuditLogger class

// 🧩 Function to record security events
function logSecurityEvent($event_type, $user_id = 0, $email = '') {
    $mysqli = getConnection();

    $ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
    $details = json_encode([
        'script'   => $_SERVER['PHP_SELF'] ?? '',
        'referrer' => $_SERVER['HTTP_REFERER'] ?? '',
        'email'    => $email
    ]);

    try {
        $stmt = $mysqli->prepare("
            INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details) 
            VALUES (?, ?, ?, ?, ?)
        ");
        $user_id = $user_id ?: NULL;
        $stmt->bind_param("issss", $user_id, $event_type, $ip_address, $user_agent, $details);
        $stmt->execute();
    } catch (Exception $e) {
        error_log("Security Event Error: $event_type - User: $user_id - Email: $email - IP: $ip_address");
    }
}

// 🧑‍💻 Log user logout event and clear tokens
if (isset($_SESSION['user_id'])) {
    $mysqli = getConnection();
    $user_id = (int)$_SESSION['user_id'];

    // Log logout in security log
    logSecurityEvent('logout', $user_id);

    // 🧾 Audit log entry
    try {
        $conn = getConnection(); // use the same connection function
        $auditLogger = new AuditLogger($conn);
        $auditLogger->logLogout($user_id);
    } catch (Exception $e) {
        error_log("AuditLogger Error during logout: " . $e->getMessage());
    }

    // Clear session-related data in DB
    $stmt = $mysqli->prepare("
        UPDATE users 
        SET session_token = NULL, login_identifier = NULL 
        WHERE id = ?
    ");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
}

// 🧹 Clear all session data
session_unset();
session_destroy();

// 🧽 Delete session cookie
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 3600, $params["path"], $params["domain"], $params["secure"], $params["httponly"]);
}

// 🚪 Redirect back to login page
header('Location: login.php?message=' . urlencode('You have been successfully logged out.'));
exit();
?>
