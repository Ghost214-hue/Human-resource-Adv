<?php
class NotificationService {
    private $db;
    private $templates = [];
    
    public function __construct($db) {
        $this->db = $db;
        $this->loadTemplates();
    }
    
    private function loadTemplates() {
        $sql = "SELECT * FROM notification_templates WHERE is_active = 1";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $result = $stmt->get_result();
        
        while ($template = $result->fetch_assoc()) {
            $this->templates[$template['name']] = $template;
        }
        $stmt->close();
    }
    
    /**
     * Main method to trigger notifications from any page
     */
    public function triggerNotification($templateName, $data = [], $specificUsers = []) {
        if (!isset($this->templates[$templateName])) {
            error_log("Notification template '$templateName' not found. Available: " . implode(', ', array_keys($this->templates)));
            return false;
        }
        
        $template = $this->templates[$templateName];
        $users = $this->resolveTargetUsers($template, $data, $specificUsers);
        
        $createdCount = 0;
        foreach ($users as $user) {
            if ($this->createNotificationForUser($user, $template, $data)) {
                $createdCount++;
            }
        }
        
        return $createdCount;
    }
    
    private function resolveTargetUsers($template, $data, $specificUsers) {
        // If specific users provided, use them
        if (!empty($specificUsers)) {
            return $this->getUsersByIds($specificUsers);
        }
        
        // If template has role targets, use them
        if (!empty($template['roles_target'])) {
            $roles = json_decode($template['roles_target'], true);
            if (json_last_error() === JSON_ERROR_NONE) {
                return $this->getUsersByRoles($roles);
            }
        }
        
        // Default: get from data or system context
        return $this->getUsersFromData($template, $data);
    }
    
    private function createNotificationForUser($user, $template, $data) {
        try {
            // Merge user data into template data
            $mergedData = array_merge($data, [
                'user_name' => $user['first_name'] . ' ' . $user['last_name'],
                'user_email' => $user['email']
            ]);
            
            // Check user preferences
            if (!$this->isNotificationEnabled($user['id'], $template['category'])) {
                return false;
            }
            
            $title = $this->renderTemplate($template['title_template'], $mergedData);
            $message = $this->renderTemplate($template['message_template'], $mergedData);
            $actionUrl = $template['action_url_template'] ? 
                $this->renderTemplate($template['action_url_template'], $mergedData) : null;
            
            // Calculate expiration
            $expiresAt = $template['expires_after_days'] ? 
                date('Y-m-d H:i:s', strtotime('+' . $template['expires_after_days'] . ' days')) : null;
            
            $sql = "INSERT INTO notifications 
                    (user_id, title, message, type, category, trigger_source, priority, 
                     related_entity, related_id, action_url, expires_at, created_at) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param(
                "issssssisss", 
                $user['id'],
                $title,
                $message,
                $template['type'],
                $template['category'],
                $template['trigger_source'],
                $template['default_priority'],
                $data['related_entity'] ?? null,
                $data['related_id'] ?? null,
                $actionUrl,
                $expiresAt
            );
            
            $result = $stmt->execute();
            $stmt->close();
            
            return $result;
        } catch (Exception $e) {
            error_log("Notification creation error: " . $e->getMessage());
            return false;
        }
    }
    
    private function renderTemplate($template, $data) {
        foreach ($data as $key => $value) {
            if (is_string($value)) {
                $template = str_replace('{' . $key . '}', $value, $template);
            }
        }
        return $template;
    }
    
    private function getUsersByIds($userIds) {
        if (empty($userIds)) return [];
        
        try {
            $placeholders = str_repeat('?,', count($userIds) - 1) . '?';
            $sql = "SELECT id, first_name, last_name, email, role FROM users 
                    WHERE id IN ($placeholders) AND status = 'active'";
            $stmt = $this->db->prepare($sql);
            
            // Bind parameters dynamically
            $types = str_repeat('i', count($userIds));
            $stmt->bind_param($types, ...$userIds);
            $stmt->execute();
            $result = $stmt->get_result();
            
            $users = [];
            while ($user = $result->fetch_assoc()) {
                $users[] = $user;
            }
            $stmt->close();
            
            return $users;
        } catch (Exception $e) {
            error_log("getUsersByIds error: " . $e->getMessage());
            return [];
        }
    }
    
    private function getUsersByRoles($roles) {
        if (empty($roles)) return [];
        
        try {
            $placeholders = str_repeat('?,', count($roles) - 1) . '?';
            $sql = "SELECT id, first_name, last_name, email, role FROM users 
                    WHERE role IN ($placeholders) AND status = 'active'";
            $stmt = $this->db->prepare($sql);
            
            // Bind parameters dynamically
            $types = str_repeat('s', count($roles));
            $stmt->bind_param($types, ...$roles);
            $stmt->execute();
            $result = $stmt->get_result();
            
            $users = [];
            while ($user = $result->fetch_assoc()) {
                $users[] = $user;
            }
            $stmt->close();
            
            return $users;
        } catch (Exception $e) {
            error_log("getUsersByRoles error: " . $e->getMessage());
            return [];
        }
    }
    
    private function getUsersFromData($template, $data) {
        if (isset($data['user_id'])) {
            return $this->getUsersByIds([$data['user_id']]);
        }
        return [];
    }
    
    private function isNotificationEnabled($userId, $category) {
        try {
            $sql = "SELECT enabled FROM user_notification_preferences 
                    WHERE user_id = ? AND category = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("is", $userId, $category);
            $stmt->execute();
            $result = $stmt->get_result();
            $pref = $result->fetch_assoc();
            $stmt->close();
            
            return $pref ? (bool)$pref['enabled'] : true;
        } catch (Exception $e) {
            error_log("isNotificationEnabled error: " . $e->getMessage());
            return true; // Default to enabled if there's an error
        }
    }
    
    /**
     * Get notifications for a user
     */
    public function getUserNotifications($userId, $limit = 50, $unreadOnly = false) {
        try {
            $sql = "SELECT * FROM notifications 
                    WHERE user_id = ? 
                    AND (expires_at IS NULL OR expires_at > NOW())";
            
            if ($unreadOnly) {
                $sql .= " AND is_read = 0";
            }
            
            $sql .= " ORDER BY 
                        CASE priority 
                            WHEN 'urgent' THEN 1
                            WHEN 'high' THEN 2
                            WHEN 'medium' THEN 3
                            WHEN 'low' THEN 4
                        END,
                        created_at DESC 
                    LIMIT ?";
            
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("ii", $userId, $limit);
            $stmt->execute();
            $result = $stmt->get_result();
            
            $notifications = [];
            while ($notification = $result->fetch_assoc()) {
                $notifications[] = $notification;
            }
            $stmt->close();
            
            return $notifications;
        } catch (Exception $e) {
            error_log("getUserNotifications error: " . $e->getMessage());
            return [];
        }
    }
    
    /**
     * Get unread count for a user
     */
    public function getUnreadCount($userId) {
        try {
            $sql = "SELECT COUNT(*) as count FROM notifications 
                    WHERE user_id = ? AND is_read = 0 
                    AND (expires_at IS NULL OR expires_at > NOW())";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("i", $userId);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();
            $stmt->close();
            
            return $row['count'] ?? 0;
        } catch (Exception $e) {
            error_log("getUnreadCount error: " . $e->getMessage());
            return 0;
        }
    }
    
    /**
     * Mark notification as read
     */
    public function markAsRead($notificationId, $userId) {
        try {
            $sql = "UPDATE notifications SET is_read = 1, updated_at = NOW()
                    WHERE id = ? AND user_id = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("ii", $notificationId, $userId);
            $result = $stmt->execute();
            $stmt->close();
            
            return $result;
        } catch (Exception $e) {
            error_log("markAsRead error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Mark all notifications as read for a user
     */
    public function markAllAsRead($userId) {
        try {
            $sql = "UPDATE notifications SET is_read = 1, updated_at = NOW()
                    WHERE user_id = ? AND is_read = 0";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("i", $userId);
            $result = $stmt->execute();
            $stmt->close();
            
            return $result;
        } catch (Exception $e) {
            error_log("markAllAsRead error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Quick method to check if user has notifications
     */
    public function hasUnreadNotifications($userId) {
        return $this->getUnreadCount($userId) > 0;
    }
    
    // ============================
    // TIME-BASED NOTIFICATION METHODS
    // ============================
    
    /**
     * Check and trigger all scheduled notifications
     */
    public function checkScheduledNotifications() {
        $this->triggerFinancialYearNotification();
        $this->triggerAppraisalCycleNotifications();
        $this->triggerPasswordExpiryNotifications();
        $this->triggerQuarterlyReportsNotification();
    }
    
    /**
     * Financial Year Reminder - Every July
     */
    private function triggerFinancialYearNotification() {
        $currentMonth = date('n'); // July = 7
        if ($currentMonth == 7) {
            $currentYear = date('Y');
            
            try {
                $sql = "SELECT COUNT(*) as count FROM notifications 
                        WHERE type = 'financial_year_reminder' 
                        AND YEAR(created_at) = ?";
                $stmt = $this->db->prepare($sql);
                $stmt->bind_param("i", $currentYear);
                $stmt->execute();
                $result = $stmt->get_result();
                $row = $result->fetch_assoc();
                $stmt->close();
                
                if ($row['count'] == 0) {
                    $this->triggerNotification('financial_year_reminder', [
                        'year' => $currentYear,
                        'next_year' => $currentYear + 1
                    ]);
                }
            } catch (Exception $e) {
                error_log("Financial year notification error: " . $e->getMessage());
            }
        }
    }
    
    /**
     * Quarterly Appraisal Cycles
     */
    private function triggerAppraisalCycleNotifications() {
        $quarter = ceil(date('n') / 3); // Get current quarter (1-4)
        $currentYear = date('Y');
        
        $quarters = [
            1 => ['name' => 'Q1', 'months' => 'January - March'],
            2 => ['name' => 'Q2', 'months' => 'April - June'],
            3 => ['name' => 'Q3', 'months' => 'July - September'],
            4 => ['name' => 'Q4', 'months' => 'October - December']
        ];
        
        try {
            // Check if we already notified for this quarter
            $relatedEntity = 'quarter_' . $quarter;
            $sql = "SELECT COUNT(*) as count FROM notifications 
                    WHERE type = 'appraisal_cycle_reminder' 
                    AND YEAR(created_at) = ? 
                    AND related_entity = ?";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("is", $currentYear, $relatedEntity);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();
            $stmt->close();
            
            if ($row['count'] == 0) {
                $this->triggerNotification('appraisal_cycle_reminder', [
                    'quarter' => $quarters[$quarter]['name'],
                    'quarter_name' => $quarters[$quarter]['name'],
                    'quarter_months' => $quarters[$quarter]['months'],
                    'year' => $currentYear,
                    'related_entity' => 'quarter',
                    'related_id' => $quarter
                ]);
            }
        } catch (Exception $e) {
            error_log("Appraisal cycle notification error: " . $e->getMessage());
        }
    }
    
    /**
     * Password expiry notifications (30 days before expiry)
     */
    private function triggerPasswordExpiryNotifications() {
        $expiryDate = date('Y-m-d', strtotime('+30 days'));
        
        try {
            $sql = "SELECT id, first_name, last_name, email, password_expiry_date 
                    FROM users 
                    WHERE password_expiry_date = ? 
                    AND status = 'active'";
            $stmt = $this->db->prepare($sql);
            $stmt->bind_param("s", $expiryDate);
            $stmt->execute();
            $result = $stmt->get_result();
            $users = [];
            while ($user = $result->fetch_assoc()) {
                $users[] = $user;
            }
            $stmt->close();
            
            foreach ($users as $user) {
                $this->triggerNotification('password_expiry_reminder', [
                    'user_id' => $user['id'],
                    'user_name' => $user['first_name'] . ' ' . $user['last_name'],
                    'expiry_date' => date('F j, Y', strtotime($user['password_expiry_date'])),
                    'days_remaining' => 30
                ], [$user['id']]);
            }
        } catch (Exception $e) {
            error_log("Password expiry notification error: " . $e->getMessage());
        }
    }
    
    /**
     * Quarterly Reports Reminder
     */
    private function triggerQuarterlyReportsNotification() {
        $currentMonth = date('n');
        $currentYear = date('Y');
        
        // Trigger at end of each quarter (March, June, September, December)
        $quarterEndMonths = [3, 6, 9, 12];
        
        if (in_array($currentMonth, $quarterEndMonths)) {
            $quarter = ceil($currentMonth / 3);
            
            try {
                // Check if already notified this quarter
                $relatedEntity = 'quarter_' . $quarter;
                $sql = "SELECT COUNT(*) as count FROM notifications 
                        WHERE type = 'quarterly_reports_reminder' 
                        AND YEAR(created_at) = ? 
                        AND related_entity = ?";
                $stmt = $this->db->prepare($sql);
                $stmt->bind_param("is", $currentYear, $relatedEntity);
                $stmt->execute();
                $result = $stmt->get_result();
                $row = $result->fetch_assoc();
                $stmt->close();
                
                if ($row['count'] == 0) {
                    $this->triggerNotification('quarterly_reports_reminder', [
                        'quarter' => 'Q' . $quarter,
                        'year' => $currentYear,
                        'month' => date('F'),
                        'related_entity' => 'quarter',
                        'related_id' => $quarter
                    ]);
                }
            } catch (Exception $e) {
                error_log("Quarterly reports notification error: " . $e->getMessage());
            }
        }
    }
    
    // ============================
    // ACTION-BASED NOTIFICATION METHODS
    // ============================
    
    /**
     * Leave Application - Notify managers
     */
    public function triggerLeaveApplicationNotification($leaveData, $approverIds) {
        return $this->triggerNotification('leave_application', [
            'leave_id' => $leaveData['id'],
            'employee_name' => $leaveData['employee_name'],
            'leave_type' => $leaveData['leave_type'],
            'start_date' => $leaveData['start_date'],
            'end_date' => $leaveData['end_date'],
            'days' => $leaveData['days'],
            'applied_date' => $leaveData['applied_date'],
            'related_entity' => 'leave',
            'related_id' => $leaveData['id']
        ], $approverIds);
    }
    
    /**
     * Leave Approval/Rejection - Notify employee
     */
    public function triggerLeaveStatusNotification($leaveData, $status) {
        return $this->triggerNotification('leave_status', [
            'leave_id' => $leaveData['id'],
            'employee_name' => $leaveData['employee_name'],
            'leave_type' => $leaveData['leave_type'],
            'start_date' => $leaveData['start_date'],
            'end_date' => $leaveData['end_date'],
            'status' => $status,
            'approved_by' => $leaveData['approved_by'] ?? 'System',
            'comments' => $leaveData['comments'] ?? '',
            'related_entity' => 'leave',
            'related_id' => $leaveData['id']
        ], [$leaveData['user_id']]);
    }
    
    /**
     * Appraisal Assigned - Notify employee
     */
    public function triggerAppraisalAssignedNotification($appraisalData) {
        return $this->triggerNotification('appraisal_assigned', [
            'appraisal_id' => $appraisalData['id'],
            'employee_name' => $appraisalData['employee_name'],
            'appraisal_period' => $appraisalData['period'],
            'due_date' => $appraisalData['due_date'],
            'assigned_by' => $appraisalData['assigned_by'],
            'related_entity' => 'appraisal',
            'related_id' => $appraisalData['id']
        ], [$appraisalData['user_id']]);
    }
    
    /**
     * Appraisal Completed - Notify manager
     */
    public function triggerAppraisalCompletedNotification($appraisalData, $managerIds) {
        return $this->triggerNotification('appraisal_completed', [
            'appraisal_id' => $appraisalData['id'],
            'employee_name' => $appraisalData['employee_name'],
            'appraisal_period' => $appraisalData['period'],
            'completed_by' => $appraisalData['completed_by'],
            'score' => $appraisalData['score'] ?? '',
            'related_entity' => 'appraisal',
            'related_id' => $appraisalData['id']
        ], $managerIds);
    }
    
    /**
     * Task Assigned - Notify assignee
     */
    public function triggerTaskAssignedNotification($taskData, $assigneeIds) {
        return $this->triggerNotification('task_assigned', [
            'task_id' => $taskData['id'],
            'task_title' => $taskData['title'],
            'due_date' => $taskData['due_date'],
            'assigned_by' => $taskData['assigned_by'],
            'priority' => $taskData['priority'] ?? 'medium',
            'related_entity' => 'task',
            'related_id' => $taskData['id']
        ], $assigneeIds);
    }
    
    /**
     * Task Reminder - Notify about upcoming deadlines
     */
    public function triggerTaskReminderNotification($taskData, $assigneeIds) {
        return $this->triggerNotification('task_reminder', [
            'task_id' => $taskData['id'],
            'task_title' => $taskData['title'],
            'due_date' => $taskData['due_date'],
            'days_remaining' => $taskData['days_remaining'],
            'related_entity' => 'task',
            'related_id' => $taskData['id']
        ], $assigneeIds);
    }
    
    /**
     * Profile Update Required - Notify user
     */
    public function triggerProfileUpdateNotification($userData, $updateReason) {
        return $this->triggerNotification('profile_update', [
            'user_name' => $userData['first_name'] . ' ' . $userData['last_name'],
            'update_reason' => $updateReason,
            'required_by' => date('Y-m-d', strtotime('+7 days')),
            'related_entity' => 'user',
            'related_id' => $userData['id']
        ], [$userData['id']]);
    }
}
?>