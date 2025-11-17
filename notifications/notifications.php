<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set headers first to prevent any output before JSON
header('Access-Control-Allow-Origin: ' . ($_SERVER['HTTP_ORIGIN'] ?? '*'));
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Start session after headers
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Check if user is logged in
$userId = $_SESSION['user_id'] ?? null;
if (!$userId) {
    echo json_encode(['success' => false, 'error' => 'Unauthorized - No user session']);
    exit;
}

try {
    // Include files with error handling
    $configPath = __DIR__ . '/../config.php';
    $servicePath = __DIR__ . '/NotificationService.php';
    
    if (!file_exists($configPath)) {
        throw new Exception('config.php not found at: ' . $configPath);
    }
    if (!file_exists($servicePath)) {
        throw new Exception('NotificationService.php not found at: ' . $servicePath);
    }
    
    require_once $configPath;
    require_once $servicePath;
    
    // Check if $conn exists and is a MySQLi object
    if (!isset($conn) || !($conn instanceof mysqli)) {
        throw new Exception('Database connection ($conn) not established or not a MySQLi object');
    }
    
    $notificationService = new NotificationService($conn);
    $action = $_GET['action'] ?? '';
    
    switch ($action) {
        case 'get_notifications':
            $limit = min($_GET['limit'] ?? 20, 50);
            $unreadOnly = isset($_GET['unread_only']) && $_GET['unread_only'] === 'true';
            
            $notifications = $notificationService->getUserNotifications($userId, $limit, $unreadOnly);
            $unreadCount = $notificationService->getUnreadCount($userId);
            
            echo json_encode([
                'success' => true,
                'notifications' => $notifications,
                'unreadCount' => $unreadCount,
                'total' => count($notifications)
            ]);
            break;
            
        case 'get_count':
            $unreadCount = $notificationService->getUnreadCount($userId);
            echo json_encode([
                'success' => true, 
                'unreadCount' => $unreadCount,
                'hasUnread' => $unreadCount > 0
            ]);
            break;
            
        case 'mark_as_read':
            $notificationId = $_POST['notification_id'] ?? null;
            if ($notificationId && is_numeric($notificationId)) {
                $success = $notificationService->markAsRead($notificationId, $userId);
                $unreadCount = $notificationService->getUnreadCount($userId);
                echo json_encode([
                    'success' => $success,
                    'unreadCount' => $unreadCount
                ]);
            } else {
                echo json_encode(['success' => false, 'error' => 'Invalid notification ID']);
            }
            break;
            
        case 'mark_all_read':
            $success = $notificationService->markAllAsRead($userId);
            echo json_encode([
                'success' => $success,
                'unreadCount' => 0
            ]);
            break;
            
        default:
            echo json_encode(['success' => false, 'error' => 'Invalid action: ' . $action]);
    }
    
} catch (Exception $e) {
    // Log the error and return JSON response
    error_log("Notification API Error: " . $e->getMessage());
    echo json_encode([
        'success' => false, 
        'error' => 'Internal server error',
        'debug_info' => [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ]
    ]);
}
?>