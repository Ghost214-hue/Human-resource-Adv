<?php
/**
 * Authentication and Authorization Utilities
 * 
 * Centralized permission checking using role hierarchy.
 * Include this file on any page that needs access control.
 */

// Prevent direct access
if (basename($_SERVER['SCRIPT_NAME']) === basename(__FILE__)) {
    http_response_code(403);
    exit('Direct access forbidden.');
}

// Ensure session is active
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/**
 * Check if the current user has the required role or higher
 *
 * @param string $requiredRole The minimum role needed (e.g., 'hr_manager')
 * @return bool True if user has sufficient privileges
 */
function hasPermission($requiredRole) {
    // Build user context from session
    $user = [
        'role' => $_SESSION['user_role'] ?? 'employee'
    ];

    // Role hierarchy: higher number = more privileges
    $role_hierarchy = [
        
        'super_admin'         => 8,
        'hr_manager'          => 7,
         'bod_chair'          => 6,
        'managing_director'   => 5,
        'dept_head'           => 4,
        'manager'             => 3,
        'section_head'        => 2,
        'sub_section_head'    => 1,
        'employee'            => 0
    ];

    $user_level = $role_hierarchy[$user['role']] ?? 0;
    $required_level = $role_hierarchy[$requiredRole] ?? 0;

    return $user_level >= $required_level;
}
// Add this function to auth.php
function hasAppraisalAccess($role) {
    return in_array($role, ['hr_manager', 'super_admin', 'manager', 'managing_director', 'section_head', 'dept_head', 'sub_section_head']);
}