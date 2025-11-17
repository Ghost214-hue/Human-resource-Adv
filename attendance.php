<?php
require_once 'config.php';
require_once 'auth.php';

// Set correct timezone for Kenya
date_default_timezone_set('Africa/Nairobi');

// Redirect if not logged in
if (!isset($_SESSION['employee_id'])) {
    header("Location: login.php");
    exit;
}
$has_dashboard_access = hasPermission('hr_manager');
$pageTitle = "Attendance System - MUWASCO HR";
require_once 'header.php';
require_once 'nav_bar.php';

// CSRF token generation
if (empty($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(32));
}

$session_employee_id = $_SESSION['employee_id'];

// First, let's find the correct employee database ID
$employee_lookup_stmt = $conn->prepare("
    SELECT id, employee_id, first_name, last_name, office_id 
    FROM employees 
    WHERE employee_id = ? OR id = ?
");
$employee_lookup_stmt->bind_param("ss", $session_employee_id, $session_employee_id);
$employee_lookup_stmt->execute();
$employee_data = $employee_lookup_stmt->get_result()->fetch_assoc();
$employee_lookup_stmt->close();

if (empty($employee_data)) {
    die("Error: Employee record not found. Please contact administrator.");
}

// Use the correct database ID
$employee_db_id = $employee_data['id'];
$actual_employee_id = $employee_data['employee_id'];

// Now get employee's assigned office using the correct database ID
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

// Debug information
echo "<!-- Debug: Office ID from query: " . ($employee_office['office_id'] ?? 'NULL') . " -->";
echo "<!-- Debug: Office Name: " . ($employee_office['office_name'] ?? 'NULL') . " -->";
echo "<!-- Debug: Coordinates: " . ($employee_office['latitude'] ?? 'NULL') . ', ' . ($employee_office['longitude'] ?? 'NULL') . " -->";
echo "<!-- Debug: Geofence Radius: " . $geofence_radius . "m -->";

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

// Check if employee has an active session (using database ID)
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

// Time-based logic implementation
$current_time = time();
$current_hour = (int)date('H', $current_time);
$current_date = date('Y-m-d');

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
$button_enabled = false;
$button_action = '';
$button_text = '';
$button_class = '';
$already_clocked_message = '';

if ($is_clocked_in) {
    // Currently clocked in - show clock out button
    $button_action = 'clock_out';
    $button_text = 'Clock Out';
    $button_class = 'btn-danger';
    $button_enabled = true;
} else {
    // Not currently clocked in
    if ($has_clocked_in_today) {
        // Already clocked in and out today - button should be disabled until 5 AM next day
        $button_action = '';
        $button_text = 'Clock In (Available at 5 AM)';
        $button_class = 'btn-secondary';
        $button_enabled = false;
        $already_clocked_message = "You have already clocked in and out today. You can clock in again after 5 AM tomorrow.";
    } else {
        // Hasn't clocked in today - check if it's after 5 AM
        if ($current_hour >= 5) {
            $button_action = 'clock_in';
            $button_text = 'Clock In';
            $button_class = 'btn-success';
            $button_enabled = true;
        } else {
            $button_action = '';
            $button_text = 'Clock In (Available at 5 AM)';
            $button_class = 'btn-secondary';
            $button_enabled = false;
        }
    }
}

// Handle form submission
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

        if (!isset($error)) {
            if ($action === 'clock_in') {
                if ($is_clocked_in) {
                    $error = "You are already clocked in. Please clock out first.";
                } else {
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
                            $error = "You are outside the authorized geo-fence (200m radius). Current distance: "
                                   . $distance_meters . " m ±" . round($accuracy) . "m";
                        } elseif ($accuracy > 150) {
                            $warning = "Location accuracy is low (±{$accuracy}m). For better results, ensure GPS is enabled and you're outdoors.";
                        }
                    } else {
                        $error = "Your assigned office location is not configured. Please contact HR.";
                    }
                }
            }

            if (!isset($error)) {
                if ($action === 'clock_in') {
                    $stmt = $conn->prepare("
                        INSERT INTO attendance (employee_id, office_id, clock_in, lat, lng, accuracy, status, created_at, updated_at)
                        VALUES (?, ?, NOW(), ?, ?, ?, 'clocked_in', NOW(), NOW())
                    ");
                    $stmt->bind_param("iiddd", $employee_db_id, $employee_office['office_id'], $latitude, $longitude, $accuracy);
                    if ($stmt->execute()) {
                        $success = "Successfully clocked in!";
                        $is_clocked_in = true;
                        
                        // Update button state
                        $button_action = 'clock_out';
                        $button_text = 'Clock Out';
                        $button_class = 'btn-danger';
                        $button_enabled = true;
                        $already_clocked_message = '';
                        
                        // Log the action
                        trackAction('CLOCK_IN', "Employee clocked in at office: {$employee_office['office_name']}", [
                            'employee_id' => $employee_db_id,
                            'office_id' => $employee_office['office_id'],
                            'coordinates' => "{$latitude}, {$longitude}",
                            'accuracy' => "{$accuracy}m",
                            'distance' => "{$distance_meters}m"
                        ]);
                    } else {
                        $error = "Failed to clock in. Please try again.";
                    }
                    $stmt->close();
                } elseif ($action === 'clock_out') {
                    if (!$is_clocked_in || empty($current_session)) {
                        $error = "You are not clocked in. Please clock in first.";
                    } else {
                        $stmt = $conn->prepare("
                            UPDATE attendance 
                            SET clock_out = NOW(), status = 'clocked_out', updated_at = NOW()
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
                                $button_class = 'btn-success';
                                $button_enabled = true;
                            } else {
                                $button_action = '';
                                $button_text = 'Clock In (Available at 5 AM)';
                                $button_class = 'btn-secondary';
                                $button_enabled = false;
                            }
                            
                            // Log the action
                            trackAction('CLOCK_OUT', "Employee clocked out from office: {$employee_office['office_name']}", [
                                'employee_id' => $employee_db_id,
                                'attendance_id' => $current_session['id']
                            ]);
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

// Attendance history (using database ID)
$history_stmt = $conn->prepare("
    SELECT a.*, o.name AS office_name 
    FROM attendance a 
    LEFT JOIN offices o ON a.office_id = o.id 
    WHERE a.employee_id = ? 
    ORDER BY a.clock_in DESC 
    LIMIT 50
");
$history_stmt->bind_param("i", $employee_db_id);
$history_stmt->execute();
$attendance_history = $history_stmt->get_result();
$history_stmt->close();

// Haversine distance in km
function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    $earth_radius = 6371;
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    $a = sin($dLat/2) ** 2 + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) ** 2;
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    return $earth_radius * $c;
}
?>

<div class="main-content">
    <div class="content">
        <div class="page-header">
            <h1>Attendance System</h1>
            <p>Geo-fenced Clock-In/Out System (200m Radius)</p>
        </div>

        <!-- Tabs Navigation -->
        <div class="tabs-container">
            <div class="tabs">
                <a href="attendance.php" class="tab active">
                    <i class="fas fa-user-clock"></i> My Attendance
                </a>
                <?php if ($has_dashboard_access): ?>
                <a href="attendance_dashboard.php" class="tab">
                    <i class="fas fa-chart-bar"></i> Attendance Dashboard
                </a>
                <?php endif; ?>
            </div>
        </div>

        <?php if (isset($success)): ?>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <?= $success ?></div>
        <?php elseif (isset($error)): ?>
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> <?= $error ?></div>
        <?php elseif (isset($warning)): ?>
            <div class="alert alert-warning"><i class="fas fa-exclamation-circle"></i> <?= $warning ?></div>
        <?php endif; ?>

        <!-- Display already clocked message if applicable -->
        <?php if (!empty($already_clocked_message)): ?>
            <div class="alert alert-info" style="color: #dc3545; border-color: #dc3545;">
                <i class="fas fa-info-circle"></i> <span style="color: #dc3545;"><?= $already_clocked_message ?></span>
            </div>
        <?php endif; ?>

        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-user-clock"></i> Current Status</h3>
            </div>
            <div class="card-body">
                <div class="status-info">
                    <div class="status-item">
                        <strong>Assigned Office:</strong>
                        <span><?= htmlspecialchars($employee_office['office_name'] ?? 'Not assigned') ?></span>
                    </div>
                    <div class="status-item">
                        <strong>Geofence Radius:</strong>
                        <span><?= $geofence_radius ?> meters</span>
                    </div>
                    <div class="status-item">
                        <strong>Current Status:</strong>
                        <span class="badge <?= $is_clocked_in ? 'badge-success' : 'badge-secondary' ?>">
                            <?= $is_clocked_in ? 'CLOCKED IN' : 'CLOCKED OUT' ?>
                        </span>
                    </div>
                    <?php if ($is_clocked_in && $current_session): ?>
                        <div class="status-item">
                            <strong>Clocked In Since:</strong>
                            <span><?= date('M j, Y g:i A', strtotime($current_session['clock_in'])) ?></span>
                        </div>
                    <?php endif; ?>
                    <div class="status-item">
                        <strong>Current Time:</strong>
                        <span><?= date('M j, Y g:i A', $current_time) ?></span>
                    </div>
                    <?php if ($has_clocked_in_today): ?>
                        <div class="status-item">
                            <strong>Today's Clock In:</strong>
                            <span><?= date('g:i A', strtotime($today_clock_in['clock_in'])) ?></span>
                        </div>
                        <div class="status-item">
                            <strong>Today's Clock Out:</strong>
                            <span><?= date('g:i A', strtotime($today_clock_in['clock_out'])) ?></span>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-map-marker-alt"></i> Geo-fenced Attendance</h3>
            </div>
            <div class="card-body">
                <?php if (isset($office_error)): ?>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <?= $office_error ?>
                        
                        <!-- Debug info for admin -->
                        <?php if (hasPermission('hr_manager')): ?>
                            <div class="mt-2">
                                <small class="text-muted">
                                    Debug Info:<br>
                                    Employee ID: <?= $employee_db_id ?><br>
                                    Office ID: <?= $employee_office['office_id'] ?? 'NULL' ?><br>
                                    Office Name: <?= $employee_office['office_name'] ?? 'NULL' ?><br>
                                    Coordinates: <?= ($employee_office['latitude'] ?? 'NULL') . ', ' . ($employee_office['longitude'] ?? 'NULL') ?><br>
                                    Geofence Radius: <?= $geofence_radius ?>m
                                </small>
                            </div>
                        <?php endif; ?>
                    </div>
                <?php else: ?>
                    <!-- Location Radar Container -->
                    <div class="location-radar-container">
                        <div class="radar-wrapper">
                            <div class="radar-background">
                                <div class="radar-sweep"></div>
                                <div class="radar-center"></div>
                                <div class="radar-rings">
                                    <div class="ring ring-1"></div>
                                    <div class="ring ring-2"></div>
                                    <div class="ring ring-3"></div>
                                </div>
                            </div>
                            <div class="radar-status">
                                <div id="radar-message" class="radar-message">
                                    <i class="fas fa-user-clock"></i>
                                    <?php if ($button_enabled): ?>
                                        Ready to clock <?= $button_action === 'clock_in' ? 'in' : 'out' ?>
                                    <?php else: ?>
                                        <?= $has_clocked_in_today ? 'Already clocked in today' : 'Clock in available at 5 AM' ?>
                                    <?php endif; ?>
                                </div>
                                <div id="radar-distance" class="radar-distance"></div>
                                <div id="radar-accuracy" class="radar-accuracy" style="display: none;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Combined Clock In/Out Button -->
                    <div class="action-buttons text-center">
                        <button id="clock-action-btn" class="btn <?= $button_class ?> btn-lg" <?= $button_enabled ? '' : 'disabled' ?>>
                            <i class="fas <?= $button_action === 'clock_in' ? 'fa-sign-in-alt' : ($button_action === 'clock_out' ? 'fa-sign-out-alt' : 'fa-clock') ?>"></i> 
                            <span style="<?= !$button_enabled ? 'color: #dc3545;' : '' ?>"><?= $button_text ?></span>
                        </button>
                    </div>

                    <!-- Location Details -->
                    <div id="location-details" class="location-details mt-3" style="display: none;">
                        <div class="row text-center">
                            <div class="col-md-4">
                                <small class="text-muted">
                                    <i class="fas fa-location-dot"></i><br>
                                    <strong>Your Location</strong><br>
                                    <span id="user-coords">-</span>
                                </small>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">
                                    <i class="fas fa-bullseye"></i><br>
                                    <strong>Accuracy</strong><br>
                                    <span id="location-accuracy">-</span>
                                </small>
                            </div>
                            <div class="col-md-4">
                                <small class="text-muted">
                                    <i class="fas fa-building"></i><br>
                                    <strong>Office Location</strong><br>
                                    <?= $employee_office['latitude'] ?>, <?= $employee_office['longitude'] ?>
                                </small>
                            </div>
                        </div>
                    </div>

                    <form id="attendance-form" method="POST" style="display:none;">
                        <input type="hidden" name="csrf" value="<?= $_SESSION['csrf'] ?>">
                        <input type="hidden" name="action" id="action-input">
                        <input type="hidden" name="latitude" id="latitude-input">
                        <input type="hidden" name="longitude" id="longitude-input">
                        <input type="hidden" name="accuracy" id="accuracy-input">
                    </form>
                <?php endif; ?>
            </div>
        </div>

        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-history"></i> Attendance History</h3>
            </div>
            <div class="card-body">
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Office</th>
                                <th>Clock In</th>
                                <th>Clock Out</th>
                                <th>Duration</th>
                                <th>Location</th>
                                <th>Accuracy</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php while($record = $attendance_history->fetch_assoc()): ?>
                            <tr>
                                <td><?= date('M j, Y', strtotime($record['clock_in'])) ?></td>
                                <td><?= htmlspecialchars($record['office_name']) ?></td>
                                <td><?= date('g:i A', strtotime($record['clock_in'])) ?></td>
                                <td><?= $record['clock_out'] ? date('g:i A', strtotime($record['clock_out'])) : '--' ?></td>
                                <td>
                                    <?php
                                    if ($record['clock_out']) {
                                        $diff = strtotime($record['clock_out']) - strtotime($record['clock_in']);
                                        $hours = floor($diff / 3600);
                                        $minutes = floor(($diff % 3600) / 60);
                                        echo sprintf("%02d:%02d", $hours, $minutes);
                                    } else echo '--';
                                    ?>
                                </td>
                                <td><small><?= round($record['lat'], 6) ?>, <?= round($record['lng'], 6) ?></small></td>
                                <td>
                                    <?php if ($record['accuracy']): ?>
                                        <small>±<?= round($record['accuracy']) ?>m</small>
                                    <?php else: ?>
                                        <small>--</small>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <span class="badge badge-<?=
                                        $record['status'] === 'clocked_in' ? 'success' :
                                        ($record['status'] === 'clocked_out' ? 'primary' : 'secondary')
                                    ?>">
                                        <?= strtoupper(str_replace('_', ' ', $record['status'])) ?>
                                    </span>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                        <?php if ($attendance_history->num_rows === 0): ?>
                            <tr><td colspan="8" class="text-center text-muted">No attendance records found.</td></tr>
                        <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Enhanced location detection for mobile and desktop with 200m radius
document.addEventListener('DOMContentLoaded', function() {
    const clockActionBtn = document.getElementById('clock-action-btn');
    const locationDetails = document.getElementById('location-details');
    const userCoords = document.getElementById('user-coords');
    const locationAccuracy = document.getElementById('location-accuracy');
    const radarMessage = document.getElementById('radar-message');
    const radarDistance = document.getElementById('radar-distance');
    const radarAccuracy = document.getElementById('radar-accuracy');
    const radarWrapper = document.querySelector('.radar-wrapper');
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

    // Enhanced geolocation options for better mobile support
    const geolocationOptions = {
        enableHighAccuracy: true,    // Use GPS on mobile
        timeout: 30000,              // 30 seconds timeout (increased for mobile)
        maximumAge: 60000            // Cache location for 1 minute max
    };

    // Check if geolocation is supported
    if (!navigator.geolocation) {
        radarMessage.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Geolocation not supported';
        radarMessage.style.color = 'var(--error-color)';
        clockActionBtn.disabled = true;
        clockActionBtn.innerHTML = '<i class="fas fa-times-circle"></i> Geolocation Not Supported';
        return;
    }

    // Get accuracy class for styling
    function getAccuracyClass(accuracy) {
        if (accuracy < 50) return 'accuracy-good';
        if (accuracy < 100) return 'accuracy-medium';
        return 'accuracy-poor';
    }

    // Detect location source for better user feedback
    function getLocationSource(position) {
        const accuracy = position.coords.accuracy;
        if (accuracy < 50) return 'GPS';
        if (accuracy < 1000) return 'WiFi';
        return 'IP/Network';
    }

    // Enhanced location detection with better mobile support
    function getEnhancedLocation() {
        return new Promise((resolve, reject) => {
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

            // Try to get location with high accuracy first (better for mobile GPS)
            watchId = navigator.geolocation.watchPosition(
                (position) => {
                    locationFound = true;
                    cleanup();
                    
                    const accuracy = position.coords.accuracy;
                    console.log('Enhanced location found - Accuracy:', accuracy, 'm', 'Source:', getLocationSource(position));
                    
                    resolve({
                        lat: position.coords.latitude,
                        lng: position.coords.longitude,
                        accuracy: accuracy,
                        timestamp: position.timestamp
                    });
                },
                (error) => {
                    cleanup();
                    reject(error);
                },
                geolocationOptions
            );

            // Fallback: Also try a one-time position
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    if (!locationFound) {
                        locationFound = true;
                        cleanup();
                        resolve({
                            lat: position.coords.latitude,
                            lng: position.coords.longitude,
                            accuracy: position.coords.accuracy,
                            timestamp: position.timestamp
                        });
                    }
                },
                () => {
                    // Ignore errors here since we're using watchPosition as primary
                },
                {
                    enableHighAccuracy: false, // Faster fallback
                    timeout: 10000,
                    maximumAge: 300000
                }
            );
        });
    }

    // Only add click handler if button is enabled
    if (buttonEnabled) {
        // Clock action button handler - Enhanced for mobile with 200m radius
        clockActionBtn.addEventListener('click', function() {
            const isClockIn = clockActionBtn.textContent.includes('Clock In');
            clockActionBtn.disabled = true;
            clockActionBtn.innerHTML = '<i class="fas fa-sync fa-spin"></i> Scanning Location...';
            
            // Reset radar state
            radarWrapper.classList.remove('radar-scanning', 'radar-success', 'radar-warning', 'radar-error');
            radarAccuracy.style.display = 'none';
            
            // Start radar animation
            setTimeout(() => {
                radarWrapper.classList.add('radar-scanning');
            }, 100);
            
            radarMessage.innerHTML = '<i class="fas fa-satellite-dish"></i> Scanning your location...';
            radarMessage.style.color = 'var(--primary-color)';
            radarDistance.textContent = '';
            radarAccuracy.textContent = '';

            // Show device-specific guidance
            const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
            if (isMobile) {
                radarDistance.textContent = 'For best accuracy, ensure GPS is enabled';
            }

            getEnhancedLocation()
                .then(function(position) {
                    currentLocation = {
                        lat: position.lat,
                        lng: position.lng,
                        accuracy: position.accuracy
                    };
                    
                    // Update user coordinates display
                    userCoords.textContent = `${currentLocation.lat.toFixed(6)}, ${currentLocation.lng.toFixed(6)}`;
                    locationAccuracy.innerHTML = `<span class="${getAccuracyClass(currentLocation.accuracy)}">±${Math.round(currentLocation.accuracy)}m</span>`;
                    locationDetails.style.display = 'block';
                    
                    // Calculate distance
                    const distance = calculateDistance(
                        currentLocation.lat, 
                        currentLocation.lng, 
                        officeLocation.lat, 
                        officeLocation.lng
                    );
                    
                    const distanceInMeters = Math.round(distance * 1000);
                    const locationSource = getLocationSource({ coords: { accuracy: currentLocation.accuracy } });
                    
                    // Stop scanning animation
                    radarWrapper.classList.remove('radar-scanning');
                    
                    // Check if within 200m geofence (with 220m tolerance for clock in)
                    if (isClockIn && distance > (220 / 1000)) {
                        // Warning state - outside geofence for clock in
                        radarWrapper.classList.add('radar-warning');
                        radarMessage.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Too Far From Office';
                        radarMessage.style.color = 'var(--warning-color)';
                        radarDistance.textContent = `${distanceInMeters}m from office (max: ${geofenceRadius}m)`;
                        radarDistance.style.color = 'var(--warning-color)';
                        radarAccuracy.textContent = `Accuracy: ±${Math.round(currentLocation.accuracy)}m (${locationSource})`;
                        radarAccuracy.style.display = 'block';
                        radarAccuracy.className = `radar-accuracy ${getAccuracyClass(currentLocation.accuracy)}`;
                        
                        // Reset button for clock in
                        clockActionBtn.disabled = false;
                        clockActionBtn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Clock In';
                        
                        // Show error message with mobile-specific guidance
                        const errorMsg = `You are ${distanceInMeters}m away from the office (maximum: ${geofenceRadius}m). Please move closer to your assigned office location.`;
                        
                        setTimeout(() => {
                            alert(errorMsg);
                        }, 500);
                    } else {
                        // Success state - within geofence or clocking out
                        radarWrapper.classList.add('radar-success');
                        radarMessage.innerHTML = '<i class="fas fa-check-circle"></i> Location Verified!';
                        radarMessage.style.color = 'var(--success-color)';
                        radarDistance.textContent = `${distanceInMeters}m from office`;
                        radarDistance.style.color = 'var(--success-color)';
                        
                        // Show accuracy info
                        radarAccuracy.textContent = `Accuracy: ±${Math.round(currentLocation.accuracy)}m (${locationSource})`;
                        radarAccuracy.style.display = 'block';
                        radarAccuracy.className = `radar-accuracy ${getAccuracyClass(currentLocation.accuracy)}`;
                        
                        // Proceed with clock in/out
                        submitAttendance(isClockIn ? 'clock_in' : 'clock_out');
                    }
                })
                .catch(function(error) {
                    // Error state
                    radarWrapper.classList.remove('radar-scanning');
                    radarWrapper.classList.add('radar-error');
                    
                    let errorMessage = 'Location scan failed. ';
                    let detailedMessage = '';
                    
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            errorMessage += 'Location access was denied. ';
                            detailedMessage = 'Please allow location access in your browser settings.';
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMessage += 'Location information is unavailable. ';
                            detailedMessage = 'Check your device location services and ensure GPS is enabled.';
                            break;
                        case error.TIMEOUT:
                            errorMessage += 'Location request timed out. ';
                            detailedMessage = 'Please ensure you have a good GPS signal or internet connection.';
                            break;
                        default:
                            errorMessage += 'Please try again.';
                            detailedMessage = error.message || 'Unknown error occurred.';
                    }

                    // Mobile-specific guidance
                    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
                    if (isMobile) {
                        detailedMessage += ' On mobile: Go outdoors for better GPS signal.';
                    }
                    
                    radarMessage.innerHTML = `<i class="fas fa-exclamation-triangle"></i> ${errorMessage}`;
                    radarMessage.style.color = 'var(--error-color)';
                    radarDistance.textContent = detailedMessage;
                    radarDistance.style.color = 'var(--error-color)';
                    
                    clockActionBtn.disabled = false;
                    clockActionBtn.innerHTML = clockActionBtn.textContent.includes('Clock In') ? 
                        '<i class="fas fa-sign-in-alt"></i> Clock In' : 
                        '<i class="fas fa-sign-out-alt"></i> Clock Out';
                });
        });
    } else {
        // If button is disabled, show appropriate message when clicked
        clockActionBtn.addEventListener('click', function() {
            <?php if ($has_clocked_in_today): ?>
                alert('You have already clocked in and out today. You can clock in again after 5 AM tomorrow.');
            <?php else: ?>
                alert('Clock in is only available after 5 AM. Current time: <?= date("g:i A", $current_time) ?>');
            <?php endif; ?>
        });
    }

    function submitAttendance(action) {
        if (!currentLocation) {
            alert('Location scan failed. Please try again.');
            clockActionBtn.disabled = false;
            clockActionBtn.innerHTML = action === 'clock_in' ? 
                '<i class="fas fa-sign-in-alt"></i> Clock In' : 
                '<i class="fas fa-sign-out-alt"></i> Clock Out';
            return;
        }
        
        // Update button to show processing
        clockActionBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        
        setTimeout(() => {
            actionInput.value = action;
            latitudeInput.value = currentLocation.lat;
            longitudeInput.value = currentLocation.lng;
            accuracyInput.value = currentLocation.accuracy;
            attendanceForm.submit();
        }, 1000);
    }

    function calculateDistance(lat1, lon1, lat2, lon2) {
        const R = 6371;
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a =
 Math.sin(dLat/2) ** 2 +
                  Math.cos(lat1 * Math.PI/180) * Math.cos(lat2 * Math.PI/180) *
                  Math.sin(dLon/2) ** 2;
        return R * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)));
    }
});
</script>