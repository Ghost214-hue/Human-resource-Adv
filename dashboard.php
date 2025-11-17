<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

require_once 'auth_check.php';
require_once 'config.php';
require_once 'auth.php';

// Set correct timezone for Kenya
date_default_timezone_set('Africa/Nairobi');

$pageTitle = 'Dashboard';

// CSRF token generation
if (empty($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(32));
}

// Get current user info
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

function getFlashMessage() {
    if (isset($_SESSION['flash_message'])) {
        $message = $_SESSION['flash_message'];
        $type = $_SESSION['flash_type'] ?? 'info';
        unset($_SESSION['flash_message'], $_SESSION['flash_type']);
        return ['message' => $message, 'type' => $type];
    }
    return false;
}

$conn = getConnection();

// === ATTENDANCE SYSTEM INTEGRATION ===
$session_employee_id = $_SESSION['employee_id'] ?? $_SESSION['user_id'];

// Get employee data
$employee_lookup_stmt = $conn->prepare("
    SELECT id, employee_id, first_name, last_name, office_id 
    FROM employees 
    WHERE employee_id = ? OR id = ?
");
$employee_lookup_stmt->bind_param("ss", $session_employee_id, $session_employee_id);
$employee_lookup_stmt->execute();
$employee_data = $employee_lookup_stmt->get_result()->fetch_assoc();
$employee_lookup_stmt->close();

$employee_db_id = $employee_data['id'] ?? null;
$attendance_enabled = !empty($employee_db_id);

// Initialize message variables
$success = '';
$error = '';
$warning = '';

// Time-based logic implementation
$current_time = time();
$current_hour = (int)date('H', $current_time);
$current_date = date('Y-m-d');

// Initialize attendance variables
$is_clocked_in = false;
$has_clocked_in_today = false;
$button_enabled = false;
$button_action = '';
$button_text = '';
$button_class = '';
$already_clocked_message = '';
$today_clock_in = null;
$current_session = null;
$employee_office = null;
$geofence_radius = 200;

if ($attendance_enabled) {
    // Get employee's assigned office
    $office_stmt = $conn->prepare("
        SELECT 
            e.office_id, 
            o.name AS office_name, 
            o.latitude, 
            o.longitude,
            o.description,
            o.geo_fence_radius
        FROM employees e 
        INNER JOIN offices o ON e.office_id = o.id 
        WHERE e.id = ?
    ");
    $office_stmt->bind_param("i", $employee_db_id);
    $office_stmt->execute();
    $result = $office_stmt->get_result();
    $employee_office = $result->fetch_assoc();
    $office_stmt->close();

    // Set default geofence radius to 200m if not configured
    $geofence_radius = !empty($employee_office['geo_fence_radius']) ? 
        $employee_office['geo_fence_radius'] : 200;

    // Check if office assignment is valid
    $office_error = null;
    if (empty($employee_office)) {
        $office_error = "Employee record not found or no office assigned.";
    } elseif (empty($employee_office['office_id'])) {
        $office_error = "You are not assigned to any office. Please contact HR.";
    } elseif (empty($employee_office['office_name'])) {
        $office_error = "Your office assignment is invalid. Please contact HR.";
    } elseif (empty($employee_office['latitude']) || empty($employee_office['longitude'])) {
        $office_error = "Your assigned office location coordinates are not configured. Please contact HR.";
    }

    // Check if employee has an active session
    $current_session_stmt = $conn->prepare("
        SELECT * FROM attendance 
        WHERE employee_id = ? AND clock_out IS NULL 
        ORDER BY clock_in DESC LIMIT 1
    ");
    $current_session_stmt->bind_param("i", $employee_db_id);
    $current_session_stmt->execute();
    $current_session = $current_session_stmt->get_result()->fetch_assoc();
    $current_session_stmt->close();

    $is_clocked_in = !empty($current_session);

    // Check if employee has already clocked in today
    $today_clock_in_stmt = $conn->prepare("
        SELECT * FROM attendance 
        WHERE employee_id = ? AND DATE(clock_in) = ? AND clock_out IS NOT NULL
        ORDER BY clock_in DESC LIMIT 1
    ");
    $today_clock_in_stmt->bind_param("is", $employee_db_id, $current_date);
    $today_clock_in_stmt->execute();
    $today_clock_in = $today_clock_in_stmt->get_result()->fetch_assoc();
    $today_clock_in_stmt->close();

    $has_clocked_in_today = !empty($today_clock_in);

    // Determine button state and action
    if ($is_clocked_in) {
        // Currently clocked in - show clock out button
        $button_action = 'clock_out';
        $button_text = 'Clock Out';
        $button_class = 'btn-clock-out';
        $button_enabled = true;
    } else {
        // Not currently clocked in
        if ($has_clocked_in_today) {
            // Already clocked in and out today - button should be disabled until 5 AM next day
            $button_action = '';
            $button_text = 'Clock In (Available at 5 AM)';
            $button_class = 'btn-clock-in-disabled';
            $button_enabled = false;
            $already_clocked_message = "You have already clocked in and out today. You can clock in again after 5 AM tomorrow.";
        } else {
            // Hasn't clocked in today - check if it's after 5 AM
            if ($current_hour >= 5) {
                $button_action = 'clock_in';
                $button_text = 'Clock In';
                $button_class = 'btn-clock-in';
                $button_enabled = true;
            } else {
                $button_action = '';
                $button_text = 'Clock In (Available at 5 AM)';
                $button_class = 'btn-clock-in-disabled';
                $button_enabled = false;
            }
        }
    }

    // Handle attendance form submission
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
        // CSRF validation
        if (!isset($_POST['csrf']) || $_POST['csrf'] !== $_SESSION['csrf']) {
            $error = "Invalid session token. Please refresh and try again.";
        } else {
            $latitude = floatval($_POST['latitude']);
            $longitude = floatval($_POST['longitude']);
            $accuracy = floatval($_POST['accuracy'] ?? 0);
            $action = $_POST['action'];
            
            // Additional validation for time-based restrictions
            if ($action === 'clock_in') {
                // Check if employee has already clocked in today
                if ($has_clocked_in_today) {
                    $error = "You have already clocked in and out today. You can clock in again after 5 AM tomorrow.";
                }
                // Check if it's before 5 AM
                elseif ($current_hour < 5) {
                    $error = "Clock in is only available after 5 AM.";
                }
            }

            if (empty($error)) {
                error_log("Location attempt - Employee: $employee_db_id, Action: $action, Lat: $latitude, Lng: $longitude, Accuracy: {$accuracy}m");

                if ($action === 'clock_in') {
                    if (!empty($employee_office['latitude']) && !empty($employee_office['longitude'])) {
                        $distance = calculateDistance(
                            $latitude,
                            $longitude,
                            floatval($employee_office['latitude']),
                            floatval($employee_office['longitude'])
                        );

                        $distance_meters = round($distance * 1000);
                        
                        // Enhanced distance calculation with better accuracy handling
                        $effective_distance = $distance_meters + ($accuracy * 0.3); // Reduced accuracy multiplier
                        
                        // Log location details for debugging
                        error_log("Clock in attempt - Employee: $employee_db_id, Distance: {$distance_meters}m, Accuracy: {$accuracy}m, Effective: {$effective_distance}m");
                        
                        // Use 200m radius with tolerance (220m effective limit)
                        if ($effective_distance > 220) {
                            $error = "You are outside the authorized geo-fence (200m radius). Current distance: {$distance_meters}m ±{$accuracy}m";
                        } elseif ($accuracy > 150) {
                            $warning = "Location accuracy is low (±{$accuracy}m). For better accuracy, ensure GPS is enabled and you're outdoors.";
                        }
                    } else {
                        $error = "Your assigned office location is not configured. Please contact HR.";
                    }
                }

                if (empty($error)) {
                    if ($action === 'clock_in') {
                        if ($is_clocked_in) {
                            $error = "You are already clocked in. Please clock out first.";
                        } else {
                            $stmt = $conn->prepare("
                                INSERT INTO attendance 
                                (employee_id, office_id, clock_in, lat, lng, accuracy, status, created_at, updated_at)
                                VALUES (?, ?, NOW(), ?, ?, ?, 'clocked_in', NOW(), NOW())
                            ");
                            $stmt->bind_param("iiddd", $employee_db_id, $employee_office['office_id'], 
                                $latitude, $longitude, $accuracy);
                            if ($stmt->execute()) {
                                $success = "Successfully clocked in!";
                                $is_clocked_in = true;
                                
                                // Update button state
                                $button_action = 'clock_out';
                                $button_text = 'Clock Out';
                                $button_class = 'btn-clock-out';
                                $button_enabled = true;
                                $already_clocked_message = '';
                                
                                trackAction('CLOCK_IN', "Employee clocked in at office: {$employee_office['office_name']}", [
                                    'employee_id' => $employee_db_id,
                                    'office_id' => $employee_office['office_id'],
                                    'coordinates' => "{$latitude}, {$longitude}",
                                    'accuracy' => "{$accuracy}m",
                                    'distance' => "{$distance_meters}m"
                                ]);
                                
                                header("Location: dashboard.php?success=clocked_in");
                                exit;
                            } else {
                                $error = "Failed to clock in. Please try again.";
                            }
                            $stmt->close();
                        }
                    } elseif ($action === 'clock_out') {
                        if (!$is_clocked_in || empty($current_session)) {
                            $error = "You are not clocked in. Please clock in first.";
                        } else {
                            $stmt = $conn->prepare("
                                UPDATE attendance 
                                SET clock_out = NOW(), 
                                    status = 'clocked_out', 
                                    updated_at = NOW()
                                WHERE id = ? AND employee_id = ?
                            ");
                            $stmt->bind_param("ii", $current_session['id'], $employee_db_id);
                            if ($stmt->execute()) {
                                $success = "Successfully clocked out!";
                                $is_clocked_in = false;
                                
                                // Update button state
                                if ($current_hour >= 5) {
                                    $button_action = 'clock_in';
                                    $button_text = 'Clock In';
                                    $button_class = 'btn-clock-in';
                                    $button_enabled = true;
                                } else {
                                    $button_action = '';
                                    $button_text = 'Clock In (Available at 5 AM)';
                                    $button_class = 'btn-clock-in-disabled';
                                    $button_enabled = false;
                                }
                                
                                trackAction('CLOCK_OUT', "Employee clocked out from office: {$employee_office['office_name']}", [
                                    'employee_id' => $employee_db_id,
                                    'attendance_id' => $current_session['id']
                                ]);
                                
                                header("Location: dashboard.php?success=clocked_out");
                                exit;
                            } else {
                                $error = "Failed to clock out. Please try again.";
                            }
                            $stmt->close();
                        }
                    }
                }
            }
        }
    }

    // Handle success messages from redirect
    if (isset($_GET['success'])) {
        if ($_GET['success'] === 'clocked_in') {
            $success = "Successfully clocked in!";
        } elseif ($_GET['success'] === 'clocked_out') {
            $success = "Successfully clocked out!";
        }
    }

    // Get today's attendance summary
    $today_summary_stmt = $conn->prepare("
        SELECT 
            COUNT(*) as total_sessions,
            SEC_TO_TIME(SUM(TIMESTAMPDIFF(SECOND, clock_in, COALESCE(clock_out, NOW())))) as total_hours
        FROM attendance 
        WHERE employee_id = ? 
        AND DATE(clock_in) = CURDATE()
    ");
    $today_summary_stmt->bind_param("i", $employee_db_id);
    $today_summary_stmt->execute();
    $today_summary = $today_summary_stmt->get_result()->fetch_assoc();
    $today_summary_stmt->close();
}

// Haversine distance in km
function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    $earth_radius = 6371;
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    $a = sin($dLat/2) ** 2 + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) ** 2;
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    return $earth_radius * $c;
}

// === END ATTENDANCE SYSTEM INTEGRATION ===

// Check if user has HR manager permissions
$has_hr_manager_access = hasPermission('hr_manager');

// Stats - Only fetch if user is HR manager
$totalEmployees = 0;
$totalDepartments = 0;
$totalSections = 0;
$recentHires = 0;

if ($has_hr_manager_access) {
    $totalEmployees = $conn->query("SELECT COUNT(*) AS count FROM employees WHERE employee_status = 'active'")->fetch_assoc()['count'];
    $totalDepartments = $conn->query("SELECT COUNT(*) AS count FROM departments")->fetch_assoc()['count'];
    $totalSections = $conn->query("SELECT COUNT(*) AS count FROM sections")->fetch_assoc()['count'];
    $recentHires = $conn->query("SELECT COUNT(*) AS count FROM employees WHERE hire_date >= (CURDATE() - INTERVAL 30 DAY)")->fetch_assoc()['count'];
}

// Employee Distribution by Department
$employeeDistByDept = [];
$sectionsPerDept = [];
$leaveStats = [];
$appraisalCompletionByDept = [];

if ($has_hr_manager_access) {
    $resPie = $conn->query("
        SELECT d.name AS department_name, COUNT(e.id) AS employee_count
        FROM departments d
        LEFT JOIN employees e ON d.id = e.department_id AND e.employee_status = 'active'
        GROUP BY d.id, d.name
        HAVING employee_count > 0
        ORDER BY employee_count DESC
    ");
    while ($row = $resPie->fetch_assoc()) {
        $employeeDistByDept[$row['department_name']] = (int)$row['employee_count'];
    }

    // Sections per Department
    $res = $conn->query("
        SELECT d.name AS department_name, COUNT(s.id) AS section_count
        FROM departments d
        LEFT JOIN sections s ON d.id = s.department_id
        GROUP BY d.id
    ");
    while ($r = $res->fetch_assoc()) {
        $sectionsPerDept[$r['department_name']] = $r['section_count'];
    }

    // Leave Applications per Type
    $currentMonth = date('m');
    $currentYear = date('Y');
    $res2 = $conn->query("
        SELECT lt.name AS leave_type, COUNT(DISTINCT la.employee_id) AS employees_on_leave
        FROM leave_applications la
        JOIN leave_types lt ON la.leave_type_id = lt.id
        WHERE MONTH(la.applied_at) = '$currentMonth' AND YEAR(la.applied_at) = '$currentYear'
        GROUP BY lt.name
    ");
    while ($row = $res2->fetch_assoc()) {
        $leaveStats[$row['leave_type']] = $row['employees_on_leave'];
    }

    // Appraisal Completion by Department
    $res3 = $conn->query("
        SELECT 
            d.name AS department_name,
            COUNT(e.id) AS total_employees,
            SUM(CASE WHEN ea.status = 'submitted' THEN 1 ELSE 0 END) AS completed_appraisals
        FROM departments d
        INNER JOIN employees e ON d.id = e.department_id AND e.employee_status = 'active'
        LEFT JOIN employee_appraisals ea ON e.id = ea.employee_id
        LEFT JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id AND ac.status = 'active'
        GROUP BY d.id, d.name
        ORDER BY d.name
    ");

    while ($row = $res3->fetch_assoc()) {
        $dept = $row['department_name'] ?: 'Unassigned';
        $total = (int)$row['total_employees'];
        $completed = (int)$row['completed_appraisals'];
        $pending = max(0, $total - $completed);

        if ($total > 0) {
            $appraisalCompletionByDept[$dept] = [
                'completed' => $completed,
                'pending' => $pending
            ];
        }
    }
}

// Encode for JS
$sectionsPerDeptJSON = json_encode($sectionsPerDept);
$leaveStatsJSON = json_encode($leaveStats);
$appraisalCompletionByDeptJSON = json_encode($appraisalCompletionByDept);
$employeeDistByDeptJSON = json_encode($employeeDistByDept);

$conn->close();

include 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo htmlspecialchars($pageTitle); ?> - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <div class="content">

                <!-- Consolidated Message Display Area -->
                <div id="message-container">
                    <?php $flash = getFlashMessage(); if ($flash): ?>
                        <div class="alert alert-<?php echo htmlspecialchars($flash['type']); ?>">
                            <i class="fas 
                                <?php 
                                switch($flash['type']) {
                                    case 'success': echo 'fa-check-circle'; break;
                                    case 'danger': echo 'fa-exclamation-triangle'; break;
                                    case 'warning': echo 'fa-exclamation-circle'; break;
                                    default: echo 'fa-info-circle';
                                }
                                ?>
                            "></i> 
                            <?php echo htmlspecialchars($flash['message']); ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($success)): ?>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> <?= htmlspecialchars($success) ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($error)): ?>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i> <?= htmlspecialchars($error) ?>
                        </div>
                    <?php endif; ?>

                    <?php if (!empty($warning)): ?>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-circle"></i> <?= htmlspecialchars($warning) ?>
                        </div>
                    <?php endif; ?>

                    <?php if (isset($office_error)): ?>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i> <?= htmlspecialchars($office_error) ?>
                        </div>
                    <?php endif; ?>

                    <!-- Display already clocked message if applicable -->
                    <?php if (!empty($already_clocked_message)): ?>
                        <div class="alert alert-info" style="color: #dc3545; border-color: #dc3545;">
                            <i class="fas fa-info-circle"></i> <span style="color: #dc3545;"><?= $already_clocked_message ?></span>
                        </div>
                    <?php endif; ?>
                </div>

                <!-- Stats Cards with Integrated Attendance -->
                <div class="stats-grid">
                    <!-- Attendance Card - Integrated into stats grid -->
                    <?php if ($attendance_enabled && !isset($office_error)): ?>
                    <div class="stat-card attendance-card <?= $is_clocked_in ? 'attendance-active' : 'attendance-inactive' ?>">
                        <div class="attendance-status">
                            <div class="attendance-icon">
                                <i class="fas <?= $is_clocked_in ? 'fa-user-check' : 'fa-user-clock' ?>"></i>
                            </div>
                            <div class="attendance-info">
                                <h3><?= $is_clocked_in ? 'Clocked In' : 'Clocked Out' ?></h3>
                                <p><?= $is_clocked_in ? 'Tap to clock out' : 'Tap to clock in' ?></p>
                                <small>Geofence: <?= $geofence_radius ?>m radius</small>
                                <?php if ($is_clocked_in && $current_session): ?>
                                    <small>Since <?= date('g:i A', strtotime($current_session['clock_in'])) ?></small>
                                <?php endif; ?>
                                <?php if ($has_clocked_in_today): ?>
                                    <small>Today: <?= date('g:i A', strtotime($today_clock_in['clock_in'])) ?> - <?= date('g:i A', strtotime($today_clock_in['clock_out'])) ?></small>
                                <?php endif; ?>
                            </div>
                        </div>
                        <button id="clock-action-btn" class="attendance-btn <?= $button_class ?>" <?= $button_enabled ? '' : 'disabled' ?>>
                            <i class="fas <?= $button_action === 'clock_in' ? 'fa-sign-in-alt' : ($button_action === 'clock_out' ? 'fa-sign-out-alt' : 'fa-clock') ?>"></i>
                            <span style="<?= !$button_enabled ? 'color: #dc3545;' : '' ?>"><?= $button_text ?></span>
                        </button>
                    </div>
                    <?php endif; ?>
                    
                    <!-- HR Manager Only Stats -->
                    <?php if ($has_hr_manager_access): ?>
                    <div class="stat-card">
                        <h3><?php echo $totalEmployees; ?></h3>
                        <p>Active Employees</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $totalDepartments; ?></h3>
                        <p>Departments</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $totalSections; ?></h3>
                        <p>Sections</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $recentHires; ?></h3>
                        <p>New Hires (30 days)</p>
                    </div>
                    <?php endif; ?>
                    
                    <!-- New Quick Action Cards -->
                    <div class="stat-card action-card">
                        <div class="action-icon">
                            <i class="fas fa-calendar-plus"></i>
                        </div>
                        <div class="action-info">
                            <h3>Apply Leave</h3>
                            <p>Submit leave application</p>
                        </div>
                        <a href="leave_management.php" class="action-btn btn-leave">
                            <i class="fas fa-paper-plane"></i>
                            <span>Apply Leave</span>
                        </a>
                    </div>
                    
                    <div class="stat-card action-card">
                        <div class="action-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="action-info">
                            <h3>My Appraisal</h3>
                            <p>View performance reviews</p>
                        </div>
                        <a href="employee_appraisal.php" class="action-btn btn-appraisal">
                            <i class="fas fa-file-alt"></i>
                            <span>My Appraisal</span>
                        </a>
                    </div>
                </div>

                <!-- Status Messages -->
                <div id="status-message" class="status-message mt-3" style="display: none;"></div>

                <!-- Location Info -->
                <div id="location-info" class="location-info mt-3" style="display: none;">
                    <div class="location-details">
                        <div class="location-item">
                            <i class="fas fa-location-dot"></i>
                            <div>
                                <strong>Your Location</strong>
                                <span id="user-coords">-</span>
                            </div>
                        </div>
                        <div class="location-item">
                            <i class="fas fa-bullseye"></i>
                            <div>
                                <strong>Accuracy</strong>
                                <span id="location-accuracy">-</span>
                            </div>
                        </div>
                        <?php if ($attendance_enabled && !empty($employee_office)): ?>
                        <div class="location-item">
                            <i class="fas fa-building"></i>
                            <div>
                                <strong>Office Location</strong>
                                <span><?= $employee_office['latitude'] ?>, <?= $employee_office['longitude'] ?></span>
                            </div>
                        </div>
                        <div class="location-item">
                            <i class="fas fa-arrows-alt-h"></i>
                            <div>
                                <strong>Geofence Radius</strong>
                                <span><?= $geofence_radius ?> meters</span>
                            </div>
                        </div>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Analytics Section - Only for HR Managers -->
                <?php if ($has_hr_manager_access): ?>
                <div class="analytics-section glass-card">
                    <h3>Organizational Analytics</h3>
                    <div class="charts-grid">
                        <div class="chart-card">
                            <canvas id="employeeDistributionChart"></canvas>
                        </div>
                        <div class="chart-card">
                            <canvas id="sectionsChart"></canvas>
                        </div>
                        <div class="chart-card">
                            <canvas id="leaveChart"></canvas>
                        </div>
                        <div class="chart-card">
                            <canvas id="appraisalCompletionChart"></canvas>
                        </div>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Hidden Attendance Form -->
                <form id="attendance-form" method="POST" style="display:none;">
                    <input type="hidden" name="csrf" value="<?= $_SESSION['csrf'] ?>">
                    <input type="hidden" name="action" id="action-input">
                    <input type="hidden" name="latitude" id="latitude-input">
                    <input type="hidden" name="longitude" id="longitude-input">
                    <input type="hidden" name="accuracy" id="accuracy-input">
                </form>

            </div>
        </div>
    </div>

    <style>
    /* Message Container Styles */
    #message-container {
        margin-bottom: 1.5rem;
    }

    #message-container .alert {
        margin-bottom: 0.75rem;
        padding: 0.875rem 1.25rem;
        border-radius: 8px;
        border: 1px solid transparent;
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
        animation: slideInDown 0.3s ease-out;
    }

    #message-container .alert i {
        font-size: 1.1rem;
        margin-top: 0.125rem;
        flex-shrink: 0;
    }

    #message-container .alert-success {
        background: rgba(40, 167, 69, 0.1);
        color: var(--success-color);
        border-color: rgba(40, 167, 69, 0.3);
    }

    #message-container .alert-danger {
        background: rgba(220, 53, 69, 0.1);
        color: var(--error-color);
        border-color: rgba(220, 53, 69, 0.3);
    }

    #message-container .alert-warning {
        background: rgba(255, 193, 7, 0.1);
        color: var(--warning-color);
        border-color: rgba(255, 193, 7, 0.3);
    }

    #message-container .alert-info {
        background: rgba(52, 152, 219, 0.1);
        color: var(--primary-color);
        border-color: rgba(52, 152, 219, 0.3);
    }

    @keyframes slideInDown {
        from {
            transform: translateY(-10px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
        }
    }

    /* Attendance Card Styles */
    .attendance-card {
        position: relative;
        overflow: hidden;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .attendance-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        transition: all 0.3s ease;
    }

    .attendance-active::before {
        background: linear-gradient(90deg, var(--success-color), #00a085);
    }

    .attendance-inactive::before {
        background: linear-gradient(90deg, var(--secondary-color), var(--text-muted));
    }

    .attendance-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-glow);
    }

    .attendance-status {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    .attendance-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        transition: all 0.3s ease;
    }

    .attendance-active .attendance-icon {
        background: rgba(40, 167, 69, 0.2);
        color: var(--success-color);
        box-shadow: 0 0 20px rgba(40, 167, 69, 0.3);
    }

    .attendance-inactive .attendance-icon {
        background: rgba(108, 117, 125, 0.2);
        color: var(--secondary-color);
        box-shadow: 0 0 20px rgba(108, 117, 125, 0.2);
    }

    .attendance-info h3 {
        font-size: 1.1rem;
        font-weight: 600;
        margin: 0 0 0.25rem 0;
        background: none;
        -webkit-text-fill-color: initial;
        color: var(--text-primary);
    }

    .attendance-info p {
        color: var(--text-secondary);
        font-size: 0.875rem;
        margin: 0 0 0.25rem 0;
    }

    .attendance-info small {
        color: var(--text-muted);
        font-size: 0.75rem;
        font-style: italic;
        display: block;
        margin-bottom: 0.125rem;
    }

    .attendance-btn {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .btn-clock-in {
        background: linear-gradient(135deg, var(--success-color), #00a085);
        color: white;
        box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
    }

    .btn-clock-out {
        background: linear-gradient(135deg, var(--error-color), #d63031);
        color: white;
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
    }

    .btn-clock-in-disabled {
        background: rgba(108, 117, 125, 0.3);
        color: #dc3545;
        cursor: not-allowed;
        box-shadow: none;
    }

    .attendance-btn:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
    }

    .attendance-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
    }

    /* Action Card Styles */
    .action-card {
        position: relative;
        overflow: hidden;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .action-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        transition: all 0.3s ease;
    }

    .action-card:nth-child(6)::before { /* Apply Leave card */
        background: linear-gradient(90deg, #3498db, #2980b9);
    }

    .action-card:nth-child(7)::before { /* My Appraisal card */
        background: linear-gradient(90deg, #9b59b6, #8e44ad);
    }

    .action-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-glow);
    }

    .action-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
        transition: all 0.3s ease;
    }

    .action-card:nth-child(6) .action-icon {
        background: rgba(52, 152, 219, 0.2);
        color: #3498db;
        box-shadow: 0 0 20px rgba(52, 152, 219, 0.3);
    }

    .action-card:nth-child(7) .action-icon {
        background: rgba(155, 89, 182, 0.2);
        color: #9b59b6;
        box-shadow: 0 0 20px rgba(155, 89, 182, 0.3);
    }

    .action-info h3 {
        font-size: 1.1rem;
        font-weight: 600;
        margin: 0 0 0.25rem 0;
        background: none;
        -webkit-text-fill-color: initial;
        color: var(--text-primary);
    }

    .action-info p {
        color: var(--text-secondary);
        font-size: 0.875rem;
        margin: 0 0 1rem 0;
    }

    .action-btn {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        text-decoration: none;
        text-align: center;
    }

    .btn-leave {
        background: linear-gradient(135deg, #3498db, #2980b9);
        color: white;
        box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
    }

    .btn-appraisal {
        background: linear-gradient(135deg, #9b59b6, #8e44ad);
        color: white;
        box-shadow: 0 4px 12px rgba(155, 89, 182, 0.3);
    }

    .action-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        color: white;
        text-decoration: none;
    }

    /* Status Messages */
    .status-message {
        padding: 1rem 1.25rem;
        border-radius: 8px;
        text-align: center;
        font-weight: 500;
        margin-bottom: 1rem;
    }

    .status-message.success {
        background: rgba(40, 167, 69, 0.1);
        color: var(--success-color);
        border: 1px solid rgba(40, 167, 69, 0.3);
    }

    .status-message.warning {
        background: rgba(255, 193, 7, 0.1);
        color: var(--warning-color);
        border: 1px solid rgba(255, 193, 7, 0.3);
    }

    .status-message.error {
        background: rgba(220, 53, 69, 0.1);
        color: var(--error-color);
        border: 1px solid rgba(220, 53, 69, 0.3);
    }

    .status-message.info {
        background: rgba(52, 152, 219, 0.1);
        color: var(--primary-color);
        border: 1px solid rgba(52, 152, 219, 0.3);
    }

    /* Location Info */
    .location-info {
        background: var(--bg-glass);
        border-radius: 10px;
        padding: 1rem;
        border: 1px solid var(--border-color);
    }

    .location-details {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }

    .location-item {
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
    }

    .location-item i {
        color: var(--primary-color);
        margin-top: 0.125rem;
        font-size: 0.875rem;
    }

    .location-item div {
        display: flex;
        flex-direction: column;
    }

    .location-item strong {
        font-size: 0.75rem;
        color: var(--text-muted);
        margin-bottom: 0.25rem;
    }

    .location-item span {
        font-size: 0.75rem;
        font-family: monospace;
        color: var(--text-color);
    }

    .accuracy-good { color: var(--success-color); }
    .accuracy-medium { color: var(--warning-color); }
    .accuracy-poor { color: var(--error-color); }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .stats-grid {
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        }
        
        .attendance-status,
        .action-card > div:first-child {
            flex-direction: column;
            text-align: center;
            gap: 0.75rem;
        }
        
        .location-details {
            grid-template-columns: 1fr;
        }
        
        .attendance-btn,
        .action-btn {
            padding: 0.625rem 0.75rem;
            font-size: 0.8rem;
        }
        
        #message-container .alert {
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
        }
    }

    @media (max-width: 480px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .attendance-card,
        .action-card {
            min-height: 120px;
        }
        
        .location-details {
            grid-template-columns: 1fr;
        }
        
        #message-container .alert {
            flex-direction: column;
            text-align: center;
            gap: 0.5rem;
        }
    }
    </style>

    <script>
    // Enhanced location detection for both mobile and desktop - Dashboard Version with 200m radius
    <?php if ($attendance_enabled && !isset($office_error)): ?>
    document.addEventListener('DOMContentLoaded', function() {
        const clockActionBtn = document.getElementById('clock-action-btn');
        const statusMessage = document.getElementById('status-message');
        const locationInfo = document.getElementById('location-info');
        const userCoords = document.getElementById('user-coords');
        const locationAccuracy = document.getElementById('location-accuracy');
        const attendanceForm = document.getElementById('attendance-form');
        const actionInput = document.getElementById('action-input');
        const latitudeInput = document.getElementById('latitude-input');
        const longitudeInput = document.getElementById('longitude-input');
        const accuracyInput = document.getElementById('accuracy-input');

        let currentLocation = null;
        const officeLocation = {
            lat: <?= !empty($employee_office['latitude']) ? $employee_office['latitude'] : 0 ?>,
            lng: <?= !empty($employee_office['longitude']) ? $employee_office['longitude'] : 0 ?>
        };
        const geofenceRadius = <?= $geofence_radius ?>; // 200 meters
        const buttonEnabled = <?= $button_enabled ? 'true' : 'false' ?>;
        const buttonAction = '<?= $button_action ?>';

        // Custom alert function with red text
        function showRedAlert(message) {
            // Create modal overlay
            const overlay = document.createElement('div');
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 10000;
            `;
            
            // Create alert box
            const alertBox = document.createElement('div');
            alertBox.style.cssText = `
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                text-align: center;
                max-width: 400px;
                width: 90%;
                border-top: 4px solid #dc3545;
            `;
            
            // Create message with red color
            const messageEl = document.createElement('div');
            messageEl.style.cssText = `
                color: #dc3545;
                font-weight: bold;
                margin-bottom: 20px;
                font-size: 16px;
                line-height: 1.4;
            `;
            messageEl.innerHTML = '<i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i>' + message;
            
            // Create OK button
            const okButton = document.createElement('button');
            okButton.style.cssText = `
                background: #dc3545;
                color: white;
                border: none;
                padding: 10px 25px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
            `;
            okButton.textContent = 'OK';
            okButton.onclick = function() {
                document.body.removeChild(overlay);
            };
            
            // Assemble and show
            alertBox.appendChild(messageEl);
            alertBox.appendChild(okButton);
            overlay.appendChild(alertBox);
            document.body.appendChild(overlay);
            
            // Close on overlay click
            overlay.onclick = function(e) {
                if (e.target === overlay) {
                    document.body.removeChild(overlay);
                }
            };
            
            // Close on Escape key
            const closeOnEscape = function(e) {
                if (e.key === 'Escape') {
                    document.body.removeChild(overlay);
                    document.removeEventListener('keydown', closeOnEscape);
                }
            };
            document.addEventListener('keydown', closeOnEscape);
        }

        // Enhanced geolocation options
        const geolocationOptions = {
            enableHighAccuracy: true,    // Use GPS on mobile
            timeout: 30000,              // 30 seconds timeout
            maximumAge: 60000            // Cache location for 1 minute max
        };

        // Check geolocation support and permissions
        function checkGeolocationSupport() {
            if (!navigator.geolocation) {
                showStatusMessage('Geolocation is not supported by your browser. Please update your browser or use a different device.', 'error');
                clockActionBtn.disabled = true;
                clockActionBtn.innerHTML = '<i class="fas fa-times-circle"></i><span>Geolocation Not Supported</span>';
                return false;
            }
            
            // Check if we're on HTTP (mobile browsers block geolocation on HTTP)
            if (window.location.protocol === 'http:' && !window.location.hostname.includes('localhost')) {
                showStatusMessage('For better location accuracy on mobile devices, please use HTTPS. Location may be less accurate.', 'warning');
            }
            
            return true;
        }

        // Get location with multiple fallbacks
        function getCurrentLocation() {
            return new Promise((resolve, reject) => {
                if (!checkGeolocationSupport()) {
                    reject(new Error('Geolocation not supported'));
                    return;
                }

                let locationFound = false;
                let watchId = null;
                let timeoutId = null;

                // Clean up function
                const cleanup = () => {
                    if (watchId) navigator.geolocation.clearWatch(watchId);
                    if (timeoutId) clearTimeout(timeoutId);
                };

                // Timeout after 30 seconds
                timeoutId = setTimeout(() => {
                    cleanup();
                    if (!locationFound) {
                        reject(new Error('Location request timed out. Please ensure location services are enabled.'));
                    }
                }, 30000);

                // Try to get location with high accuracy first
                watchId = navigator.geolocation.watchPosition(
                    (position) => {
                        locationFound = true;
                        cleanup();
                        
                        const accuracy = position.coords.accuracy;
                        const altitudeAccuracy = position.coords.altitudeAccuracy;
                        
                        console.log('Location found - Accuracy:', accuracy, 'm', 
                                  'Altitude Accuracy:', altitudeAccuracy, 'm',
                                  'Source:', getLocationSource(position));
                        
                        resolve({
                            lat: position.coords.latitude,
                            lng: position.coords.longitude,
                            accuracy: accuracy,
                            altitude: position.coords.altitude,
                            altitudeAccuracy: altitudeAccuracy,
                            heading: position.coords.heading,
                            speed: position.coords.speed,
                            timestamp: position.timestamp
                        });
                    },
                    (error) => {
                        cleanup();
                        reject(error);
                    },
                    geolocationOptions
                );

                // Also try a one-time position as fallback
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        if (!locationFound) {
                            locationFound = true;
                            cleanup();
                            
                            const accuracy = position.coords.accuracy;
                            console.log('Fallback location - Accuracy:', accuracy, 'm');
                            
                            resolve({
                                lat: position.coords.latitude,
                                lng: position.coords.longitude,
                                accuracy: accuracy,
                                timestamp: position.timestamp
                            });
                        }
                    },
                    () => {
                        // Ignore errors here since we're using watchPosition as primary
                    },
                    {
                        enableHighAccuracy: false, // Faster but less accurate fallback
                        timeout: 10000,
                        maximumAge: 300000 // 5 minutes
                    }
                );
            });
        }

        // Detect location source for debugging
        function getLocationSource(position) {
            if (position.coords.accuracy < 50) return 'GPS';
            if (position.coords.accuracy < 1000) return 'WiFi';
            return 'IP/Network';
        }

        // Get accuracy class for styling
        function getAccuracyClass(accuracy) {
            if (accuracy < 50) return 'accuracy-good';
            if (accuracy < 100) return 'accuracy-medium';
            return 'accuracy-poor';
        }

        // Only add click handler if button is enabled
        if (buttonEnabled) {
            // Clock action button handler
            clockActionBtn.addEventListener('click', function() {
                const isClockIn = buttonAction === 'clock_in';
                
                // Update button state
                clockActionBtn.disabled = true;
                clockActionBtn.innerHTML = '<i class="fas fa-satellite-dish fa-spin"></i><span>Getting Location...</span>';
                
                // Clear previous messages
                hideStatusMessage();
                hideLocationInfo();

                // Show helpful message based on device type
                const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
                if (isMobile) {
                    showStatusMessage('Please ensure Location/GPS is enabled on your device and you are outdoors for best accuracy...', 'info');
                } else {
                    showStatusMessage('Detecting your location...', 'info');
                }

                getCurrentLocation()
                    .then((location) => {
                        currentLocation = location;
                        
                        // Show location info with accuracy
                        userCoords.textContent = `${location.lat.toFixed(6)}, ${location.lng.toFixed(6)}`;
                        locationAccuracy.innerHTML = `<span class="${getAccuracyClass(location.accuracy)}">±${Math.round(location.accuracy)}m</span>`;
                        showLocationInfo();
                        
                        // Calculate distance
                        const distance = calculateDistance(
                            location.lat, 
                            location.lng, 
                            officeLocation.lat, 
                            officeLocation.lng
                        );
                        
                        const distanceInMeters = Math.round(distance * 1000);
                        const locationSource = getLocationSource({ coords: location });
                        
                        // Check if within 200m geofence (only for clock in)
                        if (isClockIn && distance > (220 / 1000)) {
                            // Outside geofence - show warning
                            showStatusMessage(
                                `You are ${distanceInMeters}m away from office (max: ${geofenceRadius}m). Accuracy: ±${Math.round(location.accuracy)}m. Please move closer to clock in.`, 
                                'warning'
                            );
                            
                            // Reset button
                            resetButton();
                        } else {
                            // Within geofence or clocking out - proceed
                            let accuracyMessage = '';
                            if (location.accuracy > 150) {
                                accuracyMessage = ` (Accuracy: ±${Math.round(location.accuracy)}m - ${locationSource})`;
                                showStatusMessage(
                                    `Location verified! You are ${distanceInMeters}m from office.${accuracyMessage}`, 
                                    location.accuracy > 250 ? 'warning' : 'success'
                                );
                            } else {
                                accuracyMessage = ` (Good accuracy - ${locationSource})`;
                                showStatusMessage(
                                    `Location verified! You are ${distanceInMeters}m from office.${accuracyMessage}`, 
                                    'success'
                                );
                            }
                            
                            // Proceed with clock in/out
                            submitAttendance(buttonAction);
                        }
                    })
                    .catch((error) => {
                        console.error('Geolocation error:', error);
                        
                        let errorMessage = 'Location detection failed. ';
                        let detailedMessage = '';
                        
                        switch(error.code) {
                            case error.PERMISSION_DENIED:
                                errorMessage += 'Location access was denied. ';
                                detailedMessage = 'Please allow location access in your browser settings and try again.';
                                break;
                            case error.POSITION_UNAVAILABLE:
                                errorMessage += 'Location information unavailable. ';
                                detailedMessage = 'Please check that location services are enabled on your device.';
                                break;
                            case error.TIMEOUT:
                                errorMessage += 'Location request timed out. ';
                                detailedMessage = 'Please ensure you have a good GPS signal or internet connection.';
                                break;
                            default:
                                errorMessage += 'Please try again. ';
                                detailedMessage = error.message || 'Unknown error occurred.';
                        }
                        
                        // Additional mobile-specific guidance
                        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
                        if (isMobile) {
                            detailedMessage += ' On mobile: Ensure GPS/Location is enabled and try outdoors for better accuracy.';
                        }
                        
                        showStatusMessage(errorMessage + detailedMessage, 'error');
                        resetButton();
                    });
            });
        } else {
            // If button is disabled, show appropriate message when clicked
            clockActionBtn.addEventListener('click', function() {
                <?php if ($has_clocked_in_today): ?>
                    showRedAlert('You have already clocked in and out today. You can clock in again after 5 AM tomorrow.');
                <?php else: ?>
                    showRedAlert('Clock in is only available after 5 AM. Current time: <?= date("g:i A", $current_time) ?>');
                <?php endif; ?>
            });
        }

        function submitAttendance(action) {
            if (!currentLocation) {
                showStatusMessage('Location data not available. Please try again.', 'error');
                resetButton();
                return;
            }
            
            // Update button to show processing
            clockActionBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Processing...</span>';
            
            // Add a small delay to show the processing state
            setTimeout(() => {
                actionInput.value = action;
                latitudeInput.value = currentLocation.lat;
                longitudeInput.value = currentLocation.lng;
                accuracyInput.value = currentLocation.accuracy;
                attendanceForm.submit();
            }, 1500);
        }

        function showStatusMessage(message, type) {
            statusMessage.textContent = message;
            statusMessage.className = `status-message ${type}`;
            statusMessage.style.display = 'block';
            
            // Auto-hide info messages after 5 seconds
            if (type === 'info') {
                setTimeout(() => {
                    if (statusMessage.textContent === message) {
                        hideStatusMessage();
                    }
                }, 5000);
            }
        }

        function hideStatusMessage() {
            statusMessage.style.display = 'none';
        }

        function showLocationInfo() {
            locationInfo.style.display = 'block';
        }

        function hideLocationInfo() {
            locationInfo.style.display = 'none';
        }

        function resetButton() {
            clockActionBtn.disabled = false;
            clockActionBtn.innerHTML = '<i class="fas <?= $button_action === 'clock_in' ? 'fa-sign-in-alt' : ($button_action === 'clock_out' ? 'fa-sign-out-alt' : 'fa-clock') ?>"></i><span><?= $button_text ?></span>';
        }

        function calculateDistance(lat1, lon1, lat2, lon2) {
            const R = 6371;
            const dLat = (lat2 - lat1) * Math.PI / 180;
            const dLon = (lon2 - lon1) * Math.PI / 180;
            const a = Math.sin(dLat/2) ** 2 +
                      Math.cos(lat1 * Math.PI/180) * Math.cos(lat2 * Math.PI/180) *
                      Math.sin(dLon/2) ** 2;
            return R * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)));
        }
    });
    <?php endif; ?>

    // Charts Initialization - Only for HR Managers
    <?php if ($has_hr_manager_access): ?>
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeCharts);
    } else {
        initializeCharts();
    }

    function initializeCharts() {
        const chartIds = [
            'employeeDistributionChart',
            'sectionsChart', 
            'leaveChart',
            'appraisalCompletionChart'
        ];

        for (const chartId of chartIds) {
            if (!document.getElementById(chartId)) {
                console.warn(`Chart element '${chartId}' not found`);
                return;
            }
        }

        const isDarkMode = document.documentElement.getAttribute('data-theme') === 'dark';
        const textColor = isDarkMode ? '#ffffff' : '#212529';
        const gridColor = isDarkMode ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)';

        const chartAnimation = {
            duration: 1200,
            easing: 'easeOutQuart'
        };

        const sectionsPerDept = <?php echo $sectionsPerDeptJSON; ?>;
        const leaveStats = <?php echo $leaveStatsJSON; ?>;
        const appraisalData = <?php echo $appraisalCompletionByDeptJSON; ?>;
        const employeeDist = <?php echo $employeeDistByDeptJSON; ?>;

        // Chart 1: Employee Distribution Pie Chart
        try {
            const ctx1 = document.getElementById('employeeDistributionChart').getContext('2d');
            new Chart(ctx1, {
                type: 'pie',
                data: {
                    labels: Object.keys(employeeDist),
                    datasets: [{
                        data: Object.values(employeeDist),
                        backgroundColor: [
                            '#00d4ff', '#6c5ce7', '#ff3366', '#00b894', '#fdcb6e',
                            '#e17055', '#00cec9', '#ffeaa7', '#a29bfe', '#fd79a8'
                        ],
                        borderWidth: 2,
                        borderColor: 'rgba(0,0,0,0.1)'
                    }]
                },
                options: {
                    animation: chartAnimation,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Employee Distribution by Department',
                            color: textColor
                        },
                        legend: {
                            position: 'right',
                            labels: { color: textColor }
                        }
                    },
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        } catch (error) {
            console.error('Error creating employee distribution chart:', error);
        }

        // Chart 2: Sections per Department
        try {
            const ctx2 = document.getElementById('sectionsChart').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: Object.keys(sectionsPerDept),
                    datasets: [{
                        label: 'Sections per Department',
                        data: Object.values(sectionsPerDept),
                        backgroundColor: 'rgba(52, 152, 219, 0.7)',
                        borderColor: 'rgba(52, 152, 219, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    animation: chartAnimation,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Sections per Department',
                            color: textColor
                        },
                        legend: { display: false }
                    },
                    scales: {
                        x: {
                            ticks: { color: textColor },
                            grid: { color: gridColor }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: { color: textColor, stepSize: 1 },
                            grid: { color: gridColor }
                        }
                    },
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        } catch (error) {
            console.error('Error creating sections chart:', error);
        }

        // Chart 3: Leave Applications
        try {
            const ctx3 = document.getElementById('leaveChart').getContext('2d');
            new Chart(ctx3, {
                type: 'bar',
                data: {
                    labels: Object.keys(leaveStats),
                    datasets: [{
                        label: 'Employees on Leave (<?php echo date("F Y"); ?>)',
                        data: Object.values(leaveStats),
                        backgroundColor: 'rgba(230, 126, 34, 0.7)',
                        borderColor: 'rgba(230, 126, 34, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    animation: chartAnimation,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Leave Applications by Type (This Month)',
                            color: textColor
                        },
                        legend: { display: false }
                    },
                    scales: {
                        x: {
                            ticks: { color: textColor },
                            grid: { color: gridColor }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: { color: textColor, stepSize: 1 },
                            grid: { color: gridColor }
                        }
                    },
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        } catch (error) {
            console.error('Error creating leave chart:', error);
        }

        // Chart 4: Appraisal Completion
        try {
            const ctx4 = document.getElementById('appraisalCompletionChart').getContext('2d');
            const deptLabels = Object.keys(appraisalData);
            const completedData = Object.values(appraisalData).map(d => d.completed);
            const pendingData = Object.values(appraisalData).map(d => d.pending);

            new Chart(ctx4, {
                type: 'bar',
                data: {
                    labels: deptLabels,
                    datasets: [
                        {
                            label: 'Completed',
                            data: completedData,
                            backgroundColor: 'rgba(46, 204, 113, 0.8)',
                            borderColor: 'rgba(46, 204, 113, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pending',
                            data: pendingData,
                            backgroundColor: 'rgba(231, 76, 60, 0.8)',
                            borderColor: 'rgba(231, 76, 60, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    animation: chartAnimation,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Appraisal Completion by Department (Active Cycle)',
                            color: textColor
                        },
                        legend: {
                            labels: { color: textColor }
                        }
                    },
                    scales: {
                        x: {
                            stacked: true,
                            ticks: { color: textColor },
                            grid: { color: gridColor }
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            ticks: { color: textColor, stepSize: 1 },
                            grid: { color: gridColor }
                        }
                    },
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        } catch (error) {
            console.error('Error creating appraisal completion chart:', error);
        }
    }
    <?php endif; ?>
    </script>
</body>
</html>