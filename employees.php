<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
// After successful login verification in other pages
if (!isset($_SESSION['hr_system_user_id'])) {
    $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
    $_SESSION['hr_system_username'] = $_SESSION['user_name'];
    $_SESSION['hr_system_user_role'] = $_SESSION['user_role'];
}
require_once 'config.php';
require_once 'auth.php';
$conn = getConnection();

// Get current user
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// === HELPER FUNCTIONS ===

/**
 * Improved parameter binding with validation
 */
function bindParameters($stmt, $types, $params) {
    if (strlen($types) !== count($params)) {
        throw new Exception("Parameter count mismatch: types='$types', params=" . count($params));
    }
    $stmt->bind_param($types, ...$params);
}

/**
 * Returns the organizational scope for a leadership role.
 */
function getLeadershipScope($employee_type) {
    $scopes = [
        'managing_director' => 'organization',
        'dept_head'         => 'department',
        'section_head'      => 'section',
        'sub_section_head'  => 'subsection'
    ];
    return $scopes[$employee_type] ?? null;
}

/**
 * Validates that no other employee holds the same leadership role in the same scope.
 */
function validateLeadershipUniqueness($conn, $employee_type, $department_id = null, $section_id = null, $subsection_id = null, $exclude_id = null) {
    $scope = getLeadershipScope($employee_type);
    if (!$scope) return true; // Not a leadership role

    $sql = "SELECT id FROM employees WHERE employee_type = ?";
    $params = [$employee_type];
    $types = "s";

    if ($scope === 'department' && $department_id) {
        $sql .= " AND department_id = ?";
        $params[] = $department_id;
        $types .= "i";
    } elseif ($scope === 'section' && $section_id) {
        $sql .= " AND section_id = ?";
        $params[] = $section_id;
        $types .= "i";
    } elseif ($scope === 'subsection' && $subsection_id) {
        $sql .= " AND subsection_id = ?";
        $params[] = $subsection_id;
        $types .= "i";
    }

    if ($exclude_id) {
        $sql .= " AND id != ?";
        $params[] = $exclude_id;
        $types .= "i";
    }

    $stmt = $conn->prepare($sql);
    if (!$stmt) return false;
    
    bindParameters($stmt, $types, $params);
    $stmt->execute();
    return $stmt->get_result()->num_rows === 0;
}

function getEmployeeTypeBadge($type) {
    $badges = [
        'full_time' => 'badge-primary',
        'part_time' => 'badge-info',
        'contract' => 'badge-warning',
        'temporary' => 'badge-secondary',
        'officer' => 'badge-primary',
        'section_head' => 'badge-info',
        'manager' => 'badge-success',
        'hr_manager' => 'badge-success',
        'dept_head' => 'badge-info',
        'managing_director' => 'badge-primary',
        'bod_chairman' => 'badge-primary'
    ];
    return $badges[$type] ?? 'badge-light';
}

function getEmployeeStatusBadge($status) {
    $badges = [
        'active' => 'badge-success',
        'on_leave' => 'badge-warning',
        'terminated' => 'badge-danger',
        'resigned' => 'badge-secondary',
        'inactive' => 'badge-secondary',
        'fired' => 'badge-danger',
        'retired' => 'badge-secondary'
    ];
    return $badges[$status] ?? 'badge-light';
}

function getFlashMessage() {
    if (isset($_SESSION['flash_message'])) {
        $message = $_SESSION['flash_message'];
        $type = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);
        return ['message' => $message, 'type' => $type];
    }
    return false;
}

function redirectWithMessage($url, $message, $type = 'info') {
    $_SESSION['flash_message'] = $message;
    $_SESSION['flash_type'] = $type;
    header("Location: $url");
    exit();
}

function sanitizeInput($data) {
    if ($data === null) return '';
    return htmlspecialchars(stripslashes(trim($data)), ENT_QUOTES, 'UTF-8');
}

function prepareNextOfKin($post_data) {
    $next_of_kin_array = [];
    $nok_count = count($post_data['next_of_kin_name'] ?? []);
    
    for ($i = 0; $i < $nok_count; $i++) {
        $name = sanitizeInput($post_data['next_of_kin_name'][$i] ?? '');
        $relationship = sanitizeInput($post_data['next_of_kin_relationship'][$i] ?? '');
        $contact = sanitizeInput($post_data['next_of_kin_contact'][$i] ?? '');
        
        if (!empty($name)) {
            $next_of_kin_array[] = [
                'name' => $name,
                'relationship' => $relationship,
                'contact' => $contact
            ];
        }
    }
    
    return json_encode($next_of_kin_array, JSON_UNESCAPED_UNICODE);
}

function getUserRoleFromEmployeeType($employee_type) {
    $role_mapping = [
        'managing_director' => 'managing_director',
        'bod_chairman' => 'bod_chairman',
        'super_admin' => 'super_admin',
        'dept_head' => 'dept_head',
        'hr_manager' => 'hr_manager',
        'manager' => 'manager',
        'section_head' => 'section_head',
        'sub_section_head' => 'sub_section_head'
    ];
    
    return $role_mapping[$employee_type] ?? 'employee';
}

// === DATA FETCHING ===

$departments = $conn->query("SELECT * FROM departments ORDER BY name")->fetch_all(MYSQLI_ASSOC);
$sections = $conn->query("
    SELECT s.*, d.name as department_name 
    FROM sections s 
    LEFT JOIN departments d ON s.department_id = d.id 
    ORDER BY d.name, s.name
")->fetch_all(MYSQLI_ASSOC);

$subsections = $conn->query("
    SELECT ss.*, s.name as section_name, d.name as department_name 
    FROM subsections ss 
    LEFT JOIN sections s ON ss.section_id = s.id 
    LEFT JOIN departments d ON ss.department_id = d.id 
    ORDER BY d.name, s.name, ss.name
")->fetch_all(MYSQLI_ASSOC);

// Employee filters & data (HR only)
$employees = [];
$search = $department_filter = $section_filter = $type_filter = $status_filter = '';
$total = 0;
$totalPages = 1;

if (hasPermission('hr_manager')) {
    $limit = 30;
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $offset = ($page - 1) * $limit;
    
    // Get filter parameters
    $search = sanitizeInput($_GET['search'] ?? '');
    $department_filter = sanitizeInput($_GET['department'] ?? '');
    $section_filter = sanitizeInput($_GET['section'] ?? '');
    $type_filter = sanitizeInput($_GET['type'] ?? '');
    $status_filter = sanitizeInput($_GET['status'] ?? '');

    $where_conditions = [];
    $params = [];
    $types = '';

    if (!empty($search)) {
        $where_conditions[] = "(e.first_name LIKE ? OR e.last_name LIKE ? OR e.employee_id LIKE ? OR e.email LIKE ?)";
        $search_param = "%$search%";
        $params = array_merge($params, [$search_param, $search_param, $search_param, $search_param]);
        $types .= 'ssss';
    }
    if (!empty($department_filter)) {
        $where_conditions[] = "e.department_id = ?";
        $params[] = $department_filter;
        $types .= 'i';
    }
    if (!empty($section_filter)) {
        $where_conditions[] = "e.section_id = ?";
        $params[] = $section_filter;
        $types .= 'i';
    }
    if (!empty($type_filter)) {
        $where_conditions[] = "e.employee_type = ?";
        $params[] = $type_filter;
        $types .= 's';
    }
    if (!empty($status_filter)) {
        $where_conditions[] = "e.employee_status = ?";
        $params[] = $status_filter;
        $types .= 's';
    }

    $where_clause = !empty($where_conditions) ? "WHERE " . implode(" AND ", $where_conditions) : "";

    // Count total records
    $countQuery = "SELECT COUNT(*) as total FROM employees e $where_clause";
    $countStmt = $conn->prepare($countQuery);
    if (!empty($params)) {
        bindParameters($countStmt, $types, $params);
    }
    $countStmt->execute();
    $total = $countStmt->get_result()->fetch_assoc()['total'];
    $totalPages = ceil($total / $limit);

    // Fetch employees
    $query = "
        SELECT e.*,
               COALESCE(e.first_name, '') as first_name,
               COALESCE(e.last_name, '') as last_name,
               d.name as department_name,
               s.name as section_name,
               ss.name as subsection_name
        FROM employees e
        LEFT JOIN departments d ON e.department_id = d.id
        LEFT JOIN sections s ON e.section_id = s.id
        LEFT JOIN subsections ss ON e.subsection_id = ss.id
        $where_clause
        ORDER BY e.created_at DESC
        LIMIT ? OFFSET ?
    ";
    
    $stmt = $conn->prepare($query);
    if (!$stmt) {
        die("Database error: " . $conn->error);
    }
    
    // Add limit and offset parameters
    $params[] = $limit;
    $params[] = $offset;
    $types .= 'ii';
    
    bindParameters($stmt, $types, $params);
    $stmt->execute();
    $result = $stmt->get_result();
    $employees = $result->fetch_all(MYSQLI_ASSOC);
}

$job_groups = ['1', '2', '3', '3A', '3B', '3C', '4', '5', '6', '7', '8', '9', '10'];

// === FORM PROCESSING ===

if ($_SERVER['REQUEST_METHOD'] === 'POST' && hasPermission('hr_manager')) {
    $action = sanitizeInput($_POST['action'] ?? '');
    
    try {
        if ($action === 'add') {
            // Sanitize and validate input
            $employee_id = sanitizeInput($_POST['employee_id']);
            $first_name = sanitizeInput($_POST['first_name']);
            $last_name = sanitizeInput($_POST['last_name']);
            $surname = sanitizeInput($_POST['surname'] ?? '');
            $gender = sanitizeInput($_POST['gender'] ?? '');
            $national_id = sanitizeInput($_POST['national_id']);
            $email = sanitizeInput($_POST['email']);
            $phone = sanitizeInput($_POST['phone']);
            $address = sanitizeInput($_POST['address']);
            $date_of_birth = $_POST['date_of_birth'];
            $hire_date = $_POST['hire_date'];
            $designation = sanitizeInput($_POST['designation']);
            $department_id = !empty($_POST['department_id']) ? (int)$_POST['department_id'] : null;
            $section_id = !empty($_POST['section_id']) ? (int)$_POST['section_id'] : null;
            $subsection_id = !empty($_POST['subsection_id']) ? (int)$_POST['subsection_id'] : null;
            $employee_type = $_POST['employee_type'];
            $employment_type = $_POST['employment_type'] ?: 'permanent';
            $job_group = in_array($_POST['job_group'], $job_groups) ? $_POST['job_group'] : null;

            // Validate leadership uniqueness
            if (!validateLeadershipUniqueness($conn, $employee_type, $department_id, $section_id, $subsection_id)) {
                $role_name = ucwords(str_replace('_', ' ', $employee_type));
                $unit = match(getLeadershipScope($employee_type)) {
                    'organization' => 'the organization',
                    'department'   => 'this department',
                    'section'      => 'this section',
                    'subsection'   => 'this subsection',
                    default        => 'this unit'
                };
                redirectWithMessage('employees.php', "A {$role_name} already exists in {$unit}. Only one is allowed.", 'danger');
            }

            // Prepare next of kin data
            $next_of_kin = prepareNextOfKin($_POST);

            $conn->begin_transaction();

            // Insert employee
            $stmt = $conn->prepare("INSERT INTO employees (employee_id, first_name, last_name, surname, gender, national_id, phone, email, date_of_birth, designation, department_id, section_id, subsection_id, employee_type, employment_type, address, hire_date, scale_id, next_of_kin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            bindParameters($stmt, "ssssssssssiiiisssss", [
                $employee_id, $first_name, $last_name, $surname, $gender, $national_id, $phone, $email, 
                $date_of_birth, $designation, $department_id, $section_id, $subsection_id, $employee_type, 
                $employment_type, $address, $hire_date, $job_group, $next_of_kin
            ]);
            $stmt->execute();
            $new_employee_id = $conn->insert_id;

            // Generate profile token
            $token = hash('sha256', random_bytes(32) . $new_employee_id . time());
            $token_stmt = $conn->prepare("UPDATE employees SET profile_token = ? WHERE id = ?");
            bindParameters($token_stmt, "si", [$token, $new_employee_id]);
            $token_stmt->execute();

            // Create payroll entry
            $payroll_status = 'active';
            $payroll_stmt = $conn->prepare("INSERT INTO payroll (emp_id, employment_type, status, job_group) VALUES (?, ?, ?, ?)");
            bindParameters($payroll_stmt, "isss", [$new_employee_id, $employment_type, $payroll_status, $job_group]);
            $payroll_stmt->execute();

            // Create user account
            $user_role = getUserRoleFromEmployeeType($employee_type);
            $hashed_password = password_hash($employee_id, PASSWORD_DEFAULT);
            $user_stmt = $conn->prepare("INSERT INTO users (email, first_name, last_name, gender, password, role, phone, address, employee_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())");
            bindParameters($user_stmt, "sssssssss", [
                $email, $first_name, $last_name, $gender, $hashed_password, $user_role, $phone, $address, $employee_id
            ]);
            $user_stmt->execute();

            $conn->commit();
            redirectWithMessage('employees.php', 'Employee, user account, and payroll entry created successfully! Default password is the employee ID.', 'success');

        } elseif ($action === 'edit') {
            $id = (int)($_POST['id'] ?? 0);
            $employee_id = sanitizeInput($_POST['employee_id']);
            $first_name = sanitizeInput($_POST['first_name']);
            $last_name = sanitizeInput($_POST['last_name']);
            $surname = sanitizeInput($_POST['surname'] ?? '');
            $gender = sanitizeInput($_POST['gender'] ?? '');
            $national_id = sanitizeInput($_POST['national_id']);
            $email = sanitizeInput($_POST['email']);
            $phone = sanitizeInput($_POST['phone']);
            $address = sanitizeInput($_POST['address']);
            $date_of_birth = $_POST['date_of_birth'];
            $hire_date = $_POST['hire_date'];
            $designation = sanitizeInput($_POST['designation']);
            $department_id = !empty($_POST['department_id']) ? (int)$_POST['department_id'] : null;
            $section_id = !empty($_POST['section_id']) ? (int)$_POST['section_id'] : null;
            $subsection_id = !empty($_POST['subsection_id']) ? (int)$_POST['subsection_id'] : null;
            $employee_type = $_POST['employee_type'];
            $employment_type = $_POST['employment_type'];
            $employee_status = $_POST['employee_status'];
            $job_group = in_array($_POST['job_group'], $job_groups) ? $_POST['job_group'] : null;

            // Validate leadership uniqueness (excluding self)
            if (!validateLeadershipUniqueness($conn, $employee_type, $department_id, $section_id, $subsection_id, $id)) {
                $role_name = ucwords(str_replace('_', ' ', $employee_type));
                $unit = match(getLeadershipScope($employee_type)) {
                    'organization' => 'the organization',
                    'department'   => 'this department',
                    'section'      => 'this section',
                    'subsection'   => 'this subsection',
                    default        => 'this unit'
                };
                redirectWithMessage('employees.php', "A {$role_name} already exists in {$unit}. Only one is allowed.", 'danger');
            }

            // Prepare next of kin data
            $next_of_kin = prepareNextOfKin($_POST);

            $conn->begin_transaction();

            // Get current employee ID for user update
            $current_emp_stmt = $conn->prepare("SELECT employee_id FROM employees WHERE id = ?");
            bindParameters($current_emp_stmt, "i", [$id]);
            $current_emp_stmt->execute();
            $current_employee = $current_emp_stmt->get_result()->fetch_assoc();
            $old_employee_id = $current_employee['employee_id'];

            // Update employee
            $stmt = $conn->prepare("UPDATE employees SET employee_id=?, first_name=?, last_name=?, surname=?, gender=?, national_id=?, email=?, phone=?, address=?, date_of_birth=?, hire_date=?, designation=?, department_id=?, section_id=?, subsection_id=?, employee_type=?, employment_type=?, employee_status=?, scale_id=?, next_of_kin=?, updated_at=NOW() WHERE id=?");
            bindParameters($stmt, "sssssssssssiiissssssi", [
                $employee_id, $first_name, $last_name, $surname, $gender, $national_id, $email, $phone, 
                $address, $date_of_birth, $hire_date, $designation, $department_id, $section_id, $subsection_id, 
                $employee_type, $employment_type, $employee_status, $job_group, $next_of_kin, $id
            ]);
            $stmt->execute();

            // Update payroll
            $payroll_status = ($employee_status === 'active') ? 'active' : 'inactive';
            $payroll_stmt = $conn->prepare("UPDATE payroll SET job_group = ?, employment_type = ?, status = ? WHERE emp_id = ?");
            bindParameters($payroll_stmt, "sssi", [$job_group, $employment_type, $payroll_status, $id]);
            $payroll_stmt->execute();

            // Update user account
            $user_role = getUserRoleFromEmployeeType($employee_type);
            $user_update_stmt = $conn->prepare("UPDATE users SET email=?, first_name=?, last_name=?, gender=?, role=?, phone=?, address=?, employee_id=?, updated_at=NOW() WHERE employee_id=?");
            bindParameters($user_update_stmt, "sssssssss", [
                $email, $first_name, $last_name, $gender, $user_role, $phone, $address, $employee_id, $old_employee_id
            ]);
            $user_update_stmt->execute();

            $conn->commit();
            redirectWithMessage('employees.php', 'Employee and user account updated successfully!', 'success');
        }
    } catch (Exception $e) {
        $conn->rollback();
        $error = 'Error processing employee: ' . $e->getMessage();
    }
}

include 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employees - HR Management System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="main-content">
            <div class="tabs">
                <ul>
                    <li>
                        <a href="personal_profile.php" class="tab-link <?= basename($_SERVER['PHP_SELF']) === 'personal_profile.php' ? 'active' : '' ?>" data-tab="profile">
                            My Profile
                        </a>
                    </li>
                    <?php if (hasPermission('hr_manager')): ?>
                        <li>
                            <a href="employees.php" class="tab-link <?= basename($_SERVER['PHP_SELF']) === 'employees.php' ? 'active' : '' ?>" data-tab="employees">
                                Manage Employees
                            </a>
                        </li>
                    <?php endif; ?>
                </ul>
            </div>
            <div class="content">
                <?php if ($flash = getFlashMessage()): ?>
                    <div class="alert alert-<?= htmlspecialchars($flash['type'], ENT_QUOTES, 'UTF-8') ?>">
                        <?= htmlspecialchars($flash['message'], ENT_QUOTES, 'UTF-8') ?>
                    </div>
                <?php endif; ?>
                <?php if (isset($error)): ?>
                    <div class="alert alert-danger"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></div>
                <?php endif; ?>
                <?php if (hasPermission('hr_manager')): ?>
                    <div id="employees" class="tab-content active">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h2>Employees (<?= $total ?>)</h2>
                            <button onclick="showAddModal()" class="btn btn-success">Add New Employee</button>
                        </div>
                        <!-- Search and Filters -->
                        <div class="search-filters">
                            <form method="GET" action="">
                                <div class="filter-row">
                                    <div class="form-group">
                                        <label for="search">Search</label>
                                        <input type="text" class="form-control" id="search" name="search" value="<?= htmlspecialchars($search, ENT_QUOTES, 'UTF-8') ?>" placeholder="Name, ID, or Email">
                                    </div>
                                    <div class="form-group">
                                        <label for="department">Department</label>
                                        <select class="form-control" id="department" name="department">
                                            <option value="">All Departments</option>
                                            <?php foreach ($departments as $dept): ?>
                                                <option value="<?= (int)$dept['id'] ?>" <?= $department_filter == $dept['id'] ? 'selected' : '' ?>>
                                                    <?= htmlspecialchars($dept['name'], ENT_QUOTES, 'UTF-8') ?>
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="section">Section</label>
                                        <select class="form-control" id="section" name="section">
                                            <option value="">All Sections</option>
                                            <?php foreach ($sections as $section): ?>
                                                <option value="<?= (int)$section['id'] ?>" <?= $section_filter == $section['id'] ? 'selected' : '' ?>>
                                                    <?= htmlspecialchars($section['name'], ENT_QUOTES, 'UTF-8') ?> (<?= htmlspecialchars($section['department_name'], ENT_QUOTES, 'UTF-8') ?>)
                                                </option>
                                            <?php endforeach; ?>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="type">Employee Type</label>
                                        <select class="form-control" id="type" name="type">
                                            <option value="">All Types</option>
                                            <option value="officer" <?= $type_filter === 'officer' ? 'selected' : '' ?>>Officer</option>
                                            <option value="section_head" <?= $type_filter === 'section_head' ? 'selected' : '' ?>>Section Head</option>
                                            <option value="sub_section_head" <?= $type_filter === 'sub_section_head' ? 'selected' : '' ?>>Sub Section Head</option>
                                            <option value="manager" <?= $type_filter === 'manager' ? 'selected' : '' ?>>Manager</option>
                                            <option value="hr_manager" <?= $type_filter === 'hr_manager' ? 'selected' : '' ?>>Human Resource Manager</option>
                                            <option value="dept_head" <?= $type_filter === 'dept_head' ? 'selected' : '' ?>>Department Head</option>
                                            <option value="managing_director" <?= $type_filter === 'managing_director' ? 'selected' : '' ?>>Managing Director</option>
                                            <option value="bod_chairman" <?= $type_filter === 'bod_chairman' ? 'selected' : '' ?>>BOD Chairman</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="status">Status</label>
                                        <select class="form-control" id="status" name="status">
                                            <option value="">All Status</option>
                                            <option value="active" <?= $status_filter === 'active' ? 'selected' : '' ?>>Active</option>
                                            <option value="inactive" <?= $status_filter === 'inactive' ? 'selected' : '' ?>>Inactive</option>
                                            <option value="resigned" <?= $status_filter === 'resigned' ? 'selected' : '' ?>>Resigned</option>
                                            <option value="fired" <?= $status_filter === 'fired' ? 'selected' : '' ?>>Fired</option>
                                            <option value="retired" <?= $status_filter === 'retired' ? 'selected' : '' ?>>Retired</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Filter</button>
                                        <a href="employees.php" class="btn btn-secondary">Clear</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <!-- Employees Table -->
                        <div class="table-container">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Employee ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Department</th>
                                        <th>Section</th>
                                        <th>Sub-Section</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Job Group</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (empty($employees)): ?>
                                        <tr><td colspan="10" class="text-center">No employees found</td></tr>
                                    <?php else: ?>
                                        <?php foreach ($employees as $emp): ?>
                                            <tr>
                                                <td><?= htmlspecialchars($emp['employee_id'], ENT_QUOTES, 'UTF-8') ?></td>
                                                <td><?= htmlspecialchars(trim($emp['first_name'] . ' ' . $emp['last_name'] . ' ' . ($emp['surname'] ?? '')), ENT_QUOTES, 'UTF-8') ?></td>
                                                <td><?= htmlspecialchars($emp['email'] ?? 'N/A', ENT_QUOTES, 'UTF-8') ?></td>
                                                <td><?= htmlspecialchars($emp['department_name'] ?? 'N/A', ENT_QUOTES, 'UTF-8') ?></td>
                                                <td><?= htmlspecialchars($emp['section_name'] ?? 'N/A', ENT_QUOTES, 'UTF-8') ?></td>
                                                <td><?= htmlspecialchars($emp['subsection_name'] ?? 'N/A', ENT_QUOTES, 'UTF-8') ?></td>
                                                <td>
                                                    <span class="badge <?= getEmployeeTypeBadge($emp['employee_type'] ?? '') ?>">
                                                        <?= $emp['employee_type'] ? htmlspecialchars(ucwords(str_replace('_', ' ', $emp['employee_type'])), ENT_QUOTES, 'UTF-8') : 'N/A' ?>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge <?= getEmployeeStatusBadge($emp['employee_status'] ?? '') ?>">
                                                        <?= $emp['employee_status'] ? htmlspecialchars(ucwords($emp['employee_status']), ENT_QUOTES, 'UTF-8') : 'N/A' ?>
                                                    </span>
                                                </td>
                                                <td><?= htmlspecialchars($emp['scale_id'] ?? 'N/A', ENT_QUOTES, 'UTF-8') ?></td>
                                                <td>
                                                    <button onclick="showEditModal(<?= htmlspecialchars(json_encode($emp, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE), ENT_QUOTES, 'UTF-8') ?>)" class="btn btn-sm btn-primary">Edit</button>
                                                    <a href="personal_profile.php?token=<?= urlencode($emp['profile_token']) ?>" class="btn btn-sm btn-info">Profile</a>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                        <!-- Pagination -->
                        <?php if ($totalPages > 1): ?>
                        <div class="pagination">
                            <?php if ($page > 1): ?>
                                <a href="?page=<?= $page - 1 ?><?= $search ? "&search=" . urlencode($search) : '' ?><?= $department_filter ? "&department=" . $department_filter : '' ?><?= $section_filter ? "&section=" . $section_filter : '' ?><?= $type_filter ? "&type=" . $type_filter : '' ?><?= $status_filter ? "&status=" . $status_filter : '' ?>" class="page-link">Previous</a>
                            <?php endif; ?>
                            <?php for ($i = max(1, $page - 2); $i <= min($totalPages, $page + 2); $i++): ?>
                                <a href="?page=<?= $i ?><?= $search ? "&search=" . urlencode($search) : '' ?><?= $department_filter ? "&department=" . $department_filter : '' ?><?= $section_filter ? "&section=" . $section_filter : '' ?><?= $type_filter ? "&type=" . $type_filter : '' ?><?= $status_filter ? "&status=" . $status_filter : '' ?>" class="page-link <?= $i === $page ? 'active' : '' ?>"><?= $i ?></a>
                            <?php endfor; ?>
                            <?php if ($page < $totalPages): ?>
                                <a href="?page=<?= $page + 1 ?><?= $search ? "&search=" . urlencode($search) : '' ?><?= $department_filter ? "&department=" . $department_filter : '' ?><?= $section_filter ? "&section=" . $section_filter : '' ?><?= $type_filter ? "&type=" . $type_filter : '' ?><?= $status_filter ? "&status=" . $status_filter : '' ?>" class="page-link">Next</a>
                            <?php endif; ?>
                        </div>
                        <?php endif; ?>
                    </div>
                <?php else: ?>
                    <div class="alert alert-danger">You do not have permission to view this page.</div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <?php if (hasPermission('hr_manager')): ?>
    <!-- Add Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add New Employee</h3>
                <span class="close" onclick="hideAddModal()">&times;</span>
            </div>
            <form method="POST" action="">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label for="employee_id">Employee ID</label>
                        <input type="text" class="form-control" id="employee_id" name="employee_id" required>
                    </div>
                    <div class="form-group">
                        <label for="first_name">First Name</label>
                        <input type="text" class="form-control" id="first_name" name="first_name" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="last_name">Last Name</label>
                        <input type="text" class="form-control" id="last_name" name="last_name" required>
                    </div>
                    <div class="form-group">
                        <label for="surname">Surname</label>
                        <input type="text" class="form-control" id="surname" name="surname">
                    </div>
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select class="form-control" id="gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="national_id">National ID</label>
                        <input type="text" class="form-control" id="national_id" name="national_id" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="designation">Designation</label>
                        <input type="text" class="form-control" id="designation" name="designation" required placeholder="e.g. Software Engineer">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label for="date_of_birth">Date of Birth</label>
                        <input type="date" class="form-control" id="date_of_birth" name="date_of_birth" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="hire_date">Hire Date</label>
                        <input type="date" class="form-control" id="hire_date" name="hire_date" required>
                    </div>
                    <div class="form-group">
                        <label for="employment_type">Employment Type</label>
                        <select class="form-control" id="employment_type" name="employment_type" required>
                            <option value="">Select Type</option>
                            <option value="permanent">Permanent</option>
                            <option value="contract">Contract</option>
                            <option value="temporary">Temporary</option>
                            <option value="intern">Intern</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="employee_type">Employee Type</label>
                        <select class="form-control" id="employee_type" name="employee_type" required onchange="handleEmployeeTypeChange()">
                            <option value="">Select Type</option>
                            <option value="officer">Officer</option>
                            <option value="sub_section_head">Sub Section Head</option>
                            <option value="section_head">Section Head</option>
                            <option value="manager">Manager</option>
                            <option value="hr_manager">Human Resource Manager</option>
                            <option value="dept_head">Department Head</option>
                            <option value="managing_director">Managing Director</option>
                            <option value="bod_chairman">BOD Chairman</option>
                        </select>
                    </div>
                    <div class="form-group" id="department_group">
                        <label for="department_id">Department</label>
                        <select class="form-control" id="department_id" name="department_id" onchange="updateSections()">
                            <option value="">Select Department</option>
                            <?php foreach ($departments as $dept): ?>
                                <option value="<?= (int)$dept['id'] ?>"><?= htmlspecialchars($dept['name'], ENT_QUOTES, 'UTF-8') ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group" id="section_group">
                        <label for="section_id">Section</label>
                        <select class="form-control" id="section_id" name="section_id" onchange="updateSubSections()">
                            <option value="">Select Section</option>
                        </select>
                    </div>
                    <div class="form-group" id="subsection_group" style="display: none;">
                        <label for="subsection_id">Sub-Section</label>
                        <select class="form-control" id="subsection_id" name="subsection_id">
                            <option value="">Select Sub-Section</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="job_group">Job Group</label>
                    <select class="form-control" id="job_group" name="job_group" required>
                        <option value="">Select Job Group</option>
                        <?php foreach ($job_groups as $group): ?>
                            <option value="<?= htmlspecialchars($group, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($group, ENT_QUOTES, 'UTF-8') ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Next of Kin</label>
                    <div id="next_of_kin_container">
                        <div class="next_of_kin_item form-row">
                            <div class="form-group">
                                <input type="text" name="next_of_kin_name[]" placeholder="Name" class="form-control">
                            </div>
                            <div class="form-group">
                                <input type="text" name="next_of_kin_relationship[]" placeholder="Relationship" class="form-control">
                            </div>
                            <div class="form-group">
                                <input type="text" name="next_of_kin_contact[]" placeholder="Contact (Phone)" class="form-control">
                            </div>
                            <button type="button" onclick="removeNok(this)" class="btn btn-danger btn-sm">Remove</button>
                        </div>
                    </div>
                    <button type="button" onclick="addNok()" class="btn btn-secondary">Add Next of Kin</button>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-success">Add Employee</button>
                    <button type="button" class="btn btn-secondary" onclick="hideAddModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Employee</h3>
                <span class="close" onclick="hideEditModal()">&times;</span>
            </div>
            <form method="POST" action="">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" id="edit_id" name="id">
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_employee_id">Employee ID</label>
                        <input type="text" class="form-control" id="edit_employee_id" name="employee_id" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_first_name">First Name</label>
                        <input type="text" class="form-control" id="edit_first_name" name="first_name" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_last_name">Last Name</label>
                        <input type="text" class="form-control" id="edit_last_name" name="last_name" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_surname">Surname</label>
                        <input type="text" class="form-control" id="edit_surname" name="surname">
                    </div>
                    <div class="form-group">
                        <label for="edit_gender">Gender</label>
                        <select class="form-control" id="edit_gender" name="gender" required>
                            <option value="">Select Gender</option>
                            <option value="male">Male</option>
                            <option value="female">Female</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="edit_national_id">National ID</label>
                        <input type="text" class="form-control" id="edit_national_id" name="national_id" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_email">Email</label>
                        <input type="email" class="form-control" id="edit_email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_designation">Designation</label>
                        <input type="text" class="form-control" id="edit_designation" name="designation" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_phone">Phone</label>
                        <input type="text" class="form-control" id="edit_phone" name="phone" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_date_of_birth">Date of Birth</label>
                        <input type="date" class="form-control" id="edit_date_of_birth" name="date_of_birth" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="edit_address">Address</label>
                    <textarea class="form-control" id="edit_address" name="address" rows="3"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_hire_date">Hire Date</label>
                        <input type="date" class="form-control" id="edit_hire_date" name="hire_date" required>
                    </div>
                    <div class="form-group">
                        <label for="edit_employment_type">Employment Type</label>
                        <select class="form-control" id="edit_employment_type" name="employment_type" required>
                            <option value="">Select Type</option>
                            <option value="permanent">Permanent</option>
                            <option value="contract">Contract</option>
                            <option value="temporary">Temporary</option>
                            <option value="intern">Intern</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="edit_employee_type">Employee Type</label>
                        <select class="form-control" id="edit_employee_type" name="employee_type" required onchange="handleEditEmployeeTypeChange()">
                            <option value="">Select Type</option>
                            <option value="officer">Officer</option>
                            <option value="sub_section_head">Sub Section Head</option>
                            <option value="section_head">Section Head</option>
                            <option value="manager">Manager</option>
                            <option value="hr_manager">Human Resource Manager</option>
                            <option value="dept_head">Department Head</option>
                            <option value="managing_director">Managing Director</option>
                            <option value="bod_chairman">BOD Chairman</option>
                        </select>
                    </div>
                    <div class="form-group" id="edit_department_group">
                        <label for="edit_department_id">Department</label>
                        <select class="form-control" id="edit_department_id" name="department_id" onchange="updateEditSections()">
                            <option value="">Select Department</option>
                            <?php foreach ($departments as $dept): ?>
                                <option value="<?= (int)$dept['id'] ?>"><?= htmlspecialchars($dept['name'], ENT_QUOTES, 'UTF-8') ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group" id="edit_section_group">
                        <label for="edit_section_id">Section</label>
                        <select class="form-control" id="edit_section_id" name="section_id" onchange="updateEditSubSections()">
                            <option value="">Select Section</option>
                        </select>
                    </div>
                    <div class="form-group" id="edit_subsection_group" style="display: none;">
                        <label for="edit_subsection_id">Sub-Section</label>
                        <select class="form-control" id="edit_subsection_id" name="subsection_id">
                            <option value="">Select Sub-Section</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="edit_employee_status">Status</label>
                    <select class="form-control" id="edit_employee_status" name="employee_status" required>
                        <option value="">Select Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                        <option value="resigned">Resigned</option>
                        <option value="fired">Fired</option>
                        <option value="retired">Retired</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="edit_job_group">Job Group</label>
                    <select class="form-control" id="edit_job_group" name="job_group" required>
                        <option value="">Select Job Group</option>
                        <?php foreach ($job_groups as $group): ?>
                            <option value="<?= htmlspecialchars($group, ENT_QUOTES, 'UTF-8') ?>"><?= htmlspecialchars($group, ENT_QUOTES, 'UTF-8') ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Next of Kin</label>
                    <div id="edit_next_of_kin_container">
                        <!-- Populated by JS -->
                    </div>
                    <button type="button" onclick="addEditNok()" class="btn btn-secondary">Add Next of Kin</button>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-success">Update Employee</button>
                    <button type="button" class="btn btn-secondary" onclick="hideEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <?php endif; ?>

    <script>
        const sectionsData = <?= json_encode($sections, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE) ?>;
        const subsectionsData = <?= json_encode($subsections, JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE) ?>;

        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
            updateSections();
            if (document.querySelectorAll('#next_of_kin_container .next_of_kin_item').length === 0) {
                addNok();
            }
        }
        function hideAddModal() {
            document.getElementById('addModal').style.display = 'none';
            document.getElementById('addModal').querySelector('form').reset();
            document.getElementById('section_id').innerHTML = '<option value="">Select Section</option>';
            document.getElementById('subsection_id').innerHTML = '<option value="">Select Sub-Section</option>';
            document.getElementById('subsection_group').style.display = 'none';
            document.getElementById('next_of_kin_container').innerHTML = '';
        }
        function showEditModal(employee) {
            document.getElementById('edit_id').value = employee.id;
            document.getElementById('edit_employee_id').value = employee.employee_id;
            document.getElementById('edit_first_name').value = employee.first_name;
            document.getElementById('edit_last_name').value = employee.last_name;
            document.getElementById('edit_surname').value = employee.surname || '';
            document.getElementById('edit_gender').value = employee.gender || '';
            document.getElementById('edit_national_id').value = employee.national_id || '';
            document.getElementById('edit_email').value = employee.email || '';
            document.getElementById('edit_phone').value = employee.phone || '';
            document.getElementById('edit_address').value = employee.address || '';
            document.getElementById('edit_date_of_birth').value = employee.date_of_birth || '';
            document.getElementById('edit_hire_date').value = employee.hire_date || '';
            document.getElementById('edit_designation').value = employee.designation || '';
            document.getElementById('edit_employment_type').value = employee.employment_type || '';
            document.getElementById('edit_employee_type').value = employee.employee_type || '';
            document.getElementById('edit_department_id').value = employee.department_id || '';
            document.getElementById('edit_employee_status').value = employee.employee_status || '';
            document.getElementById('edit_job_group').value = employee.scale_id || '';

            const editNokContainer = document.getElementById('edit_next_of_kin_container');
            editNokContainer.innerHTML = '';
            let nokList = [];
            try {
                nokList = JSON.parse(employee.next_of_kin) || [];
            } catch (e) {
                nokList = [];
            }
            if (nokList.length === 0) {
                addEditNok();
            } else {
                nokList.forEach(nok => {
                    addEditNok(nok.name, nok.relationship, nok.contact);
                });
            }
            updateEditSections(employee.section_id, employee.subsection_id);
            handleEditEmployeeTypeChange();
            document.getElementById('editModal').style.display = 'block';
        }
        function hideEditModal() {
            document.getElementById('editModal').style.display = 'none';
            document.getElementById('editModal').querySelector('form').reset();
            document.getElementById('edit_section_id').innerHTML = '<option value="">Select Section</option>';
            document.getElementById('edit_subsection_id').innerHTML = '<option value="">Select Sub-Section</option>';
            document.getElementById('edit_subsection_group').style.display = 'none';
            document.getElementById('edit_next_of_kin_container').innerHTML = '';
        }
        function updateSections() {
            const departmentId = document.getElementById('department_id').value;
            const sectionSelect = document.getElementById('section_id');
            const subsectionGroup = document.getElementById('subsection_group');
            const subsectionSelect = document.getElementById('subsection_id');
            sectionSelect.innerHTML = '<option value="">Select Section</option>';
            subsectionSelect.innerHTML = '<option value="">Select Sub-Section</option>';
            subsectionGroup.style.display = 'none';
            if (departmentId) {
                const filteredSections = sectionsData.filter(section => section.department_id == departmentId);
                filteredSections.forEach(section => {
                    const option = document.createElement('option');
                    option.value = section.id;
                    option.textContent = section.name;
                    sectionSelect.appendChild(option);
                });
            }
        }
        function updateSubSections() {
            const sectionId = document.getElementById('section_id').value;
            const subsectionGroup = document.getElementById('subsection_group');
            const subsectionSelect = document.getElementById('subsection_id');
            subsectionSelect.innerHTML = '<option value="">Select Sub-Section</option>';
            if (sectionId) {
                const filteredSubsections = subsectionsData.filter(subsection => subsection.section_id == sectionId);
                if (filteredSubsections.length > 0) {
                    subsectionGroup.style.display = 'block';
                    filteredSubsections.forEach(subsection => {
                        const option = document.createElement('option');
                        option.value = subsection.id;
                        option.textContent = subsection.name;
                        subsectionSelect.appendChild(option);
                    });
                } else {
                    subsectionGroup.style.display = 'none';
                }
            } else {
                subsectionGroup.style.display = 'none';
            }
        }
        function updateEditSections(selectedSectionId = '', selectedSubsectionId = '') {
            const departmentId = document.getElementById('edit_department_id').value;
            const sectionSelect = document.getElementById('edit_section_id');
            const subsectionGroup = document.getElementById('edit_subsection_group');
            const subsectionSelect = document.getElementById('edit_subsection_id');
            sectionSelect.innerHTML = '<option value="">Select Section</option>';
            subsectionSelect.innerHTML = '<option value="">Select Sub-Section</option>';
            subsectionGroup.style.display = 'none';
            if (departmentId) {
                const filteredSections = sectionsData.filter(section => section.department_id == departmentId);
                filteredSections.forEach(section => {
                    const option = document.createElement('option');
                    option.value = section.id;
                    option.textContent = section.name;
                    if (section.id == selectedSectionId) {
                        option.selected = true;
                    }
                    sectionSelect.appendChild(option);
                });
                if (selectedSectionId) {
                    updateEditSubSections(selectedSubsectionId);
                }
            }
        }
        function updateEditSubSections(selectedSubsectionId = '') {
            const sectionId = document.getElementById('edit_section_id').value;
            const subsectionGroup = document.getElementById('edit_subsection_group');
            const subsectionSelect = document.getElementById('edit_subsection_id');
            subsectionSelect.innerHTML = '<option value="">Select Sub-Section</option>';
            if (sectionId) {
                const filteredSubsections = subsectionsData.filter(subsection => subsection.section_id == sectionId);
                if (filteredSubsections.length > 0) {
                    subsectionGroup.style.display = 'block';
                    filteredSubsections.forEach(subsection => {
                        const option = document.createElement('option');
                        option.value = subsection.id;
                        option.textContent = subsection.name;
                        if (subsection.id == selectedSubsectionId) {
                            option.selected = true;
                        }
                        subsectionSelect.appendChild(option);
                    });
                } else {
                    subsectionGroup.style.display = 'none';
                }
            } else {
                subsectionGroup.style.display = 'none';
            }
        }
        function handleEmployeeTypeChange() {
            const employeeType = document.getElementById('employee_type').value;
            const departmentGroup = document.getElementById('department_group');
            const sectionGroup = document.getElementById('section_group');
            const subsectionGroup = document.getElementById('subsection_group');
            if (['managing_director', 'bod_chairman'].includes(employeeType)) {
                departmentGroup.style.display = 'none';
                sectionGroup.style.display = 'none';
                subsectionGroup.style.display = 'none';
                document.getElementById('department_id').value = '';
                document.getElementById('section_id').value = '';
                document.getElementById('subsection_id').value = '';
            } else {
                departmentGroup.style.display = 'block';
                sectionGroup.style.display = 'block';
            }
        }
        function handleEditEmployeeTypeChange() {
            const employeeType = document.getElementById('edit_employee_type').value;
            const departmentGroup = document.getElementById('edit_department_group');
            const sectionGroup = document.getElementById('edit_section_group');
            const subsectionGroup = document.getElementById('edit_subsection_group');
            if (['managing_director', 'bod_chairman'].includes(employeeType)) {
                departmentGroup.style.display = 'none';
                sectionGroup.style.display = 'none';
                subsectionGroup.style.display = 'none';
                document.getElementById('edit_department_id').value = '';
                document.getElementById('edit_section_id').value = '';
                document.getElementById('edit_subsection_id').value = '';
            } else {
                departmentGroup.style.display = 'block';
                sectionGroup.style.display = 'block';
                const sectionId = document.getElementById('edit_section_id').value;
                if (sectionId) {
                    updateEditSubSections(document.getElementById('edit_subsection_id').value);
                }
            }
        }
        function addNok(name = '', relationship = '', contact = '') {
            const container = document.getElementById('next_of_kin_container');
            const item = document.createElement('div');
            item.className = 'next_of_kin_item form-row';
            item.innerHTML = `
                <div class="form-group">
                    <input type="text" name="next_of_kin_name[]" placeholder="Name" value="${name}" class="form-control">
                </div>
                <div class="form-group">
                    <input type="text" name="next_of_kin_relationship[]" placeholder="Relationship" value="${relationship}" class="form-control">
                </div>
                <div class="form-group">
                    <input type="text" name="next_of_kin_contact[]" placeholder="Contact (Phone)" value="${contact}" class="form-control">
                </div>
                <button type="button" onclick="removeNok(this)" class="btn btn-danger btn-sm">Remove</button>
            `;
            container.appendChild(item);
        }
        function removeNok(btn) {
            btn.parentElement.remove();
        }
        function addEditNok(name = '', relationship = '', contact = '') {
            const container = document.getElementById('edit_next_of_kin_container');
            const item = document.createElement('div');
            item.className = 'next_of_kin_item form-row';
            item.innerHTML = `
                <div class="form-group">
                    <input type="text" name="next_of_kin_name[]" placeholder="Name" value="${name}" class="form-control">
                </div>
                <div class="form-group">
                    <input type="text" name="next_of_kin_relationship[]" placeholder="Relationship" value="${relationship}" class="form-control">
                </div>
                <div class="form-group">
                    <input type="text" name="next_of_kin_contact[]" placeholder="Contact (Phone)" value="${contact}" class="form-control">
                </div>
                <button type="button" onclick="removeEditNok(this)" class="btn btn-danger btn-sm">Remove</button>
            `;
            container.appendChild(item);
        }
        function removeEditNok(btn) {
            btn.parentElement.remove();
        }
        window.onclick = function(event) {
            const addModal = document.getElementById('addModal');
            const editModal = document.getElementById('editModal');
            if (event.target === addModal) {
                hideAddModal();
            } else if (event.target === editModal) {
                hideEditModal();
            }
        };
        addNok();
    </script>
</body>
</html>