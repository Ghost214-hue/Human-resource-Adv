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
// Include Composer autoloader for PDF and Excel libraries
require_once 'vendor/autoload.php';

require_once 'auth_check.php';
require_once 'auth.php';
require_once 'config.php';


// Restrict access to HR Manager and Super Admin only
if (!(hasPermission('super_admin') || hasPermission('hr_manager'))) {
    header('Location: dashboard.php');
    exit();
}

$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// CSRF Token Generation
function generateCsrfToken(): string {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function sanitizeInput(string $input): string {
    return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
}

function formatDate(?string $date): string {
    if (!$date) return 'N/A';
    return (new DateTime($date))->format('M d, Y');
}

function maskNationalId(string $national_id): string {
    if (strlen($national_id) <= 4) {
        return str_repeat('*', strlen($national_id));
    }
    $visible = substr($national_id, -4);
    $masked = str_repeat('*', strlen($national_id) - 4);
    return $masked . $visible;
}

// Helper functions for consent management
function getConsentStats($mysqli, $filters = []) {
    $whereConditions = ["e.employee_status = 'active'"];
    $params = [];
    $types = "";
    
    if (!empty($filters['search'])) {
        $whereConditions[] = "(e.first_name LIKE ? OR e.last_name LIKE ? OR e.email LIKE ? OR e.national_id LIKE ? OR uc.full_name LIKE ? OR e.employee_id LIKE ?)";
        $searchTerm = "%" . $filters['search'] . "%";
        $params = array_merge($params, [$searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm]);
        $types .= "ssssss";
    }
    
    if (!empty($filters['department'])) {
        $whereConditions[] = "e.department_id = ?";
        $params[] = $filters['department'];
        $types .= "i";
    }
    
    if (!empty($filters['consent_status'])) {
        if ($filters['consent_status'] === 'consented') {
            $whereConditions[] = "uc.consent_given = 1";
        } elseif ($filters['consent_status'] === 'not_consented') {
            $whereConditions[] = "uc.consent_given IS NULL OR uc.consent_given = 0";
        }
    }
    
    if (!empty($filters['date_from'])) {
        $whereConditions[] = "uc.consent_date >= ?";
        $params[] = $filters['date_from'];
        $types .= "s";
    }
    
    if (!empty($filters['date_to'])) {
        $whereConditions[] = "uc.consent_date <= ?";
        $params[] = $filters['date_to'];
        $types .= "s";
    }
    
    $whereClause = implode(" AND ", $whereConditions);
    
    // Join using user_id instead of verified_employee_id
    $totalQuery = "SELECT COUNT(DISTINCT e.id) as total 
                   FROM employees e 
                   LEFT JOIN users u ON u.employee_id = e.employee_id
                   LEFT JOIN user_consents uc ON uc.user_id = u.id 
                   WHERE {$whereClause}";
    
    $stmt = $mysqli->prepare($totalQuery);
    if ($stmt && !empty($params)) {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    $totalResult = $stmt->get_result();
    $totalEmployees = $totalResult->fetch_assoc()['total'] ?? 0;
    
    // Join using user_id instead of verified_employee_id
    $consentedQuery = "SELECT COUNT(DISTINCT e.id) as consented 
                       FROM employees e 
                       INNER JOIN users u ON u.employee_id = e.employee_id
                       INNER JOIN user_consents uc ON uc.user_id = u.id 
                       WHERE uc.consent_given = 1 AND {$whereClause}";
    
    $stmt = $mysqli->prepare($consentedQuery);
    if ($stmt && !empty($params)) {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    $consentedResult = $stmt->get_result();
    $consentedEmployees = $consentedResult->fetch_assoc()['consented'] ?? 0;
    
    $completionRate = $totalEmployees > 0 ? round(($consentedEmployees / $totalEmployees) * 100, 1) : 0;
    
    return [
        'total_employees' => $totalEmployees,
        'consented_employees' => $consentedEmployees,
        'pending_consents' => $totalEmployees - $consentedEmployees,
        'completion_rate' => $completionRate
    ];
}

function getEmployeeConsents($mysqli, $filters = [], $page = 1, $per_page = 20) {
    $offset = ($page - 1) * $per_page;
    
    $whereConditions = ["e.employee_status = 'active'"];
    $params = [];
    $types = "";
    
    if (!empty($filters['search'])) {
        $whereConditions[] = "(e.first_name LIKE ? OR e.last_name LIKE ? OR e.email LIKE ? OR e.national_id LIKE ? OR uc.full_name LIKE ? OR e.employee_id LIKE ?)";
        $searchTerm = "%" . $filters['search'] . "%";
        $params = array_merge($params, [$searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm]);
        $types .= "ssssss";
    }
    
    if (!empty($filters['department'])) {
        $whereConditions[] = "e.department_id = ?";
        $params[] = $filters['department'];
        $types .= "i";
    }
    
    if (!empty($filters['consent_status'])) {
        if ($filters['consent_status'] === 'consented') {
            $whereConditions[] = "uc.consent_given = 1";
        } elseif ($filters['consent_status'] === 'not_consented') {
            $whereConditions[] = "uc.consent_given IS NULL OR uc.consent_given = 0";
        }
    }
    
    if (!empty($filters['date_from'])) {
        $whereConditions[] = "uc.consent_date >= ?";
        $params[] = $filters['date_from'];
        $types .= "s";
    }
    
    if (!empty($filters['date_to'])) {
        $whereConditions[] = "uc.consent_date <= ?";
        $params[] = $filters['date_to'];
        $types .= "s";
    }
    
    $whereClause = implode(" AND ", $whereConditions);
    
    // Join through users table to link employees with user_consents
    $query = "SELECT 
                e.id as employee_db_id,
                e.employee_id,
                e.first_name,
                e.last_name,
                e.surname,
                e.email,
                e.national_id as employee_national_id,
                e.designation,
                d.name as department_name,
                uc.id as consent_id,
                uc.full_name as consent_full_name,
                uc.national_id as consent_national_id,
                uc.consent_given,
                uc.consent_date,
                uc.ip_address,
                uc.user_agent,
                uc.created_at as consent_created
              FROM employees e
              LEFT JOIN departments d ON e.department_id = d.id
              LEFT JOIN users u ON u.employee_id = e.employee_id
              LEFT JOIN user_consents uc ON uc.user_id = u.id
              WHERE {$whereClause}
              ORDER BY uc.consent_date DESC, e.first_name, e.last_name
              LIMIT ? OFFSET ?";
    
    $params[] = $per_page;
    $params[] = $offset;
    $types .= "ii";
    
    $stmt = $mysqli->prepare($query);
    if ($stmt) {
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
    return [];
}

function getAllEmployeeConsents($mysqli, $filters) {
    $whereConditions = ["e.employee_status = 'active'"];
    $params = [];
    $types = "";
    
    if (!empty($filters['search'])) {
        $whereConditions[] = "(e.first_name LIKE ? OR e.last_name LIKE ? OR e.email LIKE ? OR e.national_id LIKE ? OR uc.full_name LIKE ? OR e.employee_id LIKE ?)";
        $searchTerm = "%" . $filters['search'] . "%";
        $params = array_merge($params, [$searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm]);
        $types .= "ssssss";
    }
    
    if (!empty($filters['department'])) {
        $whereConditions[] = "e.department_id = ?";
        $params[] = $filters['department'];
        $types .= "i";
    }
    
    if (!empty($filters['consent_status'])) {
        if ($filters['consent_status'] === 'consented') {
            $whereConditions[] = "uc.consent_given = 1";
        } elseif ($filters['consent_status'] === 'not_consented') {
            $whereConditions[] = "uc.consent_given IS NULL OR uc.consent_given = 0";
        }
    }
    
    if (!empty($filters['date_from'])) {
        $whereConditions[] = "uc.consent_date >= ?";
        $params[] = $filters['date_from'];
        $types .= "s";
    }
    
    if (!empty($filters['date_to'])) {
        $whereConditions[] = "uc.consent_date <= ?";
        $params[] = $filters['date_to'];
        $types .= "s";
    }
    
    $whereClause = implode(" AND ", $whereConditions);
    
    // Join through users table to link employees with user_consents
    $query = "SELECT 
                e.employee_id,
                CONCAT(e.first_name, ' ', e.last_name, ' ', COALESCE(e.surname, '')) as employee_name,
                e.email,
                e.designation,
                d.name as department_name,
                uc.full_name as consent_full_name,
                uc.national_id as consent_national_id,
                CASE WHEN uc.consent_given = 1 THEN 'Yes' ELSE 'No' END as consent_status,
                uc.consent_date,
                uc.ip_address,
                uc.user_agent,
                uc.created_at as consent_recorded
              FROM employees e
              LEFT JOIN departments d ON e.department_id = d.id
              LEFT JOIN users u ON u.employee_id = e.employee_id
              LEFT JOIN user_consents uc ON uc.user_id = u.id
              WHERE {$whereClause}
              ORDER BY uc.consent_date DESC, e.first_name, e.last_name";
    
    $stmt = $mysqli->prepare($query);
    if ($stmt && !empty($params)) {
        $stmt->bind_param($types, ...$params);
    }
    if ($stmt) {
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    return [];
}

// === EXPORT HANDLER (PDF & Excel) ===
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['export_type'])) {
    if (!isset($_POST['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $_POST['csrf_token'])) {
        die('Security token invalid.');
    }

    $filters = isset($_POST['filters']) ? json_decode($_POST['filters'], true) : [];
    $export_type = $_POST['export_type'] ?? 'excel';
    $consents = getAllEmployeeConsents($mysqli, $filters);

    // Check if required libraries are available
    if ($export_type === 'pdf') {
        if (class_exists('TCPDF')) {
            exportAsPDF($consents);
        } else {
            die('PDF export requires TCPDF library. Please install via composer: composer require tecnickcom/tcpdf');
        }
    } else {
        if (class_exists('PhpOffice\PhpSpreadsheet\Spreadsheet')) {
            exportAsExcel($consents);
        } else {
            die('Excel export requires PhpSpreadsheet library. Please install via composer: composer require phpoffice/phpspreadsheet');
        }
    }
    exit();
}

function exportAsPDF($consents) {
    try {
        $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        $pdf->SetCreator('HR Management System');
        $pdf->SetAuthor('HR Department');
        $pdf->SetTitle('Employee Consents Report');
        $pdf->SetSubject('Data Protection Consent Records');

        $pdf->AddPage();
        $pdf->SetFont('helvetica', 'B', 16);
        $pdf->Cell(0, 10, 'Employee Consent Report', 0, 1, 'C');
        $pdf->SetFont('helvetica', '', 10);
        $pdf->Cell(0, 10, 'Generated on: ' . date('Y-m-d H:i:s'), 0, 1, 'C');
        $pdf->Ln(10);

        $pdf->SetFont('helvetica', 'B', 10);
        $headers = ['Emp ID', 'Name', 'Department', 'Position', 'Consent', 'Date', 'IP'];
        $widths = [25, 45, 30, 30, 20, 30, 30];

        for ($i = 0; $i < count($headers); $i++) {
            $pdf->Cell($widths[$i], 7, $headers[$i], 1, 0, 'C');
        }
        $pdf->Ln();

        $pdf->SetFont('helvetica', '', 9);
        foreach ($consents as $row) {
            $pdf->Cell($widths[0], 6, $row['employee_id'] ?? 'N/A', 'LR', 0, 'L');
            $pdf->Cell($widths[1], 6, $row['employee_name'] ?? 'N/A', 'LR', 0, 'L');
            $pdf->Cell($widths[2], 6, $row['department_name'] ?? 'N/A', 'LR', 0, 'L');
            $pdf->Cell($widths[3], 6, $row['designation'] ?? 'N/A', 'LR', 0, 'L');
            $pdf->Cell($widths[4], 6, $row['consent_status'] ?? 'No', 'LR', 0, 'C');
            $pdf->Cell($widths[5], 6, $row['consent_date'] ? date('M d, Y', strtotime($row['consent_date'])) : 'N/A', 'LR', 0, 'C');
            $pdf->Cell($widths[6], 6, $row['ip_address'] ?? 'N/A', 'LR', 0, 'C');
            $pdf->Ln();
        }
        $pdf->Cell(array_sum($widths), 0, '', 'T');

        $pdf->Output('employee_consents_' . date('Y-m-d') . '.pdf', 'D');
    } catch (Exception $e) {
        die('PDF generation error: ' . $e->getMessage());
    }
}

function exportAsExcel($consents) {
    try {
        $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        $headers = [
            'Employee ID', 'Full Name', 'Email', 'Department', 'Position',
            'Consent Name', 'Consent National ID', 'Consent Status', 'Consent Date',
            'IP Address', 'User Agent', 'Recorded At'
        ];

        $col = 'A';
        foreach ($headers as $header) {
            $sheet->setCellValue($col . '1', $header);
            $sheet->getStyle($col . '1')->getFont()->setBold(true);
            $col++;
        }

        $row = 2;
        foreach ($consents as $data) {
            $sheet->setCellValue('A' . $row, $data['employee_id'] ?? '');
            $sheet->setCellValue('B' . $row, $data['employee_name'] ?? '');
            $sheet->setCellValue('C' . $row, $data['email'] ?? '');
            $sheet->setCellValue('D' . $row, $data['department_name'] ?? 'N/A');
            $sheet->setCellValue('E' . $row, $data['designation'] ?? 'N/A');
            $sheet->setCellValue('F' . $row, $data['consent_full_name'] ?? '');
            $sheet->setCellValue('G' . $row, $data['consent_national_id'] ?? '');
            $sheet->setCellValue('H' . $row, $data['consent_status'] ?? 'No');
            $sheet->setCellValue('I' . $row, $data['consent_date'] ? date('Y-m-d H:i', strtotime($data['consent_date'])) : '');
            $sheet->setCellValue('J' . $row, $data['ip_address'] ?? '');
            $sheet->setCellValue('K' . $row, $data['user_agent'] ?? '');
            $sheet->setCellValue('L' . $row, $data['consent_recorded'] ? date('Y-m-d H:i', strtotime($data['consent_recorded'])) : '');
            $row++;
        }

        foreach (range('A', 'L') as $columnID) {
            $sheet->getColumnDimension($columnID)->setAutoSize(true);
        }

        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="employee_consents_' . date('Y-m-d') . '.xlsx"');
        header('Cache-Control: max-age=0');

        $writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter($spreadsheet, 'Xlsx');
        $writer->save('php://output');
    } catch (Exception $e) {
        die('Excel generation error: ' . $e->getMessage());
    }
}

// === END EXPORT HANDLER ===

$mysqli = getConnection();

// Get departments for filter
$departments = [];
$deptResult = $mysqli->query("SELECT id, name FROM departments ORDER BY name");
if ($deptResult) {
    $departments = $deptResult->fetch_all(MYSQLI_ASSOC);
}

// Get current page
$current_page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;

// Get consents data
$consents = getEmployeeConsents($mysqli, $_GET, $current_page, 20);
$stats = getConsentStats($mysqli, $_GET);
require_once 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Consent Management - HR Management System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: var(--bg-glass); backdrop-filter: blur(20px); border: 1px solid var(--border-color); border-radius: 12px; padding: 1.5rem; display: flex; align-items: center; gap: 1rem; box-shadow: var(--shadow-md); }
        .stat-icon { width: 60px; height: 60px; border-radius: 12px; background: var(--primary-color); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; }
        .stat-info h3 { margin: 0; font-size: 2rem; font-weight: bold; color: var(--text-primary); }
        .stat-info p { margin: 0.25rem 0 0 0; color: var(--text-secondary); font-size: 0.9rem; }
        .filter-export-bar { display: grid; grid-template-columns: 1fr auto; gap: 2rem; align-items: start; }
        .filter-form { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }
        .export-actions { display: flex; gap: 1rem; flex-wrap: wrap; }
        .action-buttons { display: flex; gap: 0.5rem; }
        .pagination { display: flex; justify-content: center; align-items: center; gap: 0.5rem; margin-top: 2rem; flex-wrap: wrap; }
        .page-link { padding: 0.5rem 1rem; border: 1px solid var(--border-color); border-radius: 6px; text-decoration: none; color: var(--text-primary); background: var(--bg-glass); transition: all 0.3s ease; }
        .page-link:hover, .page-link.active { background: var(--primary-color); color: white; border-color: var(--primary-color); }
        @media (max-width: 768px) { .filter-export-bar { grid-template-columns: 1fr; } .filter-form { grid-template-columns: 1fr; } .export-actions { justify-content: center; } }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <div class="content">
                <div class="leave-tabs">
                    <?php if (hasPermission('super_admin')): ?>
                        <a href="admin.php?tab=users" class="leave-tab">
                            <i class="fas fa-users"></i> Users
                        </a>
                    <?php endif; ?>
                    <a href="admin.php?tab=financial" class="leave-tab">
                        <i class="fas fa-calendar-alt"></i> Financial Year
                    </a>
                    <a href="consent_management.php" class="leave-tab active">
                        <i class="fas fa-file-signature"></i> Employee Consents
                    </a>
                    <a href="audit_dashboard.php" class="leave-tab">
                        <i class="fas fa-shield-alt"></i> Audit
                    </a>
                </div>

                <h2>Employee Consent Management</h2>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card"><div class="stat-icon"><i class="fas fa-users"></i></div><div class="stat-info"><h3><?php echo $stats['total_employees']; ?></h3><p>Total Employees</p></div></div>
                    <div class="stat-card"><div class="stat-icon" style="background: var(--success-color);"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h3><?php echo $stats['consented_employees']; ?></h3><p>Consented</p></div></div>
                    <div class="stat-card"><div class="stat-icon" style="background: var(--warning-color);"><i class="fas fa-exclamation-circle"></i></div><div class="stat-info"><h3><?php echo $stats['pending_consents']; ?></h3><p>Pending</p></div></div>
                    <div class="stat-card"><div class="stat-icon" style="background: var(--info-color);"><i class="fas fa-chart-line"></i></div><div class="stat-info"><h3><?php echo $stats['completion_rate']; ?>%</h3><p>Completion Rate</p></div></div>
                </div>

                <!-- Filters and Export -->
                <div class="glass-card">
                    <div class="filter-export-bar">
                        <div class="filters">
                            <form method="GET" action="" class="filter-form">
                                <div class="form-group">
                                    <label for="search">Search</label>
                                    <input type="text" name="search" id="search" class="form-control" placeholder="Name, email, ID" value="<?php echo $_GET['search'] ?? ''; ?>">
                                </div>
                                <div class="form-group">
                                    <label for="department">Department</label>
                                    <select name="department" id="department" class="form-control">
                                        <option value="">All</option>
                                        <?php foreach ($departments as $dept): ?>
                                            <option value="<?php echo $dept['id']; ?>" <?php echo ($_GET['department'] ?? '') == $dept['id'] ? 'selected' : ''; ?>>
                                                <?php echo htmlspecialchars($dept['name']); ?>
                                            </option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="consent_status">Status</label>
                                    <select name="consent_status" id="consent_status" class="form-control">
                                        <option value="">All</option>
                                        <option value="consented" <?php echo ($_GET['consent_status'] ?? '') == 'consented' ? 'selected' : ''; ?>>Consented</option>
                                        <option value="not_consented" <?php echo ($_GET['consent_status'] ?? '') == 'not_consented' ? 'selected' : ''; ?>>Pending</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="date_from">From</label>
                                    <input type="date" name="date_from" id="date_from" class="form-control" value="<?php echo $_GET['date_from'] ?? ''; ?>">
                                </div>
                                <div class="form-group">
                                    <label for="date_to">To</label>
                                    <input type="date" name="date_to" id="date_to" class="form-control" value="<?php echo $_GET['date_to'] ?? ''; ?>">
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Apply</button>
                                    <a href="consent_management.php" class="btn btn-secondary">Clear</a>
                                </div>
                            </form>
                        </div>

                        <div class="export-actions">
                            <form method="POST" action="" id="exportForm">
                                <input type="hidden" name="csrf_token" value="<?php echo generateCsrfToken(); ?>">
                                <input type="hidden" name="export_type" id="export_type">
                                <input type="hidden" name="filters" value="<?php echo htmlspecialchars(json_encode($_GET)); ?>">
                                <button type="button" onclick="exportData('pdf')" class="btn btn-danger"><i class="fas fa-file-pdf"></i> PDF</button>
                                <button type="button" onclick="exportData('excel')" class="btn btn-success"><i class="fas fa-file-excel"></i> Excel</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Table -->
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Full Name</th>
                                <th>National ID</th>
                                <th>Department</th>
                                <th>Position</th>
                                <th>Consent Status</th>
                                <th>Consent Date</th>
                                <th>IP Address</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (empty($consents)): ?>
                                <tr><td colspan="9" class="text-center">No records found</td></tr>
                            <?php else: ?>
                                <?php foreach ($consents as $c): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($c['employee_id']); ?></td>
                                    <td><strong><?php echo htmlspecialchars($c['first_name'] . ' ' . $c['last_name']); ?></strong><br><small class="text-muted"><?php echo htmlspecialchars($c['email']); ?></small></td>
                                    <td>
                                        <?php if ($c['consent_national_id']): ?>
                                            <?php echo htmlspecialchars(maskNationalId($c['consent_national_id'])); ?>
                                            <br><small class="text-muted">(Partially masked for security)</small>
                                        <?php else: ?>
                                            <span class="text-muted">Not provided</span>
                                        <?php endif; ?>
                                    </td>
                                    <td><?php echo htmlspecialchars($c['department_name'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($c['designation'] ?? 'N/A'); ?></td>
                                    <td>
                                        <?php if ($c['consent_given']): ?>
                                            <span class="badge badge-success"><i class="fas fa-check"></i> Consented</span><br>
                                            <small class="text-muted"><?php echo formatDate($c['consent_date']); ?></small>
                                        <?php else: ?>
                                            <span class="badge badge-warning"><i class="fas fa-clock"></i> Pending</span>
                                        <?php endif; ?>
                                    </td>
                                    <td><?php echo $c['consent_date'] ? formatDate($c['consent_date']) : 'N/A'; ?></td>
                                    <td><?php echo $c['ip_address'] ? '<code>' . htmlspecialchars($c['ip_address']) . '</code>' : '<span class="text-muted">N/A</span>'; ?></td>
                                    <td>
                                        <div class="action-buttons">
                                            <?php if ($c['consent_given']): ?>
                                                <button onclick="viewConsentDetails(<?php echo $c['consent_id']; ?>)" class="btn btn-sm btn-info" title="View"><i class="fas fa-eye"></i></button>
                                                <button onclick="downloadConsentPDF(<?php echo $c['consent_id']; ?>)" class="btn btn-sm btn-primary" title="PDF"><i class="fas fa-download"></i></button>
                                            <?php else: ?>
                                                <span class="text-muted">—</span>
                                            <?php endif; ?>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <?php
                $total_pages = ceil($stats['total_employees'] / 20);
                if ($total_pages > 1): ?>
                <div class="pagination">
                    <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                        <a href="?<?php echo http_build_query(array_merge($_GET, ['page' => $i])); ?>" class="page-link <?php echo $i == $current_page ? 'active' : ''; ?>">
                            <?php echo $i; ?>
                        </a>
                    <?php endfor; ?>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        function exportData(type) {
            document.getElementById('export_type').value = type;
            document.getElementById('exportForm').submit();
        }
        function viewConsentDetails(id) { 
            alert('View details for consent ID: ' + id); 
            // You can implement a modal here to show detailed consent information
        }
        function downloadConsentPDF(id) { 
            window.open('download_consent.php?id=' + id, '_blank'); 
        }

        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('#search, #department, #consent_status, #date_from, #date_to').forEach(el => {
                el.addEventListener('change', () => el.closest('form').submit());
            });
        });
    </script>
</body>
</html>