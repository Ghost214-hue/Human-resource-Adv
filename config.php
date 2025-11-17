<?php 
// config.php

// Start session if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

function getConnection() {
    $servername = "localhost";
    $username = "root"; 
    $password = "";
    $dbname = "hrmuwasco";

    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); 
    $conn = new mysqli($servername, $username, $password, $dbname);
    
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    
    $conn->set_charset("utf8mb4");
    return $conn;
}

// Get database connection
$conn = getConnection();

// Include audit logger
require_once 'audit_logs.php';

// Initialize audit logger with MySQLi connection
$auditLogger = new AuditLogger($conn);

// Auto-log page views and important actions
function trackAction($action, $description, $details = []) {
    global $auditLogger;
    return $auditLogger->log($action, $description, $details);
}

// Example integration in employee management (using MySQLi)
function updateEmployee($employee_id, $data) {
    global $conn, $auditLogger;
    
    // Get old data
    $stmt = $conn->prepare("SELECT * FROM employees WHERE id = ?");
    $stmt->bind_param("i", $employee_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $old_data = $result->fetch_assoc();
    $stmt->close();
    
    // Update employee
    $stmt = $conn->prepare("UPDATE employees SET name=?, email=?, department=?, position=? WHERE id=?");
    $stmt->bind_param("ssssi", $data['name'], $data['email'], $data['department'], $data['position'], $employee_id);
    $stmt->execute();
    $stmt->close();
    
    // Log the action
    $auditLogger->logUpdate(
        'employees', 
        $employee_id, 
        $old_data, 
        $data,
        "Updated employee: {$data['name']}"
    );
    
    return true;
}

function createEmployee($data) {
    global $conn, $auditLogger;
    
    $stmt = $conn->prepare("INSERT INTO employees (name, email, department, position) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $data['name'], $data['email'], $data['department'], $data['position']);
    $stmt->execute();
    $employee_id = $stmt->insert_id;
    $stmt->close();
    
    // Log the action
    $auditLogger->logCreate(
        'employees',
        $employee_id,
        $data,
        "Created new employee: {$data['name']}"
    );
    
    return $employee_id;
}

function deleteEmployee($employee_id) {
    global $conn, $auditLogger;
    
    // Get employee data before deletion
    $stmt = $conn->prepare("SELECT * FROM employees WHERE id = ?");
    $stmt->bind_param("i", $employee_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $old_data = $result->fetch_assoc();
    $stmt->close();
    
    // Delete employee
    $stmt = $conn->prepare("DELETE FROM employees WHERE id = ?");
    $stmt->bind_param("i", $employee_id);
    $stmt->execute();
    $stmt->close();
    
    // Log the action
    $auditLogger->logDelete(
        'employees',
        $employee_id,
        $old_data,
        "Deleted employee: {$old_data['name']}"
    );
    
    return true;
}

// Function to log page views automatically
function logPageView() {
    global $auditLogger;
    
    $page = basename($_SERVER['PHP_SELF']);
    $description = "Viewed page: $page";
    
    $auditLogger->log('PAGE_VIEW', $description, [
        'url' => $_SERVER['REQUEST_URI'],
        'method' => $_SERVER['REQUEST_METHOD']
    ]);
}

// Auto-log page views for all pages that include config.php
logPageView();

?>