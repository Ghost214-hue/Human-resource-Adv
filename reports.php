<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

require_once 'config.php';
require_once 'auth.php';

// Get database connection
$conn = getConnection();

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];

// Check permission
if (!hasPermission('hr_manager')) {
    header('Location: dashboard.php');
    exit();
}

// Get departments, sections and subsections for filters
$departments = $conn->query("SELECT * FROM departments ORDER BY name")->fetch_all(MYSQLI_ASSOC);
$sections = $conn->query("SELECT s.*, d.name as department_name FROM sections s LEFT JOIN departments d ON s.department_id = d.id ORDER BY d.name, s.name")->fetch_all(MYSQLI_ASSOC);
$subsections = $conn->query("SELECT ss.*, s.name as section_name, d.name as department_name FROM subsections ss LEFT JOIN sections s ON ss.section_id = s.id LEFT JOIN departments d ON ss.department_id = d.id ORDER BY d.name, s.name, ss.name")->fetch_all(MYSQLI_ASSOC);

// Handle filters
$department_filter = $_GET['department'] ?? '';
$section_filter = $_GET['section'] ?? '';
$subsection_filter = $_GET['subsection'] ?? '';
$type_filter = $_GET['type'] ?? '';
$status_filter = $_GET['status'] ?? '';
$employment_type_filter = $_GET['employment_type'] ?? '';
$job_group_filter = $_GET['job_group'] ?? '';
$date_from = $_GET['date_from'] ?? '';
$date_to = $_GET['date_to'] ?? '';

// Build query
$where_conditions = [];
$params = [];
$types = '';

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

if (!empty($subsection_filter)) {
    $where_conditions[] = "e.subsection_id = ?";
    $params[] = $subsection_filter;
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

if (!empty($employment_type_filter)) {
    $where_conditions[] = "e.employment_type = ?";
    $params[] = $employment_type_filter;
    $types .= 's';
}

if (!empty($job_group_filter)) {
    $where_conditions[] = "e.scale_id = ?";
    $params[] = $job_group_filter;
    $types .= 's';
}

if (!empty($date_from)) {
    $where_conditions[] = "e.hire_date >= ?";
    $params[] = $date_from;
    $types .= 's';
}

if (!empty($date_to)) {
    $where_conditions[] = "e.hire_date <= ?";
    $params[] = $date_to;
    $types .= 's';
}

$where_clause = !empty($where_conditions) ? "WHERE " . implode(" AND ", $where_conditions) : "";

$query = "
    SELECT e.*,
           COALESCE(e.first_name, '') as first_name,
           COALESCE(e.last_name, '') as last_name,
           COALESCE(e.surname, '') as surname,
           d.name as department_name,
           s.name as section_name,
           ss.name as subsection_name
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN sections s ON e.section_id = s.id
    LEFT JOIN subsections ss ON e.subsection_id = ss.id
    $where_clause
    ORDER BY e.employee_id ASC
";

$stmt = $conn->prepare($query);
if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();
$employees = $result->fetch_all(MYSQLI_ASSOC);

// Calculate statistics
$total_employees = count($employees);
$active_employees = count(array_filter($employees, fn($e) => $e['employee_status'] === 'active'));
$inactive_employees = $total_employees - $active_employees;

// Count by employment type
$permanent = count(array_filter($employees, fn($e) => $e['employment_type'] === 'permanent'));
$contract = count(array_filter($employees, fn($e) => $e['employment_type'] === 'contract'));
$temporary = count(array_filter($employees, fn($e) => $e['employment_type'] === 'temporary'));

// Handle export requests
if (isset($_GET['export'])) {
    $export_type = $_GET['export'];
    
    if ($export_type === 'excel') {
        // Excel export
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="employee_report_' . date('Y-m-d') . '.xls"');
        header('Cache-Control: max-age=0');
        
        echo "<html><head><meta charset='UTF-8'></head><body>";
        echo "<h2>Employee Report - " . date('F d, Y') . "</h2>";
        echo "<p>Total Employees: $total_employees | Active: $active_employees | Inactive: $inactive_employees</p>";
        echo "<table border='1' cellpadding='5' cellspacing='0'>";
        echo "<thead><tr>";
        echo "<th>Employee ID</th>";
        echo "<th>Full Name</th>";
        echo "<th>Gender</th>";
        echo "<th>National ID</th>";
        echo "<th>Email</th>";
        echo "<th>Phone</th>";
        echo "<th>Designation</th>";
        echo "<th>Department</th>";
        echo "<th>Section</th>";
        echo "<th>Sub-Section</th>";
        echo "<th>Employee Type</th>";
        echo "<th>Employment Type</th>";
        echo "<th>Status</th>";
        echo "<th>Job Group</th>";
        echo "<th>Hire Date</th>";
        echo "</tr></thead><tbody>";
        
        foreach ($employees as $emp) {
            echo "<tr>";
            echo "<td>" . htmlspecialchars($emp['employee_id']) . "</td>";
            echo "<td>" . htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name'] . ' ' . $emp['surname']) . "</td>";
            echo "<td>" . htmlspecialchars($emp['gender'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['national_id'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['email'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['phone'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['designation'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['department_name'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['section_name'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['subsection_name'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars(ucwords(str_replace('_', ' ', $emp['employee_type'] ?? ''))) . "</td>";
            echo "<td>" . htmlspecialchars(ucwords($emp['employment_type'] ?? 'N/A')) . "</td>";
            echo "<td>" . htmlspecialchars(ucwords($emp['employee_status'] ?? 'N/A')) . "</td>";
            echo "<td>" . htmlspecialchars($emp['scale_id'] ?? 'N/A') . "</td>";
            echo "<td>" . htmlspecialchars($emp['hire_date'] ?? 'N/A') . "</td>";
            echo "</tr>";
        }
        
        echo "</tbody></table></body></html>";
        exit();
    }
    
    if ($export_type === 'pdf') {
        // PDF export using TCPDF or similar library
        // For now, we'll use a simple HTML to PDF approach
        require_once('vendor/tecnickcom/tcpdf/tcpdf.php'); // You'll need to include TCPDF library
        
        $pdf = new TCPDF('L', PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
        $pdf->SetCreator(PDF_CREATOR);
        $pdf->SetAuthor('HR Management System');
        $pdf->SetTitle('Employee Report');
        $pdf->SetSubject('Employee Data');
        
        $pdf->SetHeaderData('', 0, 'Employee Report', date('F d, Y'));
        $pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
        $pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));
        $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
        $pdf->SetMargins(10, 15, 10);
        $pdf->SetHeaderMargin(5);
        $pdf->SetFooterMargin(10);
        $pdf->SetAutoPageBreak(TRUE, 15);
        $pdf->SetFont('helvetica', '', 8);
        
        $pdf->AddPage();
        
        $html = '<h2>Employee Report</h2>';
        $html .= '<p><strong>Generated:</strong> ' . date('F d, Y H:i:s') . '</p>';
        $html .= '<p><strong>Total Employees:</strong> ' . $total_employees . ' | <strong>Active:</strong> ' . $active_employees . ' | <strong>Inactive:</strong> ' . $inactive_employees . '</p>';
        
        $html .= '<table border="1" cellpadding="4">';
        $html .= '<thead><tr style="background-color:#00d4ff;color:#fff;font-weight:bold;">';
        $html .= '<th>ID</th><th>Name</th><th>Designation</th><th>Department</th><th>Section</th><th>Sub-Section</th><th>Type</th><th>Status</th><th>Job Group</th>';
        $html .= '</tr></thead><tbody>';
        
        foreach ($employees as $emp) {
            $html .= '<tr>';
            $html .= '<td>' . htmlspecialchars($emp['employee_id']) . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name']) . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['designation'] ?? 'N/A') . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['department_name'] ?? 'N/A') . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['section_name'] ?? 'N/A') . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['subsection_name'] ?? 'N/A') . '</td>';
            $html .= '<td>' . htmlspecialchars(ucwords(str_replace('_', ' ', $emp['employee_type'] ?? ''))) . '</td>';
            $html .= '<td>' . htmlspecialchars(ucwords($emp['employee_status'] ?? '')) . '</td>';
            $html .= '<td>' . htmlspecialchars($emp['scale_id'] ?? 'N/A') . '</td>';
            $html .= '</tr>';
        }
        
        $html .= '</tbody></table>';
        
        $pdf->writeHTML($html, true, false, true, false, '');
        $pdf->Output('employee_report_' . date('Y-m-d') . '.pdf', 'D');
        exit();
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
    <title>Employee Reports - HR Management System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <div class="main-content">
            <!-- Header -->
            <div class="main-header">
                <div class="header-left">
                    <h1 class="page-title">Employee Reports</h1>
                </div>
            </div>

            <!-- Content -->
            <div class="content">
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3><?php echo $total_employees; ?></h3>
                        <p>Total Employees</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $active_employees; ?></h3>
                        <p>Active Employees</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $inactive_employees; ?></h3>
                        <p>Inactive Employees</p>
                    </div>
                    <div class="stat-card">
                        <h3><?php echo $permanent; ?>/<?php echo $contract; ?>/<?php echo $temporary; ?></h3>
                        <p>P / C / T</p>
                    </div>
                </div>

                <!-- Filters Section -->
                <div class="glass-card">
                    <h3 style="margin-bottom: 1.5rem; color: var(--text-primary);">Filter Options</h3>
                    <form method="GET" action="" id="filterForm">
                        <div class="filter-row">
                            <div class="form-group">
                                <label for="department">Department</label>
                                <select class="form-control" id="department" name="department" onchange="updateSections()">
                                    <option value="">All Departments</option>
                                    <?php foreach ($departments as $dept): ?>
                                        <option value="<?php echo $dept['id']; ?>" <?php echo $department_filter == $dept['id'] ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($dept['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="section">Section</label>
                                <select class="form-control" id="section" name="section" onchange="updateSubSections()">
                                    <option value="">All Sections</option>
                                    <?php foreach ($sections as $sect): ?>
                                        <option value="<?php echo $sect['id']; ?>" 
                                                data-department="<?php echo $sect['department_id']; ?>"
                                                <?php echo $section_filter == $sect['id'] ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($sect['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="subsection">Sub-Section</label>
                                <select class="form-control" id="subsection" name="subsection">
                                    <option value="">All Sub-Sections</option>
                                    <?php foreach ($subsections as $subsect): ?>
                                        <option value="<?php echo $subsect['id']; ?>" 
                                                data-section="<?php echo $subsect['section_id']; ?>"
                                                <?php echo $subsection_filter == $subsect['id'] ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($subsect['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="type">Employee Type</label>
                                <select class="form-control" id="type" name="type">
                                    <option value="">All Types</option>
                                    <option value="officer" <?php echo $type_filter === 'officer' ? 'selected' : ''; ?>>Officer</option>
                                    <option value="section_head" <?php echo $type_filter === 'section_head' ? 'selected' : ''; ?>>Section Head</option>
                                    <option value="sub_section_head" <?php echo $type_filter === 'sub_section_head' ? 'selected' : ''; ?>>Sub Section Head</option>
                                    <option value="manager" <?php echo $type_filter === 'manager' ? 'selected' : ''; ?>>Manager</option>
                                    <option value="hr_manager" <?php echo $type_filter === 'hr_manager' ? 'selected' : ''; ?>>HR Manager</option>
                                    <option value="dept_head" <?php echo $type_filter === 'dept_head' ? 'selected' : ''; ?>>Department Head</option>
                                    <option value="managing_director" <?php echo $type_filter === 'managing_director' ? 'selected' : ''; ?>>Managing Director</option>
                                    <option value="bod_chairman" <?php echo $type_filter === 'bod_chairman' ? 'selected' : ''; ?>>BOD Chairman</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="status">Status</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="">All Status</option>
                                    <option value="active" <?php echo $status_filter === 'active' ? 'selected' : ''; ?>>Active</option>
                                    <option value="inactive" <?php echo $status_filter === 'inactive' ? 'selected' : ''; ?>>Inactive</option>
                                    <option value="resigned" <?php echo $status_filter === 'resigned' ? 'selected' : ''; ?>>Resigned</option>
                                    <option value="fired" <?php echo $status_filter === 'fired' ? 'selected' : ''; ?>>Fired</option>
                                    <option value="retired" <?php echo $status_filter === 'retired' ? 'selected' : ''; ?>>Retired</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="employment_type">Employment Type</label>
                                <select class="form-control" id="employment_type" name="employment_type">
                                    <option value="">All Types</option>
                                    <option value="permanent" <?php echo $employment_type_filter === 'permanent' ? 'selected' : ''; ?>>Permanent</option>
                                    <option value="contract" <?php echo $employment_type_filter === 'contract' ? 'selected' : ''; ?>>Contract</option>
                                    <option value="temporary" <?php echo $employment_type_filter === 'temporary' ? 'selected' : ''; ?>>Temporary</option>
                                    <option value="intern" <?php echo $employment_type_filter === 'intern' ? 'selected' : ''; ?>>Intern</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="job_group">Job Group</label>
                                <select class="form-control" id="job_group" name="job_group">
                                    <option value="">All Groups</option>
                                    <?php 
                                    $job_groups = ['1', '2', '3', '3A', '3B', '3C', '4', '5', '6', '7', '8', '9', '10'];
                                    foreach ($job_groups as $group): ?>
                                        <option value="<?php echo $group; ?>" <?php echo $job_group_filter === $group ? 'selected' : ''; ?>>
                                            <?php echo $group; ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="date_from">Hire Date From</label>
                                <input type="date" class="form-control" id="date_from" name="date_from" value="<?php echo htmlspecialchars($date_from); ?>">
                            </div>

                            <div class="form-group">
                                <label for="date_to">Hire Date To</label>
                                <input type="date" class="form-control" id="date_to" name="date_to" value="<?php echo htmlspecialchars($date_to); ?>">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">Apply Filters</button>
                            <a href="employee_reports.php" class="btn btn-secondary">Clear Filters</a>
                        </div>
                    </form>
                </div>

                <!-- Export Buttons -->
                <div class="glass-card" style="text-align: center;">
                    <h3 style="margin-bottom: 1.5rem; color: var(--text-primary);">Export Report</h3>
                    <div class="action-buttons" style="justify-content: center;">
                        <button onclick="exportReport('pdf')" class="btn btn-danger">
                            📄 Export to PDF
                        </button>
                        <button onclick="exportReport('excel')" class="btn btn-success">
                            📊 Export to Excel
                        </button>
                    </div>
                </div>

                <!-- Employee Table -->
                <div class="table-container">
                    <h3 style="margin-bottom: 1rem; color: var(--text-primary);">
                        Employee List (<?php echo $total_employees; ?> records)
                    </h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Full Name</th>
                                <th>Gender</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Designation</th>
                                <th>Department</th>
                                <th>Section</th>
                                <th>Sub-Section</th>
                                <th>Type</th>
                                <th>Employment</th>
                                <th>Status</th>
                                <th>Job Group</th>
                                <th>Hire Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (empty($employees)): ?>
                                <tr>
                                    <td colspan="14" class="text-center">No employees found matching the selected filters</td>
                                </tr>
                            <?php else: ?>
                                <?php foreach ($employees as $emp): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($emp['employee_id']); ?></td>
                                        <td><?php echo htmlspecialchars($emp['first_name'] . ' ' . $emp['last_name'] . ' ' . $emp['surname']); ?></td>
                                        <td><?php echo htmlspecialchars(ucfirst($emp['gender'] ?? 'N/A')); ?></td>
                                        <td><?php echo htmlspecialchars($emp['email'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['phone'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['designation'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['department_name'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['section_name'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['subsection_name'] ?? 'N/A'); ?></td>
                                        <td>
                                            <span class="badge badge-info">
                                                <?php echo ucwords(str_replace('_', ' ', $emp['employee_type'] ?? 'N/A')); ?>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-primary">
                                                <?php echo ucwords($emp['employment_type'] ?? 'N/A'); ?>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge badge-<?php echo $emp['employee_status'] === 'active' ? 'success' : 'secondary'; ?>">
                                                <?php echo ucwords($emp['employee_status'] ?? 'N/A'); ?>
                                            </span>
                                        </td>
                                        <td><?php echo htmlspecialchars($emp['scale_id'] ?? 'N/A'); ?></td>
                                        <td><?php echo htmlspecialchars($emp['hire_date'] ? date('M d, Y', strtotime($emp['hire_date'])) : 'N/A'); ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Sections and subsections data for dynamic filtering
        const sectionsData = <?php echo json_encode($sections); ?>;
        const subsectionsData = <?php echo json_encode($subsections); ?>;

        function updateSections() {
            const departmentId = document.getElementById('department').value;
            const sectionSelect = document.getElementById('section');
            const subsectionSelect = document.getElementById('subsection');
            const currentSectionValue = sectionSelect.value;
            const currentSubsectionValue = subsectionSelect.value;
            
            // Clear sections and add default option
            sectionSelect.innerHTML = '<option value="">All Sections</option>';
            // Clear subsections
            subsectionSelect.innerHTML = '<option value="">All Sub-Sections</option>';
            
            if (departmentId) {
                const filteredSections = sectionsData.filter(section => section.department_id == departmentId);
                filteredSections.forEach(section => {
                    const option = document.createElement('option');
                    option.value = section.id;
                    option.textContent = section.name;
                    if (section.id == currentSectionValue) {
                        option.selected = true;
                    }
                    sectionSelect.appendChild(option);
                });
            } else {
                // Show all sections
                sectionsData.forEach(section => {
                    const option = document.createElement('option');
                    option.value = section.id;
                    option.textContent = section.name + ' (' + section.department_name + ')';
                    if (section.id == currentSectionValue) {
                        option.selected = true;
                    }
                    sectionSelect.appendChild(option);
                });
            }
            
            // Update subsections based on selected section
            updateSubSections();
        }

        function updateSubSections() {
            const sectionId = document.getElementById('section').value;
            const subsectionSelect = document.getElementById('subsection');
            const currentValue = subsectionSelect.value;
            
            // Clear and add default option
            subsectionSelect.innerHTML = '<option value="">All Sub-Sections</option>';
            
            if (sectionId) {
                const filteredSubsections = subsectionsData.filter(subsection => subsection.section_id == sectionId);
                filteredSubsections.forEach(subsection => {
                    const option = document.createElement('option');
                    option.value = subsection.id;
                    option.textContent = subsection.name;
                    if (subsection.id == currentValue) {
                        option.selected = true;
                    }
                    subsectionSelect.appendChild(option);
                });
            } else if (document.getElementById('department').value) {
                // If department is selected but no section, show all subsections in that department
                const departmentId = document.getElementById('department').value;
                const filteredSubsections = subsectionsData.filter(subsection => subsection.department_id == departmentId);
                filteredSubsections.forEach(subsection => {
                    const option = document.createElement('option');
                    option.value = subsection.id;
                    option.textContent = subsection.name + ' (' + subsection.section_name + ')';
                    if (subsection.id == currentValue) {
                        option.selected = true;
                    }
                    subsectionSelect.appendChild(option);
                });
            } else {
                // Show all subsections
                subsectionsData.forEach(subsection => {
                    const option = document.createElement('option');
                    option.value = subsection.id;
                    option.textContent = subsection.name + ' (' + subsection.section_name + ' - ' + subsection.department_name + ')';
                    if (subsection.id == currentValue) {
                        option.selected = true;
                    }
                    subsectionSelect.appendChild(option);
                });
            }
        }

        function exportReport(type) {
            const form = document.getElementById('filterForm');
            const url = new URL(window.location.href);
            url.searchParams.set('export', type);
            
            // Add all current filter parameters
            const formData = new FormData(form);
            for (let [key, value] of formData.entries()) {
                if (value) {
                    url.searchParams.set(key, value);
                }
            }
            
            window.location.href = url.toString();
        }

        // Initialize sections and subsections on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateSections();
            updateSubSections();
        });
    </script>
</body>
</html>