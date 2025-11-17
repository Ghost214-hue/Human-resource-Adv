<?php
class AuditLogger {
    private $conn;
    private $user_id;
    private $username;
    private $user_role;

    public function __construct($db_connection) {
        $this->conn = $db_connection;
        $this->initializeUserInfo();
    }

    private function initializeUserInfo() {
        // Session is already started in config.php
        $this->user_id = $_SESSION['user_id'] ?? 0;
        $this->username = $_SESSION['username'] ?? 'system';
        $this->user_role = $_SESSION['user_role'] ?? 'guest';
    }

  public function log($action_type, $description, $details = []) {
    try {
        $ip_address = $this->getClientIP();
        $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        $url = $this->getCurrentUrl();
        $method = $_SERVER['REQUEST_METHOD'] ?? 'CLI';

        // Prepare values for binding (moved BEFORE bind_param)
        $table_name = $details['table_name'] ?? null;
        $record_id = $details['record_id'] ?? null;
        $old_values = isset($details['old_values']) ? json_encode($details['old_values']) : null;
        $new_values = isset($details['new_values']) ? json_encode($details['new_values']) : null;
        $session_id = session_id();

        $query = "INSERT INTO audit_logs 
                 (user_id, username, user_role, action_type, table_name, record_id, 
                  old_values, new_values, description, ip_address, user_agent, url, method, session_id) 
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        $stmt = $this->conn->prepare($query);
        
        // Bind parameters (now all args are variables)
        $stmt->bind_param(
            "issssissssssss",
            $this->user_id,
            $this->username,
            $this->user_role,
            $action_type,
            $table_name,
            $record_id,
            $old_values,
            $new_values,
            $description,
            $ip_address,
            $user_agent,
            $url,
            $method,
            $session_id
        );

        $stmt->execute();
        $log_id = $stmt->insert_id;
        $stmt->close();

        return $log_id;
    } catch (Exception $e) {
        error_log("Audit log error: " . $e->getMessage());
        return false;
    }
}
    private function getClientIP() {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            return $_SERVER['HTTP_CLIENT_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            return $_SERVER['HTTP_X_FORWARDED_FOR'];
        } else {
            return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        }
    }

    private function getCurrentUrl() {
        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? "https" : "http";
        $host = $_SERVER['HTTP_HOST'] ?? 'localhost';
        $uri = $_SERVER['REQUEST_URI'] ?? '';
        return $protocol . "://" . $host . $uri;
    }

    // Specific log methods for common actions
    public function logLogin($username, $success = true) {
        return $this->log(
            $success ? 'LOGIN_SUCCESS' : 'LOGIN_FAILED',
            $success ? "User logged in successfully" : "Failed login attempt for user: $username",
            ['ip_address' => $this->getClientIP()]
        );
    }

    public function logLogout() {
        return $this->log(
            'LOGOUT',
            "User logged out"
        );
    }

    public function logCreate($table_name, $record_id, $new_data, $description = "") {
        return $this->log(
            'CREATE',
            $description ?: "Created new record in $table_name",
            [
                'table_name' => $table_name,
                'record_id' => $record_id,
                'new_values' => $new_data
            ]
        );
    }

    public function logUpdate($table_name, $record_id, $old_data, $new_data, $description = "") {
        return $this->log(
            'UPDATE',
            $description ?: "Updated record in $table_name",
            [
                'table_name' => $table_name,
                'record_id' => $record_id,
                'old_values' => $old_data,
                'new_values' => $new_data
            ]
        );
    }

    public function logDelete($table_name, $record_id, $old_data, $description = "") {
        return $this->log(
            'DELETE',
            $description ?: "Deleted record from $table_name",
            [
                'table_name' => $table_name,
                'record_id' => $record_id,
                'old_values' => $old_data
            ]
        );
    }

    public function logView($table_name, $record_id = null, $description = "") {
        return $this->log(
            'VIEW',
            $description ?: "Viewed $table_name" . ($record_id ? " record #$record_id" : ""),
            [
                'table_name' => $table_name,
                'record_id' => $record_id
            ]
        );
    }

    public function logExport($table_name, $filters = [], $description = "") {
        return $this->log(
            'EXPORT',
            $description ?: "Exported data from $table_name",
            [
                'table_name' => $table_name,
                'new_values' => $filters
            ]
        );
    }

    public function logSearch($table_name, $search_terms, $description = "") {
        return $this->log(
            'SEARCH',
            $description ?: "Searched in $table_name",
            [
                'table_name' => $table_name,
                'new_values' => ['search_terms' => $search_terms]
            ]
        );
    }
}
?>