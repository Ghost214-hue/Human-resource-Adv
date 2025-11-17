<?php
require_once 'config.php';
require_once 'auth.php'; // Your authentication system
require_once 'auth_check.php';

// Set current page for tabs
$current_page = 'audit';

// Check if user has permission to view audit logs
if (!hasPermission('view_audit_logs')) {
    die("Access denied");
}

// Handle filters
$where = [];
$params = [];

if (!empty($_GET['user_id'])) {
    $where[] = "user_id = ?";
    $params[] = (int)$_GET['user_id'];
}

if (!empty($_GET['action_type'])) {
    $where[] = "action_type = ?";
    $params[] = $_GET['action_type'];
}

if (!empty($_GET['table_name'])) {
    $where[] = "table_name = ?";
    $params[] = $_GET['table_name'];
}

if (!empty($_GET['start_date'])) {
    $where[] = "timestamp >= ?";
    $params[] = $_GET['start_date'];
}

if (!empty($_GET['end_date'])) {
    $where[] = "timestamp <= ?";
    $params[] = $_GET['end_date'];
}

$where_clause = $where ? "WHERE " . implode(" AND ", $where) : "";

// Build types for bind_param (user_id: i, others: s)
$types = '';
if (!empty($_GET['user_id'])) $types .= 'i';
if (!empty($_GET['action_type'])) $types .= 's';
if (!empty($_GET['table_name'])) $types .= 's';
if (!empty($_GET['start_date'])) $types .= 's';
if (!empty($_GET['end_date'])) $types .= 's';

// Pagination
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$limit = 50;
$offset = ($page - 1) * $limit;

// Get total count
if (empty($params)) {
    $count_result = $conn->query("SELECT COUNT(*) as total FROM audit_logs $where_clause");
    $total_logs = $count_result->fetch_assoc()['total'];
} else {
    $count_stmt = $conn->prepare("SELECT COUNT(*) as total FROM audit_logs $where_clause");
    if ($count_stmt) {
        $count_stmt->bind_param($types, ...$params);
        $count_stmt->execute();
        $count_result = $count_stmt->get_result();
        $total_logs = $count_result->fetch_assoc()['total'];
        $count_stmt->close();
    } else {
        $total_logs = 0; // Fallback on prepare error
    }
}
$total_pages = ceil($total_logs / $limit);

// Get logs
if (empty($params)) {
    $query_result = $conn->query("SELECT * FROM audit_logs $where_clause ORDER BY timestamp DESC LIMIT $limit OFFSET $offset");
    $logs = $query_result ? $query_result->fetch_all(MYSQLI_ASSOC) : [];
} else {
    $query = "SELECT * FROM audit_logs $where_clause ORDER BY timestamp DESC LIMIT $limit OFFSET $offset";
    $stmt = $conn->prepare($query);
    if ($stmt) {
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $result = $stmt->get_result();
        $logs = $result->fetch_all(MYSQLI_ASSOC);
        $stmt->close();
    } else {
        $logs = [];
    }
}

// Get unique values for filters
$users_result = $conn->query("SELECT DISTINCT user_id, username FROM audit_logs ORDER BY username");
$users = $users_result ? $users_result->fetch_all(MYSQLI_ASSOC) : [];

$actions_result = $conn->query("SELECT DISTINCT action_type FROM audit_logs ORDER BY action_type");
$actions = $actions_result ? $actions_result->fetch_all(MYSQLI_ASSOC) : [];

$tables_result = $conn->query("SELECT DISTINCT table_name FROM audit_logs WHERE table_name IS NOT NULL ORDER BY table_name");
$tables = $tables_result ? $tables_result->fetch_all(MYSQLI_ASSOC) : [];
require_once 'header.php';
require_once 'nav_bar.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Trail Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css"> <!-- Assuming global.css contains the provided CSS -->
    
</head>
<body>
    <div class="container">
        <div class="main-content">
            <!-- Assuming header is included elsewhere; tabs here -->
            <div class="leave-tabs">
                <?php if (hasPermission('super_admin')): ?>
                    <a href="admin.php?tab=users" class="leave-tab <?= ($current_page === 'admin' && isset($tab) && $tab === 'users') ? 'active' : '' ?>">
                        <i class="fas fa-users"></i> Users
                    </a>
                <?php endif; ?>

                <a href="admin.php?tab=financial" class="leave-tab <?= ($current_page === 'admin' && isset($tab) && $tab === 'financial') ? 'active' : '' ?>">
                    <i class="fas fa-calendar-alt"></i> Financial Year
                </a>

                <a href="audit_dashboard.php" class="leave-tab <?= ($current_page === 'audit') ? 'active' : '' ?>">
                    <i class="fas fa-shield-alt"></i> Audit
                </a>
            </div>

            <div class="content">
                <h1 class="page-title mb-4"><i class="fas fa-shield-alt"></i> Audit Trail Dashboard</h1>
                
                <!-- Filters -->
                <div class="search-filters glass-card mb-4">
                    <h5 class="mb-3"><i class="fas fa-filter"></i> Filters</h5>
                    <form method="GET" class="filter-row">
                        <div class="form-group">
                            <label>User</label>
                            <select name="user_id" class="form-control">
                                <option value="">All Users</option>
                                <?php foreach ($users as $user): ?>
                                    <option value="<?= $user['user_id'] ?>" <?= ($_GET['user_id'] ?? '') == $user['user_id'] ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($user['username']) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Action Type</label>
                            <select name="action_type" class="form-control">
                                <option value="">All Actions</option>
                                <?php foreach ($actions as $action): ?>
                                    <option value="<?= $action['action_type'] ?>" <?= ($_GET['action_type'] ?? '') == $action['action_type'] ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($action['action_type']) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Table</label>
                            <select name="table_name" class="form-control">
                                <option value="">All Tables</option>
                                <?php foreach ($tables as $table): ?>
                                    <option value="<?= $table['table_name'] ?>" <?= ($_GET['table_name'] ?? '') == $table['table_name'] ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($table['table_name']) ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Start Date</label>
                            <input type="date" name="start_date" class="form-control" value="<?= $_GET['start_date'] ?? '' ?>">
                        </div>
                        <div class="form-group">
                            <label>End Date</label>
                            <input type="date" name="end_date" class="form-control" value="<?= $_GET['end_date'] ?? '' ?>">
                        </div>
                        <div class="form-group d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search"></i> Filter</button>
                        </div>
                    </form>
                </div>

                <!-- Statistics -->
                <div class="stats-grid mb-4">
                    <div class="stat-card">
                        <h3><?= number_format($total_logs) ?></h3>
                        <p>Total Log Entries</p>
                    </div>
                    <div class="stat-card">
                        <h3><?= count(array_filter($logs, fn($log) => $log['action_type'] === 'CREATE')) ?></h3>
                        <p>Create Actions</p>
                    </div>
                    <div class="stat-card">
                        <h3><?= count(array_filter($logs, fn($log) => $log['action_type'] === 'UPDATE')) ?></h3>
                        <p>Update Actions</p>
                    </div>
                    <div class="stat-card">
                        <h3><?= count(array_filter($logs, fn($log) => $log['action_type'] === 'DELETE')) ?></h3>
                        <p>Delete Actions</p>
                    </div>
                </div>

                <!-- Logs Table -->
                <div class="table-container glass-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0"><i class="fas fa-list"></i> Audit Logs</h5>
                        <a href="export_audit_logs.php" class="btn btn-success">
                            <i class="fas fa-download"></i> Export
                        </a>
                    </div>
                    <?php if ($logs): ?>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Timestamp</th>
                                        <th>User</th>
                                        <th>Action</th>
                                        <th>Description</th>
                                        <th>Table/Record</th>
                                        <th>IP Address</th>
                                        <th>Details</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($logs as $log): ?>
                                        <tr class="log-entry log-<?= strtolower(explode('_', $log['action_type'])[0]) ?>">
                                            <td><?= date('Y-m-d H:i:s', strtotime($log['timestamp'])) ?></td>
                                            <td>
                                                <strong><?= htmlspecialchars($log['username']) ?></strong>
                                                <br><small class="text-muted"><?= htmlspecialchars($log['user_role']) ?></small>
                                            </td>
                                            <td>
                                                <span class="badge badge-action 
                                                    <?= $log['action_type'] === 'CREATE' ? 'badge-success' : '' ?>
                                                    <?= $log['action_type'] === 'UPDATE' ? 'badge-warning' : '' ?>
                                                    <?= $log['action_type'] === 'DELETE' ? 'badge-danger' : '' ?>
                                                    <?= $log['action_type'] === 'LOGIN' ? 'badge-info' : '' ?>
                                                    <?= in_array($log['action_type'], ['VIEW', 'EXPORT']) ? 'badge-secondary' : '' ?>">
                                                    <?= htmlspecialchars($log['action_type']) ?>
                                                </span>
                                            </td>
                                            <td><?= htmlspecialchars($log['description']) ?></td>
                                            <td>
                                                <?php if ($log['table_name']): ?>
                                                    <?= htmlspecialchars($log['table_name']) ?>
                                                    <?php if ($log['record_id']): ?>
                                                        <br><small class="text-muted">ID: <?= $log['record_id'] ?></small>
                                                    <?php endif; ?>
                                                <?php endif; ?>
                                            </td>
                                            <td><small><?= htmlspecialchars($log['ip_address']) ?></small></td>
                                            <td>
                                                <?php if ($log['old_values'] || $log['new_values']): ?>
                                                    <button class="btn btn-secondary btn-sm" 
                                                            onclick="showDetails(<?= htmlspecialchars(json_encode([
                                                                'old' => $log['old_values'] ? json_decode($log['old_values'], true) : null,
                                                                'new' => $log['new_values'] ? json_decode($log['new_values'], true) : null
                                                            ])) ?>)">
                                                        <i class="fas fa-eye"></i> View Details
                                                    </button>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <?php if ($total_pages > 1): ?>
                            <nav class="pagination">
                                <ul class="d-flex gap-2 justify-content-center">
                                    <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                                        <li class="<?= $i == $page ? 'active' : '' ?>">
                                            <a class="page-link" href="?<?= http_build_query(array_merge($_GET, ['page' => $i])) ?>"><?= $i ?></a>
                                        </li>
                                    <?php endfor; ?>
                                </ul>
                            </nav>
                        <?php endif; ?>
                    <?php else: ?>
                        <div class="alert alert-info">No audit logs found.</div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

    <!-- Details Modal -->
    <div class="modal" id="detailsModal" tabindex="-1">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Audit Log Details</h5>
                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>Old Values</h6>
                        <pre id="oldValues" class="pre-details">No old values</pre>
                    </div>
                    <div class="col-md-6">
                        <h6>New Values</h6>
                        <pre id="newValues" class="pre-details">No new values</pre>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showDetails(data) {
            document.getElementById('oldValues').textContent = data.old ? JSON.stringify(data.old, null, 2) : 'No old values';
            document.getElementById('newValues').textContent = data.new ? JSON.stringify(data.new, null, 2) : 'No new values';
            new bootstrap.Modal(document.getElementById('detailsModal')).show();
        }
    </script>
</body>
</html>