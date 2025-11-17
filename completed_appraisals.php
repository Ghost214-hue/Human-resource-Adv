<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Start session at the very beginning
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// After successful login verification in other pages
if (!isset($_SESSION['hr_system_user_id']) && isset($_SESSION['user_id'])) {
    $_SESSION['hr_system_user_id'] = $_SESSION['user_id'];
    $_SESSION['hr_system_username'] = $_SESSION['user_name'] ?? '';
    $_SESSION['hr_system_user_role'] = $_SESSION['user_role'] ?? '';
}

require_once 'auth_check.php';
require_once 'vendor/autoload.php';
use Dompdf\Dompdf;

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

require_once 'config.php';
require_once 'auth.php';
$conn = getConnection();

// Get current user's employee record
$userEmployeeQuery = "SELECT e.* FROM employees e 
                     LEFT JOIN users u ON u.employee_id = e.employee_id 
                     WHERE u.id = ?";
$stmt = $conn->prepare($userEmployeeQuery);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$currentEmployee = $stmt->get_result()->fetch_assoc();

// Export functions with centered logo
function exportToPDF($appraisal, $scores, $totalScore) {
    $html = generateAppraisalHTML($appraisal, $scores, $totalScore);
    
    $dompdf = new Dompdf();
    $dompdf->loadHtml($html);
    $dompdf->setPaper('A4', 'portrait');
    
    // Set options for better image handling
    $dompdf->set_option('isRemoteEnabled', true);
    $dompdf->set_option('defaultFont', 'Arial');
    
    $dompdf->render();
    
    // Output the PDF
    $dompdf->stream("MUWASCO_Appraisal_" . $appraisal['emp_id'] . "_" . date('Y-m-d') . ".pdf", [
        "Attachment" => true,
        "compress" => true
    ]);
    exit();
}

function exportToWord($appraisal, $scores, $totalScore) {
    // Clean any output buffers
    while (ob_get_level()) {
        ob_end_clean();
    }
    
    // Start new output buffer
    ob_start();
    
    // Set proper headers for Word document
    header("Content-Type: application/vnd.ms-word; charset=utf-8");
    header("Content-Disposition: attachment; filename=MUWASCO_Appraisal_" . $appraisal['emp_id'] . "_" . date('Y-m-d') . ".doc");
    header("Cache-Control: no-cache, no-store, must-revalidate");
    header("Pragma: no-cache");
    header("Expires: 0");
    
    echo generateAppraisalHTML($appraisal, $scores, $totalScore);
    
    // Flush and clean buffer
    ob_end_flush();
    exit();
}

function exportToPrint($appraisal, $scores, $totalScore) {
    $html = generateAppraisalHTML($appraisal, $scores, $totalScore);
    // Add print script
    $html = str_replace('</body>', '<script>window.onload = function() { window.print(); }</script></body>', $html);
    echo $html;
    exit();
}

// Improved HTML generation function with centered logo
function generateAppraisalHTML($appraisal, $scores, $totalScore) {
    // Ensure all variables are properly escaped
    $employee_name = htmlspecialchars($appraisal['first_name'] . ' ' . $appraisal['last_name']);
    $employee_id = htmlspecialchars($appraisal['emp_id']);
    $cycle_name = htmlspecialchars($appraisal['cycle_name']);
    $department = htmlspecialchars($appraisal['department_name'] ?? 'N/A');
    $section = htmlspecialchars($appraisal['section_name'] ?? 'N/A');
    $appraiser_name = htmlspecialchars($appraisal['appraiser_first_name'] . ' ' . $appraisal['appraiser_last_name']);
    
    // Logo handling - try base64 first, then fallback to URL
    $logo_html = '';
    $logo_file_path = $_SERVER['DOCUMENT_ROOT'] . dirname($_SERVER['PHP_SELF']) . '/muwascologo.png';
    
    if (file_exists($logo_file_path)) {
        // Use base64 encoded image for better compatibility
        $logo_data = base64_encode(file_get_contents($logo_file_path));
        $logo_html = '<img src="data:image/png;base64,' . $logo_data . '" alt="MUWASCO Logo" style="height: 80px; width: auto; display: block; margin: 0 auto;">';
    } else {
        // Fallback to URL
        $base_url = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]";
        $logo_path = $base_url . dirname($_SERVER['PHP_SELF']) . '/muwascologo.png';
        $logo_html = '<img src="' . $logo_path . '" alt="MUWASCO Logo" style="height: 80px; width: auto; display: block; margin: 0 auto;">';
    }
    
    $html = '<!DOCTYPE html>
<html>
<head>
    <title>Performance Appraisal Report - MUWASCO</title>
    <meta charset="utf-8">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 15px; 
            line-height: 1.3; 
            color: #333;
            font-size: 12px;
        }
        .header { 
            text-align: center;
            margin-bottom: 20px; 
            border-bottom: 2px solid #2c3e50;
            padding-bottom: 15px;
        }
        .logo-container {
            margin-bottom: 10px;
        }
        .logo {
            height: 80px;
            width: auto;
            display: block;
            margin: 0 auto;
        }
        .header h1 {
            font-size: 18px;
            margin: 5px 0;
            color: #2c3e50;
        }
        .header h2 {
            font-size: 16px;
            margin: 5px 0;
            color: #34495e;
            font-weight: normal;
        }
        .header h3 {
            font-size: 14px;
            margin: 5px 0;
            font-weight: normal;
            color: #7f8c8d;
        }
        .company-info {
            font-size: 10px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        .employee-info { 
            margin-bottom: 15px; 
            background: #f8f9fa;
            padding: 12px;
            border-radius: 4px;
            border-left: 4px solid #3498db;
        }
        .employee-info h3 {
            font-size: 14px;
            margin-bottom: 8px;
            color: #2c3e50;
        }
        .info-table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 8px 0; 
            font-size: 11px;
        }
        .info-table th, .info-table td { 
            border: 1px solid #ddd; 
            padding: 6px; 
            text-align: left; 
        }
        .info-table th { 
            background-color: #3498db; 
            color: white;
            font-weight: bold; 
            width: 25%;
        }
        .scores-table { 
            width: 100%; 
            border-collapse: collapse; 
            margin: 15px 0; 
            font-size: 11px;
        }
        .scores-table th, .scores-table td { 
            border: 1px solid #ddd; 
            padding: 6px; 
            text-align: left; 
        }
        .scores-table th { 
            background-color: #3498db; 
            color: white;
            font-weight: bold; 
        }
        .total-score { 
            background-color: #e8f5e9; 
            font-weight: bold; 
        }
        .comments-section { 
            margin-top: 15px; 
            border: 1px solid #ddd; 
            padding: 12px; 
            background: #f9f9f9; 
            font-size: 11px;
            border-radius: 4px;
        }
        .comments-section h3 {
            font-size: 13px;
            margin: 0 0 8px 0;
            color: #2c3e50;
            border-bottom: 1px solid #ddd;
            padding-bottom: 4px;
        }
        @media print {
            body { margin: 10px; }
            .header h1 { color: #333; }
            .no-print { display: none !important; }
            .logo {
                height: 70px;
            }
        }
        .footer {
            margin-top: 30px;
            font-size: 10px; 
            color: #666; 
            border-top: 1px solid #ddd; 
            padding-top: 10px;
            text-align: center;
        }
        .print-buttons {
            text-align: center;
            margin-top: 20px;
        }
        .print-buttons button {
            padding: 8px 16px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 5px;
        }
        .print-buttons button.close-btn {
            background: #f44336;
        }
        .section-title {
            background: #34495e;
            color: white;
            padding: 8px 12px;
            margin: 15px 0 8px 0;
            border-radius: 4px;
            font-size: 13px;
            font-weight: bold;
        }
        .watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 60px;
            color: rgba(0,0,0,0.1);
            z-index: -1;
            pointer-events: none;
        }
        .document-meta {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            font-size: 10px;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div class="watermark">MUWASCO</div>
    
    <div class="header">
        <div class="logo-container">
            ' . $logo_html . '
        </div>
        <h1>MURANGA WATER SUPPLY COMPANY LTD</h1>
        <h2>Performance Appraisal Report</h2>
        <h3>' . $cycle_name . '</h3>
        <div class="company-info">
            P.O. Box 90461 - 80100, MURANGA, Kenya | Tel: +254 (0) 41 2314209 | Email: info@muwasco.co.ke
        </div>
        
        <div class="document-meta">
            <div>Employee: ' . $employee_name . ' (' . $employee_id . ')</div>
            <div>Generated: ' . date('M d, Y H:i:s') . '</div>
        </div>
    </div>
    
    <div class="section-title">Employee Information</div>
    <div class="employee-info">
        <table class="info-table">
            <tr>
                <th>Employee Name</th>
                <td>' . $employee_name . '</td>
            </tr>
            <tr>
                <th>Employee ID</th>
                <td>' . $employee_id . '</td>
            </tr>
            <tr>
                <th>Department</th>
                <td>' . $department . '</td>
            </tr>
            <tr>
                <th>Section</th>
                <td>' . $section . '</td>
            </tr>
            <tr>
                <th>Appraisal Period</th>
                <td>' . date('M d, Y', strtotime($appraisal['start_date'])) . ' - ' . date('M d, Y', strtotime($appraisal['end_date'])) . '</td>
            </tr>
            <tr>
                <th>Appraiser</th>
                <td>' . $appraiser_name . '</td>
            </tr>
            <tr>
                <th>Submitted Date</th>
                <td>' . ($appraisal['status'] === 'submitted' ? date('M d, Y H:i', strtotime($appraisal['submitted_at'])) : 'N/A') . '</td>
            </tr>
        </table>
    </div>
    
    <div class="section-title">Performance Scores</div>
    <table class="scores-table">
        <thead>
            <tr>
                <th>Performance Indicator</th>
                <th>Score</th>
                <th>Max Score</th>
                <th>Percentage</th>
                <th>Comments</th>
            </tr>
        </thead>
        <tbody>';

    // Add scores
    if (!empty($scores)) {
        foreach ($scores as $score) {
            $percentage = ($score['max_score'] > 0) ? ($score['score'] / $score['max_score']) * 100 : 0;
            $indicator_name = htmlspecialchars($score['indicator_name'] ?? 'Performance Indicator');
            $comment = htmlspecialchars($score['appraiser_comment'] ?? '');
            
            $html .= '
            <tr>
                <td>' . $indicator_name . '</td>
                <td>' . intval($score['score']) . '</td>
                <td>' . intval($score['max_score']) . '</td>
                <td>' . number_format($percentage, 1) . '%</td>
                <td>' . $comment . '</td>
            </tr>';
        }
    }
    
    $html .= '
            <tr class="total-score">
                <td colspan="3"><strong>Overall Performance Score</strong></td>
                <td><strong>' . number_format($totalScore, 1) . '%</strong></td>
                <td></td>
            </tr>
        </tbody>
    </table>';

    // Add employee comments if available
    if (!empty($appraisal['employee_comment'])) {
        $employee_comment = nl2br(htmlspecialchars($appraisal['employee_comment']));
        $comment_date = date('M d, Y H:i', strtotime($appraisal['employee_comment_date']));
        
        $html .= '
        <div class="section-title">Employee Comments</div>
        <div class="comments-section">
            <p>' . $employee_comment . '</p>
            <p><small>Commented on: ' . $comment_date . '</small></p>
        </div>';
    }

    // Add supervisor comments if available
    if (!empty($appraisal['supervisors_comment'])) {
        $supervisor_comment = nl2br(htmlspecialchars($appraisal['supervisors_comment']));
        $supervisor_comment_date = date('M d, Y H:i', strtotime($appraisal['supervisors_comment_date']));
        
        $html .= '
        <div class="section-title">Supervisor Comments</div>
        <div class="comments-section">
            <p>' . $supervisor_comment . '</p>
            <p><small>Commented on: ' . $supervisor_comment_date . '</small></p>
        </div>';
    }

    $html .= '
    <div class="footer">
        <p><strong>Confidential Document - For Official Use Only</strong></p>
        <p>This performance appraisal report is generated by MUWASCO HR Management System</p>
        <p>© ' . date('Y') . ' Muranga Water Supply Company Ltd. All rights reserved.</p>
    </div>
    
    <div class="print-buttons no-print">
        <button onclick="window.print()">Print Now</button>
        <button onclick="window.close()" class="close-btn">Close</button>
    </div>
</body>
</html>';

    return $html;
}

// Handle export requests
if (isset($_POST['export']) && isset($_POST['appraisal_id'])) {
    $appraisal_id = intval($_POST['appraisal_id']);
    $export_type = $_POST['export_type'];
    
    // Validate inputs
    if ($appraisal_id <= 0 || !in_array($export_type, ['pdf', 'word', 'print'])) {
        die('Invalid export parameters');
    }
    
    // Get detailed appraisal data for export
    $exportQuery = "
        SELECT 
            ea.*,
            ac.name as cycle_name,
            ac.start_date,
            ac.end_date,
            e.first_name,
            e.last_name,
            e.employee_id as emp_id,
            d.name as department_name,
            s.name as section_name,
            e_appraiser.first_name as appraiser_first_name,
            e_appraiser.last_name as appraiser_last_name
        FROM employee_appraisals ea
        JOIN employees e ON ea.employee_id = e.id
        LEFT JOIN departments d ON e.department_id = d.id
        LEFT JOIN sections s ON e.section_id = s.id
        JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id
        JOIN employees e_appraiser ON ea.appraiser_id = e_appraiser.id
        WHERE ea.id = ? AND ea.status = 'submitted'
    ";
    
    // Add role-based restrictions
    $exportParamTypes = "i";
    $exportParams = [$appraisal_id];

    if (!hasPermission('hr_manager')) {  // hr_manager, super_admin, managing_director can see all
        if (hasPermission('dept_head')) {
            $exportQuery .= " AND e.department_id = ?";
            $exportParamTypes .= "i";
            $exportParams[] = $currentEmployee['department_id'];
        } elseif (hasPermission('section_head') || hasPermission('manager')) {
            $exportQuery .= " AND e.section_id = ?";
            $exportParamTypes .= "i";
            $exportParams[] = $currentEmployee['section_id'];
        } else {
            $exportQuery .= " AND ea.employee_id = ?";
            $exportParamTypes .= "i";
            $exportParams[] = $currentEmployee['id'];
        }
    }
    
    $exportStmt = $conn->prepare($exportQuery);
    if (!$exportStmt) {
        error_log('Database error in export query: ' . $conn->error);
        die('Database error: Unable to prepare export query');
    }
    $exportStmt->bind_param($exportParamTypes, ...$exportParams);
    
    if (!$exportStmt->execute()) {
        error_log('Query execution failed: ' . $exportStmt->error);
        die('Query execution failed: ' . $exportStmt->error);
    }
    
    $appraisalData = $exportStmt->get_result()->fetch_assoc();
    
    if (!$appraisalData) {
        die('Appraisal not found or access denied');
    }
    
    // Get scores for this appraisal
    $scoresQuery = "
        SELECT 
            as_.*,
            pi.name as indicator_name,
            pi.description as indicator_description,
            pi.max_score
        FROM appraisal_scores as_
        JOIN performance_indicators pi ON as_.performance_indicator_id = pi.id
        WHERE as_.employee_appraisal_id = ?
        ORDER BY pi.max_score DESC, pi.name
    ";
    
    $scoresStmt = $conn->prepare($scoresQuery);
    if (!$scoresStmt) {
        error_log('Database error in scores query: ' . $conn->error);
        die('Database error: Unable to prepare scores query');
    }
    
    $scoresStmt->bind_param("i", $appraisal_id);
    if (!$scoresStmt->execute()) {
        error_log('Query execution failed: ' . $scoresStmt->error);
        die('Query execution failed: ' . $scoresStmt->error);
    }
    
    $scores = $scoresStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    
    // Calculate total score without weights
    $total_score = 0;
    $total_max = 0;
    foreach ($scores as $score) {
        if ($score['max_score'] > 0) {
            $total_score += $score['score'];
            $total_max += $score['max_score'];
        }
    }
    $final_percentage = $total_max > 0 ? ($total_score / $total_max) * 100 : 0;
    
    // Handle different export types
    switch ($export_type) {
        case 'pdf':
            exportToPDF($appraisalData, $scores, $final_percentage);
            break;
        case 'word':
            exportToWord($appraisalData, $scores, $final_percentage);
            break;
        case 'print':
            exportToPrint($appraisalData, $scores, $final_percentage);
            break;
        default:
            die('Invalid export type');
    }
}

// Get appraisal cycles for filtering
$cyclesStmt = $conn->prepare("SELECT * FROM appraisal_cycles ORDER BY start_date DESC");
$cyclesStmt->execute();
$cycles = $cyclesStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get departments for filtering
$departmentsStmt = $conn->prepare("SELECT DISTINCT d.id, d.name FROM departments d 
                                   JOIN employees e ON e.department_id = d.id 
                                   ORDER BY d.name");
$departmentsStmt->execute();
$departments = $departmentsStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get sections for filtering
$sectionsStmt = $conn->prepare("SELECT DISTINCT s.id, s.name FROM sections s 
                                JOIN employees e ON e.section_id = s.id 
                                ORDER BY s.name");
$sectionsStmt->execute();
$sections = $sectionsStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Define status options
$statuses = ['draft', 'awaiting_employee', 'awaiting_submission', 'submitted'];

// Get employees based on user role
$employees = [];
if (hasPermission('hr_manager')) {  // Covers hr_manager, managing_director, super_admin
    // Can see all employees
    $employeesStmt = $conn->prepare("SELECT id, first_name, last_name, employee_id FROM employees ORDER BY first_name, last_name");
    $employeesStmt->execute();
    $employees = $employeesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
} elseif (hasPermission('dept_head')) {
    // Department Head can see employees in their department
    $employeesStmt = $conn->prepare("SELECT id, first_name, last_name, employee_id FROM employees WHERE department_id = ? ORDER BY first_name, last_name");
    $employeesStmt->bind_param("i", $currentEmployee['department_id']);
    $employeesStmt->execute();
    $employees = $employeesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
} elseif (hasPermission('section_head') || hasPermission('manager')) {
    // Section Head and Manager can see employees in their section
    $employeesStmt = $conn->prepare("SELECT id, first_name, last_name, employee_id FROM employees WHERE section_id = ? ORDER BY first_name, last_name");
    $employeesStmt->bind_param("i", $currentEmployee['section_id']);
    $employeesStmt->execute();
    $employees = $employeesStmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

// Filter parameters
$selected_cycle = $_GET['cycle_id'] ?? '';
$selected_employee = $_GET['employee_id'] ?? '';
$selected_department = $_GET['department_id'] ?? '';
$selected_section = $_GET['section_id'] ?? '';
$selected_status = $_GET['status'] ?? '';

// Build query based on user permissions and filters
$appraisalsQuery = "
    SELECT 
        ea.*,
        ac.name as cycle_name,
        ac.start_date,
        ac.end_date,
        e.first_name,
        e.last_name,
        e.employee_id as emp_id,
        d.name as department_name,
        s.name as section_name,
        e_appraiser.first_name as appraiser_first_name,
        e_appraiser.last_name as appraiser_last_name
    FROM employee_appraisals ea
    JOIN employees e ON ea.employee_id = e.id
    LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN sections s ON e.section_id = s.id
    JOIN appraisal_cycles ac ON ea.appraisal_cycle_id = ac.id
    JOIN employees e_appraiser ON ea.appraiser_id = e_appraiser.id
    WHERE 1=1
";

$queryParams = [];
$paramTypes = "";

// Add filters
if ($selected_cycle) {
    $appraisalsQuery .= " AND ea.appraisal_cycle_id = ?";
    $queryParams[] = $selected_cycle;
    $paramTypes .= "i";
}

if ($selected_department) {
    $appraisalsQuery .= " AND e.department_id = ?";
    $queryParams[] = $selected_department;
    $paramTypes .= "i";
}

if ($selected_section) {
    $appraisalsQuery .= " AND e.section_id = ?";
    $queryParams[] = $selected_section;
    $paramTypes .= "i";
}

if ($selected_status) {
    $appraisalsQuery .= " AND ea.status = ?";
    $queryParams[] = $selected_status;
    $paramTypes .= "s";
}

// Employee filter based on user role
if (hasPermission('hr_manager') || hasPermission('managing_director')) {  // Covers hr_manager, managing_director, super_admin
    // Can see all appraisals
    if ($selected_employee) {
        $appraisalsQuery .= " AND ea.employee_id = ?";
        $queryParams[] = $selected_employee;
        $paramTypes .= "i";
    }
} elseif (hasPermission('dept_head')) {
    // Department Head can see appraisals for employees in their department
    $appraisalsQuery .= " AND e.department_id = ?";
    $queryParams[] = $currentEmployee['department_id'];
    $paramTypes .= "i";
    
    if ($selected_employee) {
        $appraisalsQuery .= " AND ea.employee_id = ?";
        $queryParams[] = $selected_employee;
        $paramTypes .= "i";
    }
} elseif (hasPermission('section_head') || hasPermission('manager')) {
    // Section Head and Manager can see appraisals for employees in their section
    $appraisalsQuery .= " AND e.section_id = ?";
    $queryParams[] = $currentEmployee['section_id'];
    $paramTypes .= "i";
    
    if ($selected_employee) {
        $appraisalsQuery .= " AND ea.employee_id = ?";
        $queryParams[] = $selected_employee;
        $paramTypes .= "i";
    }
} else {
    // Regular employees/officers can only see their own appraisals
    $appraisalsQuery .= " AND ea.employee_id = ?";
    $queryParams[] = $currentEmployee['id'];
    $paramTypes .= "i";
}

$appraisalsQuery .= " ORDER BY ea.submitted_at DESC, ac.start_date DESC";

$appraisalsStmt = $conn->prepare($appraisalsQuery);
if (!empty($queryParams)) {
    $appraisalsStmt->bind_param($paramTypes, ...$queryParams);
}
$appraisalsStmt->execute();
$appraisals = $appraisalsStmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get scores for all appraisals
$scores_by_appraisal = [];
if (!empty($appraisals)) {
    $appraisal_ids = array_column($appraisals, 'id');
    $placeholders = str_repeat('?,', count($appraisal_ids) - 1) . '?';
    
    $scoresQuery = "
        SELECT 
            as_.*,
            pi.max_score,
            pi.name as indicator_name
        FROM appraisal_scores as_
        JOIN performance_indicators pi ON as_.performance_indicator_id = pi.id
        WHERE as_.employee_appraisal_id IN ($placeholders)
    ";
    
    $scoresStmt = $conn->prepare($scoresQuery);
    $types = str_repeat('i', count($appraisal_ids));
    $scoresStmt->bind_param($types, ...$appraisal_ids);
    $scoresStmt->execute();
    $scores = $scoresStmt->get_result()->fetch_all(MYSQLI_ASSOC);
    
    foreach ($scores as $score) {
        $scores_by_appraisal[$score['employee_appraisal_id']][] = $score;
    }
}

$conn->close();
include 'header.php';
include 'nav_bar.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed Appraisals - HR System</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .filters-section {
            background: var(--bg-glass);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        
        .appraisals-table {
            background: var(--bg-glass);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .table th {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            border: none;
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        
        .table tbody tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }
        
        .table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .score-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .export-buttons {
            display: flex;
            gap: 0.25rem;
            flex-wrap: wrap;
        }
        
        .btn-export {
            padding: 0.375rem 0.75rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-pdf {
            background: #dc3545;
            color: white;
        }
        
        .btn-word {
            background: #0d6efd;
            color: white;
        }
        
        .btn-print {
            background: #28a745;
            color: white;
        }
        
        .btn-export:hover {
            opacity: 0.8;
            transform: translateY(-1px);
        }
        
        .employee-info {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .employee-details {
            color: var(--text-secondary);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
        
        .no-results {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
            background: var(--bg-glass);
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }
        
        /* Responsive table */
        @media (max-width: 1200px) {
            .table {
                font-size: 0.875rem;
            }
            
            .table th,
            .table td {
                padding: 0.75rem 0.5rem;
            }
            
            .export-buttons {
                flex-direction: column;
                gap: 0.125rem;
            }
        }
        
        @media (max-width: 768px) {
            .appraisals-table {
                overflow-x: auto;
            }
            
            .table {
                min-width: 800px;
            }
        }

        /* Loading states */
        .btn-export:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .export-loading {
            position: relative;
        }

        .export-loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 8px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
 <div class="container">
       
        <!-- Main Content Area -->
        <div class="main-content">
            
            <!-- Content -->
            <div class="content">
                <?php if (isset($_SESSION['flash_message']) && isset($_SESSION['flash_type'])): ?>
    <div class="alert alert-<?php echo htmlspecialchars($_SESSION['flash_type']); ?>">
        <?php echo htmlspecialchars($_SESSION['flash_message']); ?>
        <?php
        // Clear flash message after displaying
        unset($_SESSION['flash_message']);
        unset($_SESSION['flash_type']);
        ?>
    </div>
<?php endif; ?>
       
            <div class="content">
                <!-- Navigation Tabs -->
               <div class="leave-tabs">
                    <a href="strategic_plan.php?tab=goals" class="leave-tab">Strategic Plan</a>
                    <a href="employee_appraisal.php" class="leave-tab ">Employee Appraisal</a>
                    <?php if (in_array($_SESSION['hr_system_user_role'] ?? '', ['hr_manager', 'super_admin', 'manager', 'managing_director', 'section_head', 'dept_head' , 'sub_section_head'])): ?>
                        <a href="performance_appraisal.php" class="leave-tab">Performance Appraisal</a>
                    <?php endif; ?>
                    <?php if (in_array($_SESSION['hr_system_user_role'] ?? '', ['hr_manager', 'super_admin', 'manager'])): ?>
                        <a href="appraisal_management.php" class="leave-tab">Appraisal Management</a>
                    <?php endif; ?>
                    <a href="completed_appraisals.php" class="leave-tab active">Completed Appraisals</a>
                </div>

                <!-- Filters Section -->
                <div class="filters-section">
                    <h3>Filter Appraisals</h3>
                    <form method="GET" action="">
                        <div class="filters-grid">
                            <?php if (hasPermission('hr_manager') || hasPermission('dept_head') || hasPermission('manager') || hasPermission('section_head')): ?>
                            <div class="form-group">
                                <label for="employee_id">Employee</label>
                                <select name="employee_id" id="employee_id" class="form-control">
                                    <option value="">All Employees</option>
                                    <?php foreach ($employees as $employee): ?>
                                        <option value="<?php echo $employee['id']; ?>" <?php echo ($selected_employee == $employee['id']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name'] . ' (' . $employee['employee_id'] . ')'); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <?php endif; ?>
                            
                            <div class="form-group">
                                <label for="cycle_id">Appraisal Cycle</label>
                                <select name="cycle_id" id="cycle_id" class="form-control">
                                    <option value="">All Cycles</option>
                                    <?php foreach ($cycles as $cycle): ?>
                                        <option value="<?php echo $cycle['id']; ?>" <?php echo ($selected_cycle == $cycle['id']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($cycle['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="department_id">Department</label>
                                <select name="department_id" id="department_id" class="form-control">
                                    <option value="">All Departments</option>
                                    <?php foreach ($departments as $department): ?>
                                        <option value="<?php echo $department['id']; ?>" <?php echo ($selected_department == $department['id']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($department['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="section_id">Section</label>
                                <select name="section_id" id="section_id" class="form-control">
                                    <option value="">All Sections</option>
                                    <?php foreach ($sections as $section): ?>
                                        <option value="<?php echo $section['id']; ?>" <?php echo ($selected_section == $section['id']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($section['name']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="status">Status</label>
                                <select name="status" id="status" class="form-control">
                                    <option value="">All Statuses</option>
                                    <?php foreach ($statuses as $status): ?>
                                        <option value="<?php echo $status; ?>" <?php echo ($selected_status == $status) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars(ucfirst(str_replace('_', ' ', $status))); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Filter</button>
                                <a href="completed_appraisals.php" class="btn btn-secondary">Clear</a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Appraisals Table -->
                <?php if (!empty($appraisals)): ?>
                    <div class="appraisals-table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Cycle</th>
                                    <th>Period</th>
                                    <th>Score</th>
                                    <th>Appraiser</th>
                                    <th>Submitted</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($appraisals as $appraisal): 
                                    $appraisal_scores = $scores_by_appraisal[$appraisal['id']] ?? [];
                                    
                                    // Calculate total score without weights
                                    $total_score = 0;
                                    $total_max = 0;
                                    foreach ($appraisal_scores as $score) {
                                        $total_score += $score['score'];
                                        $total_max += $score['max_score'];
                                    }
                                    $final_percentage = $total_max > 0 ? ($total_score / $total_max) * 100 : 0;
                                ?>
                                    <tr>
                                        <td>
                                            <div class="employee-info">
                                                <?php echo htmlspecialchars($appraisal['first_name'] . ' ' . $appraisal['last_name']); ?>
                                            </div>
                                            <div class="employee-details">
                                                ID: <?php echo htmlspecialchars($appraisal['emp_id']); ?><br>
                                                <?php echo htmlspecialchars($appraisal['department_name'] ?? 'N/A'); ?>
                                                <?php if ($appraisal['section_name']): ?>
                                                    - <?php echo htmlspecialchars($appraisal['section_name']); ?>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                        <td>
                                            <strong><?php echo htmlspecialchars($appraisal['cycle_name']); ?></strong>
                                        </td>
                                        <td>
                                            <div>
                                                <?php echo date('M d, Y', strtotime($appraisal['start_date'])); ?><br>
                                                <small class="text-muted">to</small><br>
                                                <?php echo date('M d, Y', strtotime($appraisal['end_date'])); ?>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="score-badge"><?php echo number_format($final_percentage, 1); ?>%</span>
                                        </td>
                                        <td>
                                            <?php echo htmlspecialchars($appraisal['appraiser_first_name'] . ' ' . $appraisal['appraiser_last_name']); ?>
                                        </td>
                                        <td>
                                            <?php echo $appraisal['status'] === 'submitted' ? date('M d, Y', strtotime($appraisal['submitted_at'])) : 'N/A'; ?>
                                        </td>
                                        <td>
                                            <?php echo htmlspecialchars(ucfirst(str_replace('_', ' ', $appraisal['status']))); ?>
                                        </td>
                                        <td>
                                            <?php if ($appraisal['status'] === 'submitted'): ?>
                                                <div class="export-buttons">
                                                    <form method="POST" action="" style="display: inline;">
                                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                                        <input type="hidden" name="export_type" value="pdf">
                                                        <button type="submit" name="export" class="btn-export btn-pdf" title="Export PDF">PDF</button>
                                                    </form>
                                                    
                                                    <form method="POST" action="" style="display: inline;">
                                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                                        <input type="hidden" name="export_type" value="word">
                                                        <button type="submit" name="export" class="btn-export btn-word" title="Export Word">Word</button>
                                                    </form>
                                                    
                                                    <form method="POST" action="" target="_blank" style="display: inline;">
                                                        <input type="hidden" name="appraisal_id" value="<?php echo $appraisal['id']; ?>">
                                                        <input type="hidden" name="export_type" value="print">
                                                        <button type="submit" name="export" class="btn-export btn-print" title="Print">Print</button>
                                                    </form>
                                                </div>
                                            <?php else: ?>
                                                <span>-</span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                    
                    <div style="margin-top: 1rem; text-align: center; color: var(--text-secondary);">
                        <small>Total: <?php echo count($appraisals); ?> appraisal(s)</small>
                    </div>
                <?php else: ?>
                    <div class="no-results">
                        <h3>No Appraisals Found</h3>
                        <p>There are no appraisals matching your current filters.</p>
                        <?php if ($selected_cycle || $selected_employee || $selected_department || $selected_section || $selected_status): ?>
                            <a href="completed_appraisals.php" class="btn btn-primary">View All Appraisals</a>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        // Sidebar toggle functionality
        document.querySelector('.sidebar-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('collapsed');
        });
        
        // Responsive table handling
        function handleResponsiveTable() {
            const table = document.querySelector('.table');
            const container = document.querySelector('.appraisals-table');
            
            if (table && container) {
                if (window.innerWidth <= 768) {
                    container.style.overflowX = 'auto';
                } else {
                    container.style.overflowX = 'visible';
                }
            }
        }
        
        window.addEventListener('resize', handleResponsiveTable);
        window.addEventListener('load', handleResponsiveTable);
        
        // Auto-refresh data every 5 minutes to show new completed appraisals
        setInterval(function() {
            const currentUrl = new URL(window.location);
            const searchParams = currentUrl.searchParams;
            
            // Add a timestamp to prevent caching
            searchParams.set('refresh', Date.now());
            
            // Only auto-refresh if we're still on the same page
            if (window.location.pathname.includes('completed_appraisals.php')) {
                window.location.search = searchParams.toString();
            }
        }, 300000); // 5 minutes
    </script>
</body>
</html>