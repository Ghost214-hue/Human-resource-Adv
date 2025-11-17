<?php
require_once 'config.php';
require_once 'auth.php';

// Check permissions
if (!hasPermission('hr_manager')) {
    header("Location: attendance.php");
    exit;
}

$pageTitle = "Attendance Dashboard - MUWASCO HR";
require_once 'header.php';
require_once 'nav_bar.php';

// Get filter parameters
$filter_date = $_GET['date'] ?? date('Y-m-d');
$filter_office = $_GET['office'] ?? 'all';
$filter_status = $_GET['status'] ?? 'all';
$absent_date = $_GET['absent_date'] ?? $filter_date; // Separate date for absent filtering

// Get all offices for filter
$offices_query = "SELECT id, name FROM offices ORDER BY name";
$offices_result = $conn->query($offices_query);

// Get today's attendance with real-time status
$attendance_query = "
    SELECT 
        a.id,
        a.clock_in,
        a.clock_out,
        a.lat,
        a.lng,
        a.accuracy,
        a.status,
        e.id as employee_id,
        e.employee_id as emp_number,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        o.name as office_name,
        o.latitude as office_lat,
        o.longitude as office_lng,
        TIMESTAMPDIFF(SECOND, a.clock_in, COALESCE(a.clock_out, NOW())) as duration_seconds
    FROM attendance a
    INNER JOIN employees e ON a.employee_id = e.id
    INNER JOIN offices o ON a.office_id = o.id
    WHERE DATE(a.clock_in) = ?
";

if ($filter_office !== 'all') {
    $attendance_query .= " AND a.office_id = " . intval($filter_office);
}

if ($filter_status !== 'all') {
    $attendance_query .= " AND a.status = '" . $conn->real_escape_string($filter_status) . "'";
}

$attendance_query .= " ORDER BY a.clock_in DESC";

$stmt = $conn->prepare($attendance_query);
$stmt->bind_param("s", $filter_date);
$stmt->execute();
$attendance_records = $stmt->get_result();
$stmt->close();

// Get statistics
$stats_query = "
    SELECT 
        COUNT(DISTINCT a.employee_id) as total_employees,
        COUNT(CASE WHEN a.status = 'clocked_in' THEN 1 END) as currently_in,
        COUNT(CASE WHEN a.status = 'clocked_out' THEN 1 END) as clocked_out,
        AVG(CASE WHEN a.clock_out IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, a.clock_in, a.clock_out) / 60.0 
            END) as avg_hours,
        COUNT(CASE WHEN a.accuracy > 50 THEN 1 END) as low_accuracy_count
    FROM attendance a
    WHERE DATE(a.clock_in) = ?
";

if ($filter_office !== 'all') {
    $stats_query .= " AND a.office_id = " . intval($filter_office);
}

$stats_stmt = $conn->prepare($stats_query);
$stats_stmt->bind_param("s", $filter_date);
$stats_stmt->execute();
$stats = $stats_stmt->get_result()->fetch_assoc();
$stats_stmt->close();

// Get employees on leave for the selected date
$on_leave_query = "
    SELECT DISTINCT e.id as employee_id
    FROM leave_applications la
    INNER JOIN employees e ON la.employee_id = e.id
    WHERE la.status = 'approved'
    AND ? BETWEEN la.start_date AND la.end_date
";

if ($filter_office !== 'all') {
    $on_leave_query .= " AND e.office_id = " . intval($filter_office);
}

$on_leave_stmt = $conn->prepare($on_leave_query);
$on_leave_stmt->bind_param("s", $absent_date);
$on_leave_stmt->execute();
$on_leave_result = $on_leave_stmt->get_result();
$on_leave_employees = [];
while($row = $on_leave_result->fetch_assoc()) {
    $on_leave_employees[] = $row['employee_id'];
}
$on_leave_stmt->close();

// Get absent employees for the selected date - EXCLUDING THOSE ON LEAVE
$absent_query = "
    SELECT 
        e.id,
        e.employee_id as emp_number,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        o.name as office_name,
        d.name as department_name
    FROM employees e
    INNER JOIN offices o ON e.office_id = o.id
    LEFT JOIN departments d ON e.department_id = d.id
    WHERE e.employee_status = 'active'
    AND e.id NOT IN (
        SELECT DISTINCT employee_id 
        FROM attendance 
        WHERE DATE(clock_in) = ?
    )
";

// Exclude employees who are on leave
if (!empty($on_leave_employees)) {
    $absent_query .= " AND e.id NOT IN (" . implode(',', array_map('intval', $on_leave_employees)) . ")";
}

if ($filter_office !== 'all') {
    $absent_query .= " AND e.office_id = " . intval($filter_office);
}

$absent_query .= " ORDER BY o.name, e.first_name, e.last_name";

$absent_stmt = $conn->prepare($absent_query);
$absent_stmt->bind_param("s", $absent_date);
$absent_stmt->execute();
$absent_employees = $absent_stmt->get_result();
$absent_stmt->close();

// Get total active employees
$total_employees_query = "
    SELECT COUNT(*) as total_active 
    FROM employees 
    WHERE employee_status = 'active'
";
if ($filter_office !== 'all') {
    $total_employees_query .= " AND office_id = " . intval($filter_office);
}

$total_result = $conn->query($total_employees_query);
$total_employees_data = $total_result->fetch_assoc();
$total_employees = $total_employees_data['total_active'] ?? 0;

// Update statistics
$stats['absent_employees'] = $absent_employees->num_rows;
$stats['total_active'] = $total_employees;
$stats['on_leave'] = count($on_leave_employees);

// Calculate present percentage
$present_percentage = $total_employees > 0 ? round(($stats['total_employees'] / $total_employees) * 100, 1) : 0;

// Get office-wise breakdown
$office_stats_query = "
    SELECT 
        o.name as office_name,
        COUNT(DISTINCT a.employee_id) as total_employees,
        COUNT(CASE WHEN a.status = 'clocked_in' THEN 1 END) as currently_in,
        AVG(CASE WHEN a.clock_out IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, a.clock_in, a.clock_out) / 60.0 
            END) as avg_hours
    FROM attendance a
    INNER JOIN offices o ON a.office_id = o.id
    WHERE DATE(a.clock_in) = ?
    GROUP BY o.id, o.name
    ORDER BY currently_in DESC, total_employees DESC
";

$office_stats_stmt = $conn->prepare($office_stats_query);
$office_stats_stmt->bind_param("s", $filter_date);
$office_stats_stmt->execute();
$office_stats = $office_stats_stmt->get_result();
$office_stats_stmt->close();

function calculateDistance($lat1, $lon1, $lat2, $lon2) {
    $earth_radius = 6371;
    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);
    $a = sin($dLat/2) ** 2 + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) ** 2;
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    return $earth_radius * $c;
}
?>

<style>
.dashboard-stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 2rem;
}

.stat-card {
    background: linear-gradient(135deg, rgba(74, 144, 226, 0.1) 0%, rgba(74, 144, 226, 0.05) 100%);
    border-radius: 12px;
    padding: 1.5rem;
    border: 1px solid rgba(74, 144, 226, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(74, 144, 226, 0.2);
}

.stat-card.absent-stats {
    background: linear-gradient(135deg, rgba(220, 53, 69, 0.1) 0%, rgba(220, 53, 69, 0.05) 100%);
    border: 1px solid rgba(220, 53, 69, 0.2);
}

.stat-card.leave-stats {
    background: linear-gradient(135deg, rgba(255, 193, 7, 0.1) 0%, rgba(255, 193, 7, 0.05) 100%);
    border: 1px solid rgba(255, 193, 7, 0.2);
}

.stat-icon {
    font-size: 2rem;
    margin-bottom: 0.5rem;
    opacity: 0.8;
}

.stat-value {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--primary-color);
    margin: 0.5rem 0;
}

.stat-label {
    font-size: 0.9rem;
    color: rgba(255, 255, 255, 0.7);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.filter-section {
    background: rgba(255, 255, 255, 0.05);
    padding: 1.5rem;
    border-radius: 12px;
    margin-bottom: 2rem;
}

.filter-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    align-items: end;
}

.filter-group {
    display: flex;
    flex-direction: column;
}

.filter-group label {
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
    color: rgba(255, 255, 255, 0.8);
}

.real-time-indicator {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: rgba(40, 167, 69, 0.2);
    border-radius: 20px;
    font-size: 0.9rem;
}

.pulse-dot {
    width: 8px;
    height: 8px;
    background: var(--success-color);
    border-radius: 50%;
    animation: pulse-dot 2s ease-in-out infinite;
}

@keyframes pulse-dot {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.5; transform: scale(1.2); }
}

.office-breakdown {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
    margin-bottom: 2rem;
}

.office-card {
    background: rgba(255, 255, 255, 0.05);
    padding: 1rem;
    border-radius: 8px;
    border-left: 4px solid var(--primary-color);
}

.office-card h4 {
    margin: 0 0 0.5rem 0;
    color: var(--primary-color);
}

.office-metric {
    display: flex;
    justify-content: space-between;
    padding: 0.25rem 0;
    font-size: 0.9rem;
}

.attendance-table-wrapper {
    overflow-x: auto;
}

.location-badge {
    display: inline-block;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 600;
}

.location-verified {
    background: rgba(40, 167, 69, 0.2);
    color: var(--success-color);
}

.location-suspicious {
    background: rgba(255, 193, 7, 0.2);
    color: var(--warning-color);
}

.export-buttons {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.live-duration {
    font-family: 'Courier New', monospace;
    font-weight: 700;
    color: var(--success-color);
}

.badge-danger {
    background: rgba(220, 53, 69, 0.2);
    color: var(--danger-color);
    border: 1px solid rgba(220, 53, 69, 0.3);
}

.badge-warning {
    background: rgba(255, 193, 7, 0.2);
    color: var(--warning-color);
    border: 1px solid rgba(255, 193, 7, 0.3);
}

.absent-table {
    margin-top: 2rem;
}

.text-muted i {
    margin-right: 0.5rem;
}

.accuracy-indicator {
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: 600;
}

.accuracy-high {
    background: rgba(40, 167, 69, 0.2);
    color: var(--success-color);
}

.accuracy-medium {
    background: rgba(255, 193, 7, 0.2);
    color: var(--warning-color);
}

.accuracy-low {
    background: rgba(220, 53, 69, 0.2);
    color: var(--danger-color);
}

.present-percentage {
    font-size: 0.8rem;
    color: rgba(255, 255, 255, 0.6);
    margin-top: 0.25rem;
}

.attendance-rate {
    font-size: 0.9rem;
    color: var(--success-color);
    font-weight: 600;
    margin-top: 0.5rem;
}

.absent-filters {
    background: rgba(255, 255, 255, 0.05);
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
}

.absent-filters .filter-row {
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
}
</style>

<div class="main-content">
    <div class="content">
        <div class="page-header">
            <h1><i class="fas fa-chart-bar"></i> Attendance Dashboard</h1>
            <div class="real-time-indicator">
                <span class="pulse-dot"></span>
                <span>Real-Time Monitoring</span>
            </div>
        </div>

        <!-- Tabs Navigation -->
        <div class="tabs-container">
            <div class="tabs">
                <a href="attendance.php" class="tab">
                    <i class="fas fa-user-clock"></i> My Attendance
                </a>
                <a href="attendance_dashboard.php" class="tab active">
                    <i class="fas fa-chart-bar"></i> Attendance Dashboard
                </a>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="dashboard-stats">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-value"><?= $stats['total_active'] ?? 0 ?></div>
                <div class="stat-label">Total Active Employees</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-user-check" style="color: var(--success-color);"></i></div>
                <div class="stat-value" style="color: var(--success-color);"><?= $stats['total_employees'] ?? 0 ?></div>
                <div class="stat-label">Present Today</div>
                <div class="present-percentage"><?= $present_percentage ?>% Attendance Rate</div>
            </div>
            <div class="stat-card absent-stats">
                <div class="stat-icon"><i class="fas fa-user-times" style="color: var(--danger-color);"></i></div>
                <div class="stat-value" style="color: var(--danger-color);"><?= $stats['absent_employees'] ?? 0 ?></div>
                <div class="stat-label">Absent (Unexcused)</div>
            </div>
            <div class="stat-card leave-stats">
                <div class="stat-icon"><i class="fas fa-umbrella-beach" style="color: var(--warning-color);"></i></div>
                <div class="stat-value" style="color: var(--warning-color);"><?= $stats['on_leave'] ?? 0 ?></div>
                <div class="stat-label">On Leave</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-user-minus" style="color: var(--primary-color);"></i></div>
                <div class="stat-value" style="color: var(--primary-color);"><?= $stats['clocked_out'] ?? 0 ?></div>
                <div class="stat-label">Clocked Out</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                <div class="stat-value"><?= number_format($stats['avg_hours'] ?? 0, 1) ?>h</div>
                <div class="stat-label">Average Hours</div>
            </div>
            <?php if ($stats['low_accuracy_count'] > 0): ?>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-exclamation-triangle" style="color: var(--warning-color);"></i></div>
                <div class="stat-value" style="color: var(--warning-color);"><?= $stats['low_accuracy_count'] ?></div>
                <div class="stat-label">Low Accuracy Records</div>
            </div>
            <?php endif; ?>
        </div>

        <!-- Filters -->
        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-filter"></i> Attendance Records Filters</h3>
            </div>
            <div class="card-body">
                <form method="GET" action="" class="filter-row">
                    <div class="filter-group">
                        <label>Date</label>
                        <input type="date" name="date" value="<?= htmlspecialchars($filter_date) ?>" 
                               class="form-control" max="<?= date('Y-m-d') ?>">
                    </div>
                    <div class="filter-group">
                        <label>Office</label>
                        <select name="office" class="form-control">
                            <option value="all" <?= $filter_office === 'all' ? 'selected' : '' ?>>All Offices</option>
                            <?php 
                            $offices_result->data_seek(0);
                            while($office = $offices_result->fetch_assoc()): 
                            ?>
                                <option value="<?= $office['id'] ?>" <?= $filter_office == $office['id'] ? 'selected' : '' ?>>
                                    <?= htmlspecialchars($office['name']) ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Status</label>
                        <select name="status" class="form-control">
                            <option value="all" <?= $filter_status === 'all' ? 'selected' : '' ?>>All Status</option>
                            <option value="clocked_in" <?= $filter_status === 'clocked_in' ? 'selected' : '' ?>>Clocked In</option>
                            <option value="clocked_out" <?= $filter_status === 'clocked_out' ? 'selected' : '' ?>>Clocked Out</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Apply Filters
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Office Breakdown -->
        <?php if ($office_stats->num_rows > 0): ?>
        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-building"></i> Office-Wise Breakdown</h3>
            </div>
            <div class="card-body">
                <div class="office-breakdown">
                    <?php while($office_stat = $office_stats->fetch_assoc()): ?>
                    <div class="office-card">
                        <h4><?= htmlspecialchars($office_stat['office_name']) ?></h4>
                        <div class="office-metric">
                            <span>Total Attendance:</span>
                            <strong><?= $office_stat['total_employees'] ?></strong>
                        </div>
                        <div class="office-metric">
                            <span>Currently In:</span>
                            <strong style="color: var(--success-color);"><?= $office_stat['currently_in'] ?></strong>
                        </div>
                        <div class="office-metric">
                            <span>Avg Hours:</span>
                            <strong><?= number_format($office_stat['avg_hours'] ?? 0, 1) ?>h</strong>
                        </div>
                    </div>
                    <?php endwhile; ?>
                </div>
            </div>
        </div>
        <?php endif; ?>

        <!-- Attendance Records -->
        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-table"></i> Attendance Records</h3>
                <div class="export-buttons">
                    <button onclick="exportToCSV()" class="btn btn-sm btn-secondary">
                        <i class="fas fa-file-csv"></i> Export CSV
                    </button>
                    <button onclick="window.print()" class="btn btn-sm btn-secondary">
                        <i class="fas fa-print"></i> Print
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="attendance-table-wrapper">
                    <table class="table" id="attendance-table">
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Office</th>
                                <th>Clock In</th>
                                <th>Clock Out</th>
                                <th>Duration</th>
                                <th>Location</th>
                                <th>Distance</th>
                                <th>Accuracy</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php while($record = $attendance_records->fetch_assoc()): 
                            $distance = calculateDistance(
                                $record['lat'], $record['lng'],
                                $record['office_lat'], $record['office_lng']
                            );
                            $distance_meters = round($distance * 1000);
                            $is_suspicious = $distance_meters > 100;
                        ?>
                            <tr>
                                <td>
                                    <strong><?= htmlspecialchars($record['first_name'] . ' ' . $record['last_name']) ?></strong><br>
                                    <small class="text-muted"><?= htmlspecialchars($record['emp_number']) ?></small>
                                </td>
                                <td><?= htmlspecialchars($record['office_name']) ?></td>
                                <td><?= date('g:i A', strtotime($record['clock_in'])) ?></td>
                                <td>
                                    <?php if ($record['clock_out']): ?>
                                        <?= date('g:i A', strtotime($record['clock_out'])) ?>
                                    <?php else: ?>
                                        <span class="badge badge-success">Active</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php if ($record['status'] === 'clocked_in'): ?>
                                        <span class="live-duration" data-clock-in="<?= $record['clock_in'] ?>">
                                            --:--:--
                                        </span>
                                    <?php else: ?>
                                        <?php
                                        $hours = floor($record['duration_seconds'] / 3600);
                                        $minutes = floor(($record['duration_seconds'] % 3600) / 60);
                                        echo sprintf("%02d:%02d", $hours, $minutes);
                                        ?>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <small><?= round($record['lat'], 6) ?>, <?= round($record['lng'], 6) ?></small>
                                </td>
                                <td>
                                    <span class="location-badge <?= $is_suspicious ? 'location-suspicious' : 'location-verified' ?>">
                                        <?= $distance_meters ?>m
                                    </span>
                                </td>
                                <td>
                                    <?php if ($record['accuracy']): ?>
                                        <span class="accuracy-indicator accuracy-<?= 
                                            $record['accuracy'] < 20 ? 'high' : 
                                            ($record['accuracy'] < 50 ? 'medium' : 'low') 
                                        ?>">
                                            <?= round($record['accuracy']) ?>m
                                        </span>
                                    <?php else: ?>
                                        <small class="text-muted">N/A</small>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <span class="badge badge-<?= $record['status'] === 'clocked_in' ? 'success' : 'primary' ?>">
                                        <?= strtoupper(str_replace('_', ' ', $record['status'])) ?>
                                    </span>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                        <?php if ($attendance_records->num_rows === 0): ?>
                            <tr><td colspan="9" class="text-center text-muted">No attendance records found for the selected filters.</td></tr>
                        <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Absent Employees -->
        <div class="glass-card">
            <div class="card-header">
                <h3><i class="fas fa-user-times" style="color: var(--danger-color);"></i> Absent Employees - <?= date('F j, Y', strtotime($absent_date)) ?></h3>
                <div class="export-buttons">
                    <button onclick="exportAbsentToCSV()" class="btn btn-sm btn-secondary">
                        <i class="fas fa-file-csv"></i> Export CSV
                    </button>
                </div>
            </div>
            <div class="card-body">
                <!-- Absent Employees Filters -->
                <div class="absent-filters">
                    <form method="GET" action="" class="filter-row">
                        <input type="hidden" name="date" value="<?= htmlspecialchars($filter_date) ?>">
                        <input type="hidden" name="office" value="<?= htmlspecialchars($filter_office) ?>">
                        <input type="hidden" name="status" value="<?= htmlspecialchars($filter_status) ?>">
                        <div class="filter-group">
                            <label>Check Absence For Date</label>
                            <input type="date" name="absent_date" value="<?= htmlspecialchars($absent_date) ?>" 
                                   class="form-control" max="<?= date('Y-m-d') ?>">
                        </div>
                        <div class="filter-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Check Absence
                            </button>
                        </div>
                    </form>
                </div>

                <div class="attendance-table-wrapper">
                    <table class="table" id="absent-table">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Name</th>
                                <th>Office</th>
                                <th>Department</th>
                                <th>Contact</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php 
                        // Reset pointer for absent employees result
                        $absent_employees->data_seek(0);
                        while($employee = $absent_employees->fetch_assoc()): 
                        ?>
                            <tr>
                                <td>
                                    <strong><?= htmlspecialchars($employee['emp_number']) ?></strong>
                                </td>
                                <td>
                                    <strong><?= htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name']) ?></strong>
                                </td>
                                <td><?= htmlspecialchars($employee['office_name']) ?></td>
                                <td><?= htmlspecialchars($employee['department_name'] ?? 'N/A') ?></td>
                                <td>
                                    <small><?= htmlspecialchars($employee['email']) ?></small><br>
                                    <small class="text-muted"><?= htmlspecialchars($employee['phone']) ?></small>
                                </td>
                                <td>
                                    <span class="badge badge-danger">
                                        <i class="fas fa-user-times"></i> ABSENT
                                    </span>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                        <?php if ($absent_employees->num_rows === 0): ?>
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    <i class="fas fa-check-circle" style="color: var(--success-color);"></i>
                                    All active employees are accounted for on <?= date('F j, Y', strtotime($absent_date)) ?>!
                                    <br>
                                    <small>
                                        (Present: <?= $stats['total_employees'] ?? 0 ?>, 
                                        On Leave: <?= $stats['on_leave'] ?? 0 ?>)
                                    </small>
                                </td>
                            </tr>
                        <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Update live durations
function updateLiveDurations() {
    document.querySelectorAll('.live-duration').forEach(el => {
        const clockInTime = new Date(el.dataset.clockIn).getTime();
        const now = new Date().getTime();
        const diff = Math.floor((now - clockInTime) / 1000);
        const hours = Math.floor(diff / 3600);
        const minutes = Math.floor((diff % 3600) / 60);
        const seconds = diff % 60;
        el.textContent = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    });
}

// Update every second
setInterval(updateLiveDurations, 1000);
updateLiveDurations();

// Export to CSV function
function exportToCSV() {
    const table = document.getElementById('attendance-table');
    const rows = Array.from(table.querySelectorAll('tr'));
    const csv = rows.map(row => {
        const cells = Array.from(row.querySelectorAll('th, td'));
        return cells.map(cell => {
            const text = cell.innerText.replace(/\n/g, ' ').replace(/,/g, ';');
            return `"${text}"`;
        }).join(',');
    }).join('\n');
    
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `attendance_${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
}

// Export absent employees to CSV
function exportAbsentToCSV() {
    const table = document.getElementById('absent-table');
    const rows = Array.from(table.querySelectorAll('tr'));
    const csv = rows.map(row => {
        const cells = Array.from(row.querySelectorAll('th, td'));
        return cells.map(cell => {
            const text = cell.innerText.replace(/\n/g, ' ').replace(/,/g, ';');
            return `"${text}"`;
        }).join(',');
    }).join('\n');
    
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `absent_employees_${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
}

// Auto-refresh every 30 seconds
setTimeout(() => {
    location.reload();
}, 30000);
</script>
