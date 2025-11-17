<?php
require_once 'config.php';
require_once 'auth_check.php';

$conn = getConnection();

header('Content-Type: application/json');

if (!isset($_GET['employee_id']) || !isset($_GET['start_date']) || !isset($_GET['end_date'])) {
    echo json_encode(['error' => 'Missing parameters']);
    exit;
}

$employeeId = (int)$_GET['employee_id'];
$startDate = $_GET['start_date'];
$endDate = $_GET['end_date'];

// Function to check overlapping leaves (same as in main file)
function checkOverlappingLeaves($targetEmployeeId, $startDate, $endDate, $conn) {
    $query = "SELECT la.*, lt.name as leave_type_name 
              FROM leave_applications la 
              JOIN leave_types lt ON la.leave_type_id = lt.id 
              WHERE la.employee_id = ?  
              AND la.status IN ('pending_subsection_head', 'pending_section_head', 'pending_dept_head', 'pending_managing_director', 'pending_hr', 'pending_bod_chair', 'approved')
              AND ((la.start_date BETWEEN ? AND ?) 
                   OR (la.end_date BETWEEN ? AND ?) 
                   OR (? BETWEEN la.start_date AND la.end_date) 
                   OR (? BETWEEN la.start_date AND la.end_date))
              ORDER BY la.start_date";
    
    $stmt = $conn->prepare($query);
    $stmt->bind_param("issssss", $targetEmployeeId, $startDate, $endDate, $startDate, $endDate, $startDate, $endDate);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $overlapping = [];
    while ($row = $result->fetch_assoc()) {
        $overlapping[] = [
            'leave_type_name' => $row['leave_type_name'],
            'start_date' => date('M d, Y', strtotime($row['start_date'])),
            'end_date' => date('M d, Y', strtotime($row['end_date'])),
            'status_display' => getStatusDisplayName($row['status'])
        ];
    }
    
    return $overlapping;
}

function getStatusDisplayName($status) {
    switch ($status) {
        case 'approved': return 'Approved';
        case 'rejected': return 'Rejected';
        case 'pending': return 'Pending';
        case 'pending_subsection_head': return 'Pending Subsection Head Approval';
        case 'pending_section_head': return 'Pending Section Head Approval';
        case 'pending_dept_head': return 'Pending Department Head Approval';
        case 'pending_managing_director': return 'Pending Managing Director Approval';
        case 'pending_hr': return 'Pending HR Approval';
        case 'pending_bod_chair': return 'Pending BOD Chair Approval';
        default: return ucfirst($status);
    }
}

$overlapping = checkOverlappingLeaves($employeeId, $startDate, $endDate, $conn);

echo json_encode([
    'overlapping' => $overlapping,
    'has_overlap' => !empty($overlapping)
]);
?>