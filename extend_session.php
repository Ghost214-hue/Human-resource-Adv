<?php
// extend_session.php
// Start session with secure parameters (matching your login page)
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

require_once 'config.php';

if (!isset($_SESSION['user_id']) || !isset($_SESSION['session_token'])) {
    http_response_code(401);
    echo json_encode(['valid' => false, 'error' => 'Not authenticated']);
    exit();
}

$conn = getConnection();
$user_id = $_SESSION['user_id'];

try {
    // Verify the session token first (matching your login page security)
    $stmt = $conn->prepare("SELECT session_token, is_active FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();
    
    if (!$user || $user['session_token'] !== $_SESSION['session_token'] || !$user['is_active']) {
        http_response_code(401);
        echo json_encode(['valid' => false, 'error' => 'Invalid session']);
        exit();
    }

    // Update last activity
    $update_stmt = $conn->prepare("UPDATE users SET last_activity = NOW() WHERE id = ?");
    $update_stmt->bind_param("i", $user_id);
    $update_stmt->execute();
    
    // Update session timestamp
    $_SESSION['last_activity'] = time();
    
    echo json_encode(['valid' => true]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['valid' => false, 'error' => $e->getMessage()]);
}
?>