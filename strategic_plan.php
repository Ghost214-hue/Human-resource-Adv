<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_start();

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Check if user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
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

// Get current user from session
$user = [
    'first_name' => isset($_SESSION['user_name']) ? explode(' ', $_SESSION['user_name'])[0] : 'User',
    'last_name' => isset($_SESSION['user_name']) ? (explode(' ', $_SESSION['user_name'])[1] ?? '') : '',
    'role' => $_SESSION['user_role'] ?? 'guest',
    'id' => $_SESSION['user_id']
];


function formatDate($date) {
    if (!$date) return 'N/A';
    return date('M d, Y', strtotime($date));
}

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Add strategic plan
    if (isset($_POST['add_strategic_plan'])) {
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        $query = "INSERT INTO strategic_plan (name, start_date, end_date, created_at, updated_at) 
                  VALUES ('$name', '$start_date', '$end_date', NOW(), NOW())";
        
        if ($conn->query($query)) {
            $id = $conn->insert_id;
            // Handle image upload
            if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
                $start_year = date('Y', strtotime($start_date));
                $end_year = date('Y', strtotime($end_date));
                $folder = "Uploads/$start_year-$end_year/";
                if (!is_dir($folder)) {
                    mkdir($folder, 0777, true);
                }
                $ext = strtolower(pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION));
                if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) {
                    $image_name = $id . '.' . $ext;
                    $target = $folder . $image_name;
                    if (move_uploaded_file($_FILES['image']['tmp_name'], $target)) {
                        $update_query = "UPDATE strategic_plan SET image='$target' WHERE id=$id";
                        $conn->query($update_query);
                    }
                }
            }
            $_SESSION['flash_message'] = "Strategic plan added successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error adding strategic plan: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=strategic-plans");
        exit();
    }
    
    // Update strategic plan
    if (isset($_POST['update_strategic_plan'])) {
        $id = $conn->real_escape_string($_POST['id']);
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        // Get old data
        $old_query = "SELECT start_date, end_date, image FROM strategic_plan WHERE id='$id'";
        $old_result = $conn->query($old_query);
        if ($old_row = $old_result->fetch_assoc()) {
            $old_start = $old_row['start_date'];
            $old_end = $old_row['end_date'];
            $old_image = $old_row['image'];
            
            $image_update = '';
            $dates_changed = ($start_date != $old_start || $end_date != $old_end);
            
            if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
                // Delete old image
                if ($old_image && file_exists($old_image)) {
                    unlink($old_image);
                }
                // Upload new
                $start_year = date('Y', strtotime($start_date));
                $end_year = date('Y', strtotime($end_date));
                $folder = "Uploads/$start_year-$end_year/";
                if (!is_dir($folder)) {
                    mkdir($folder, 0777, true);
                }
                $ext = strtolower(pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION));
                if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) {
                    $image_name = $id . '.' . $ext;
                    $target = $folder . $image_name;
                    if (move_uploaded_file($_FILES['image']['tmp_name'], $target)) {
                        $image_update = ", image='$target'";
                    }
                }
            } elseif ($dates_changed && $old_image) {
                // Move old image to new folder
                $old_start_year = date('Y', strtotime($old_start));
                $old_end_year = date('Y', strtotime($old_end));
                $new_start_year = date('Y', strtotime($start_date));
                $new_end_year = date('Y', strtotime($end_date));
                $new_folder = "Uploads/$new_start_year-$new_end_year/";
                if (!is_dir($new_folder)) {
                    mkdir($new_folder, 0777, true);
                }
                $ext = pathinfo($old_image, PATHINFO_EXTENSION);
                $new_image_name = $id . '.' . $ext;
                $new_target = $new_folder . $new_image_name;
                if (rename($old_image, $new_target)) {
                    $image_update = ", image='$new_target'";
                }
            }
            
            $query = "UPDATE strategic_plan SET name='$name', start_date='$start_date', 
                      end_date='$end_date' $image_update, updated_at=NOW() WHERE id='$id'";
            
            if ($conn->query($query)) {
                $_SESSION['flash_message'] = "Strategic plan updated successfully";
                $_SESSION['flash_type'] = "success";
            } else {
                $_SESSION['flash_message'] = "Error updating strategic plan: " . $conn->error;
                $_SESSION['flash_type'] = "danger";
            }
        }
        header("Location: strategic_plan.php?tab=strategic-plans");
        exit();
    }
    
    // Add objective
    if (isset($_POST['add_objective'])) {
        $strategic_plan_id = $conn->real_escape_string($_POST['strategic_plan_id']);
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        $query = "INSERT INTO objectives (strategic_plan_id, name, start_date, end_date, created_at, updated_at) 
                  VALUES ('$strategic_plan_id', '$name', '$start_date', '$end_date', NOW(), NOW())";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Objective added successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error adding objective: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=objectives");
        exit();
    }
    
    // Update objective
    if (isset($_POST['update_objective'])) {
        $id = $conn->real_escape_string($_POST['id']);
        $strategic_plan_id = $conn->real_escape_string($_POST['strategic_plan_id']);
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        $query = "UPDATE objectives SET strategic_plan_id='$strategic_plan_id', name='$name', 
                  start_date='$start_date', end_date='$end_date', updated_at=NOW() WHERE id='$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Objective updated successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error updating objective: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=objectives");
        exit();
    }
    
    // Add strategy
    if (isset($_POST['add_strategy'])) {
        $strategic_plan_id = $conn->real_escape_string($_POST['strategic_plan_id']);
        $objective_id = $conn->real_escape_string($_POST['objective_id']);
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        $query = "INSERT INTO strategies (strategic_plan_id, objective_id, name, start_date, end_date, created_at, updated_at) 
                  VALUES ('$strategic_plan_id', '$objective_id', '$name', '$start_date', '$end_date', NOW(), NOW())";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Strategy added successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error adding strategy: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=strategies");
        exit();
    }
    
    // Update strategy
    if (isset($_POST['update_strategy'])) {
        $id = $conn->real_escape_string($_POST['id']);
        $strategic_plan_id = $conn->real_escape_string($_POST['strategic_plan_id']);
        $objective_id = $conn->real_escape_string($_POST['objective_id']);
        $name = $conn->real_escape_string($_POST['name']);
        $start_date = $conn->real_escape_string($_POST['start_date']);
        $end_date = $conn->real_escape_string($_POST['end_date']);
        
        $query = "UPDATE strategies SET strategic_plan_id='$strategic_plan_id', objective_id='$objective_id', name='$name', 
                  start_date='$start_date', end_date='$end_date', updated_at=NOW() WHERE id='$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Strategy updated successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error updating strategy: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=strategies");
        exit();
    }
    
    // Add activity
    if (isset($_POST['add_activity'])) {
        $strategy_id = $conn->real_escape_string($_POST['strategy_id']);
        $activity = $conn->real_escape_string($_POST['activity']);
        $kpi = $conn->real_escape_string($_POST['kpi']);
        $target = $conn->real_escape_string($_POST['target']);
        $y1 = $conn->real_escape_string($_POST['Y1'] ?? '');
        $y2 = $conn->real_escape_string($_POST['Y2'] ?? '');
        $y3 = $conn->real_escape_string($_POST['Y3'] ?? '');
        $y4 = $conn->real_escape_string($_POST['Y4'] ?? '');
        $y5 = $conn->real_escape_string($_POST['Y5'] ?? '');
        $comment = $conn->real_escape_string($_POST['comment'] ?? '');
        
        $query = "INSERT INTO activities (strategy_id, activity, kpi, target, Y1, Y2, Y3, Y4, Y5, comment, created_at, updated_at) 
                  VALUES ('$strategy_id', '$activity', '$kpi', '$target', '$y1', '$y2', '$y3', '$y4', '$y5', '$comment', NOW(), NOW())";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Activity added successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error adding activity: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=activities");
        exit();
    }
    
    // Update activity
    if (isset($_POST['update_activity'])) {
        $id = $conn->real_escape_string($_POST['id']);
        $activity = $conn->real_escape_string($_POST['activity']);
        $kpi = $conn->real_escape_string($_POST['kpi']);
        $target = $conn->real_escape_string($_POST['target']);
        $y1 = $conn->real_escape_string($_POST['Y1'] ?? '');
        $y2 = $conn->real_escape_string($_POST['Y2'] ?? '');
        $y3 = $conn->real_escape_string($_POST['Y3'] ?? '');
        $y4 = $conn->real_escape_string($_POST['Y4'] ?? '');
        $y5 = $conn->real_escape_string($_POST['Y5'] ?? '');
        $comment = $conn->real_escape_string($_POST['comment'] ?? '');
        
        $query = "UPDATE activities SET activity='$activity', kpi='$kpi', target='$target', 
                  Y1='$y1', Y2='$y2', Y3='$y3', Y4='$y4', Y5='$y5', comment='$comment', updated_at=NOW() WHERE id='$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Activity updated successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error updating activity: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=goals");
        exit();
    }
}

// Handle delete actions
if (isset($_GET['action'])) {
    if ($_GET['action'] == 'delete_strategic_plan' && isset($_GET['id'])) {
        $id = $conn->real_escape_string($_GET['id']);
        
        // Delete image
        $image_query = "SELECT image FROM strategic_plan WHERE id = '$id'";
        $image_result = $conn->query($image_query);
        if ($image_row = $image_result->fetch_assoc()) {
            if ($image_row['image'] && file_exists($image_row['image'])) {
                unlink($image_row['image']);
            }
        }
        
        // Delete related objectives, strategies, and activities
        $conn->query("DELETE FROM objectives WHERE strategic_plan_id = '$id'");
        $conn->query("DELETE a FROM activities a LEFT JOIN strategies s ON a.strategy_id = s.id WHERE s.strategic_plan_id = '$id'");
        $conn->query("DELETE FROM strategies WHERE strategic_plan_id = '$id'");
        
        // Delete the strategic plan
        $query = "DELETE FROM strategic_plan WHERE id = '$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Strategic plan and its related data deleted successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error deleting strategic plan: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=strategic-plans");
        exit();
    }
    
    if ($_GET['action'] == 'delete_objective' && isset($_GET['id'])) {
        $id = $conn->real_escape_string($_GET['id']);
        // Update strategies to remove objective_id reference
        $conn->query("UPDATE strategies SET objective_id=NULL WHERE objective_id='$id'");
        $query = "DELETE FROM objectives WHERE id = '$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Objective deleted successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error deleting objective: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=objectives");
        exit();
    }
    
    if ($_GET['action'] == 'delete_strategy' && isset($_GET['id'])) {
        $id = $conn->real_escape_string($_GET['id']);
        // Delete related activities
        $conn->query("DELETE FROM activities WHERE strategy_id = '$id'");
        $query = "DELETE FROM strategies WHERE id = '$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Strategy deleted successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error deleting strategy: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=strategies");
        exit();
    }
    
    if ($_GET['action'] == 'delete_activity' && isset($_GET['id'])) {
        $id = $conn->real_escape_string($_GET['id']);
        $query = "DELETE FROM activities WHERE id = '$id'";
        
        if ($conn->query($query)) {
            $_SESSION['flash_message'] = "Activity deleted successfully";
            $_SESSION['flash_type'] = "success";
        } else {
            $_SESSION['flash_message'] = "Error deleting activity: " . $conn->error;
            $_SESSION['flash_type'] = "danger";
        }
        header("Location: strategic_plan.php?tab=activities");
        exit();
    }
}

// Fetch all strategic plans and get the latest one
$strategic_plans = [];
$latest_plan_id = null;
$query = "SELECT * FROM strategic_plan ORDER BY id DESC"; // Order by id DESC to get latest first
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $strategic_plans[] = $row;
        if ($latest_plan_id === null) {
            $latest_plan_id = $row['id']; // Store the latest plan ID
        }
    }
}

// Fetch all objectives
$objectives = [];
$query = "SELECT o.*, sp.name as strategic_plan_name 
          FROM objectives o 
          LEFT JOIN strategic_plan sp ON o.strategic_plan_id = sp.id 
          ORDER BY o.start_date DESC";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $objectives[] = $row;
    }
}

// Fetch all strategies
$strategies = [];
$query = "SELECT s.*, sp.name as strategic_plan_name, o.name as objective_name 
          FROM strategies s 
          LEFT JOIN strategic_plan sp ON s.strategic_plan_id = sp.id 
          LEFT JOIN objectives o ON s.objective_id = o.id 
          ORDER BY s.start_date DESC";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $strategies[] = $row;
    }
}

// Fetch all activities
$activities = [];
$query = "SELECT a.*, s.name as strategy_name, s.start_date as strategy_start, s.end_date as strategy_end, sp.name as strategic_plan_name, o.name as objective_name, s.strategic_plan_id as strategic_plan_id 
          FROM activities a 
          LEFT JOIN strategies s ON a.strategy_id = s.id 
          LEFT JOIN strategic_plan sp ON s.strategic_plan_id = sp.id 
          LEFT JOIN objectives o ON s.objective_id = o.id 
          ORDER BY s.start_date DESC";
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $activities[] = $row;
    }
}

$conn->close();

// Get strategic plans for dropdown
$strategic_plans_dropdown = [];
foreach ($strategic_plans as $plan) {
    $strategic_plans_dropdown[$plan['id']] = $plan['name'];
}

// Get objectives for dropdown
$objectives_dropdown = [];
foreach ($objectives as $objective) {
    $objectives_dropdown[$objective['id']] = $objective['name'];
}

// Get strategies for dropdown
$strategies_dropdown = [];
foreach ($strategies as $strategy) {
    $strategies_dropdown[$strategy['id']] = $strategy['name'];
}

// Get flash message if exists
$flash_message = '';
$flash_type = '';
if (isset($_SESSION['flash_message'])) {
    $flash_message = $_SESSION['flash_message'];
    $flash_type = $_SESSION['flash_type'];
    unset($_SESSION['flash_message']);
    unset($_SESSION['flash_type']);
}

include 'header.php';
include 'nav_bar.php';
?>
<body>
    <div class="container">
        <!-- Main Content Area -->
        <div class="main-content">
            <div class="content">
                <div class="leave-tabs">
                    <a href="strategic_plan.php?tab=goals" class="leave-tab active">Strategic Plan</a>
                    <a href="employee_appraisal.php" class="leave-tab">Employee Appraisal</a>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager', 'managing_director','dept_head' , 'section_head',  'sub_section_head'])): ?>
                        <a href="performance_appraisal.php" class="leave-tab">Performance Appraisal</a>
                    <?php endif; ?>
                    <?php if (in_array($user['role'], ['hr_manager', 'super_admin', 'manager'])): ?>
                        <a href="appraisal_management.php" class="leave-tab">Appraisal Management</a>
                    <?php endif; ?>
                    <a href="completed_appraisals.php" class="leave-tab">Completed Appraisals</a>
                </div>
                <?php if ($flash_message): ?>
                <div class="alert alert-<?php echo $flash_type; ?>">
                    <?php echo $flash_message; ?>
                </div>
                <?php endif; ?>
                <div class="tabs">
                    <ul>
                        <?php $current_tab = $_GET['tab'] ?? 'goals'; ?>
                        <li><a href="#" class="tab-link <?php echo $current_tab === 'goals' ? 'active' : ''; ?>" data-tab="goals">Goals</a></li>
                        <?php if (hasPermission('hr_manager')): ?>
                            <li><a href="#" class="tab-link <?php echo $current_tab === 'strategic-plans' ? 'active' : ''; ?>" data-tab="strategic-plans">Strategic Plans</a></li>
                            <li><a href="#" class="tab-link <?php echo $current_tab === 'objectives' ? 'active' : ''; ?>" data-tab="objectives">Objectives</a></li>
                            <li><a href="#" class="tab-link <?php echo $current_tab === 'strategies' ? 'active' : ''; ?>" data-tab="strategies">Strategies</a></li>
                            <li><a href="#" class="tab-link <?php echo $current_tab === 'activities' ? 'active' : ''; ?>" data-tab="activities">Activities</a></li>
                        <?php endif; ?>
                    </ul>
                </div>

                <!-- Goals Tab -->
                <div id="goals" class="tab-content <?php echo $current_tab === 'goals' ? 'active' : ''; ?>">
                    <div class="goals-header">
                        <h3 class="goals-title">Strategic Goals</h3>
                        <div class="plan-selector">
                            <label for="strategic_plan_select">Select Strategic Plan:</label>
                            <select id="strategic_plan_select" class="form-control">
                                <option value="">-- Choose a plan --</option>
                                <?php 
                                $latest_plan_id = null;
                                if (!empty($strategic_plans)) {
                                    $latest_plan = reset($strategic_plans);
                                    $latest_plan_id = $latest_plan['id'];
                                }
                                foreach ($strategic_plans as $plan): 
                                ?>
                                <option value="<?php echo $plan['id']; ?>" 
                                        data-image="<?php echo htmlspecialchars($plan['image'] ?? ''); ?>"
                                        <?php echo ($plan['id'] == $latest_plan_id) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($plan['name']); ?>
                                </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="strategic-plan-image-container">
                        <?php if (!empty($strategic_plans) && isset($latest_plan['image']) && $latest_plan['image']): ?>
                            <img id="strategic_plan_image" src="<?php echo htmlspecialchars($latest_plan['image']); ?>" alt="Strategic Plan">
                        <?php else: ?>
                            <div class="no-image-placeholder">
                                <i class="fas fa-image"></i>
                                <h3>No Strategic Plan Image Available</h3>
                                <p>Please select a strategic plan with an uploaded image</p>
                            </div>
                        <?php endif; ?>
                    </div>
                    <div class="card mt-4">
                        <div class="card-header">
                            <h3 class="card-title">Strategic Plan Details</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="table" id="strategies-table">
                                <thead>
                                    <tr>
                                        <th>Strategic Plan</th>
                                        <th>Objective</th>
                                        <th>Strategy</th>
                                        <th>Activity</th>
                                        <th>KPI</th>
                                        <th>Target</th>
                                        <th>Y1</th>
                                        <th>Y2</th>
                                        <th>Y3</th>
                                        <th>Y4</th>
                                        <th>Y5</th>
                                        <th>Comment</th>
                                        <?php if (in_array($user['role'], ['hr_manager', 'dept_head'])): ?>
                                        <th>Actions</th>
                                        <?php endif; ?>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($activities)): ?>
                                        <?php foreach ($activities as $activity): ?>
                                        <tr data-plan-id="<?php echo $activity['strategic_plan_id']; ?>">
                                            <td><?php echo htmlspecialchars($activity['strategic_plan_name'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['objective_name'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['strategy_name']); ?></td>
                                            <td><?php echo htmlspecialchars($activity['activity']); ?></td>
                                            <td><?php echo htmlspecialchars($activity['kpi'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['target'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['Y1'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['Y2'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['Y3'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['Y4'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['Y5'] ?? 'N/A'); ?></td>
                                            <td><?php echo htmlspecialchars($activity['comment'] ?? 'N/A'); ?></td>
                                            <?php if (in_array($user['role'], ['hr_manager', 'dept_head'])): ?>
                                            <td>
                                                <button class="btn btn-sm btn-primary edit-activity-btn" 
                                                        data-id="<?php echo intval($activity['id']); ?>"
                                                        data-activity="<?php echo htmlspecialchars($activity['activity'] ?? ''); ?>"
                                                        data-kpi="<?php echo htmlspecialchars($activity['kpi'] ?? ''); ?>"
                                                        data-target="<?php echo htmlspecialchars($activity['target'] ?? ''); ?>"
                                                        data-y1="<?php echo htmlspecialchars($activity['Y1'] ?? ''); ?>"
                                                        data-y2="<?php echo htmlspecialchars($activity['Y2'] ?? ''); ?>"
                                                        data-y3="<?php echo htmlspecialchars($activity['Y3'] ?? ''); ?>"
                                                        data-y4="<?php echo htmlspecialchars($activity['Y4'] ?? ''); ?>"
                                                        data-y5="<?php echo htmlspecialchars($activity['Y5'] ?? ''); ?>"
                                                        data-comment="<?php echo htmlspecialchars($activity['comment'] ?? ''); ?>">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                            </td>
                                            <?php endif; ?>
                                        </tr>
                                        <?php endforeach; ?>
                                    <?php else: ?>
                                    <tr>
                                        <td colspan="<?php echo in_array($user['role'], ['hr_manager', 'dept_head']) ? '13' : '12'; ?>" class="text-center">
                                            No activities found. Please add activities in the Activities tab.
                                        </td>
                                    </tr>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Strategic Plans Tab -->
                <?php if (hasPermission('hr_manager')): ?>
                <div id="strategic-plans" class="tab-content <?php echo $current_tab === 'strategic-plans' ? 'active' : ''; ?>">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Strategic Plans</h3>
                            <button class="btn btn-primary" onclick="openModal('addStrategicPlanModal')">
                                <i class="fas fa-plus"></i> Add Strategic Plan
                            </button>
                        </div>
                        <?php if (empty($strategic_plans)): ?>
                        <div class="empty-state">
                            <i class="fas fa-chess-board"></i>
                            <h3>No Strategic Plans Found</h3>
                            <p>Get started by adding your first strategic plan</p>
                            <button class="btn btn-primary mt-3" onclick="openModal('addStrategicPlanModal')">
                                <i class="fas fa-plus"></i> Add Strategic Plan
                            </button>
                        </div>
                        <?php else: ?>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Image</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($strategic_plans as $plan): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($plan['name']); ?></td>
                                    <td><?php echo formatDate($plan['start_date']); ?></td>
                                    <td><?php echo formatDate($plan['end_date']); ?></td>
                                    <td>
                                        <?php if (isset($plan['image']) && $plan['image']): ?>
                                        <img src="<?php echo htmlspecialchars($plan['image']); ?>" alt="Plan Image" width="50" height="50" style="border-radius: 4px;">
                                        <?php else: ?>
                                        N/A
                                        <?php endif; ?>
                                    </td>
                                    <td><?php echo formatDate($plan['created_at']); ?></td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="editStrategicPlan(
                                                    <?php echo intval($plan['id']); ?>,
                                                    '<?php echo addslashes($plan['name'] ?? ''); ?>',
                                                    '<?php echo addslashes($plan['start_date'] ?? ''); ?>',
                                                    '<?php echo addslashes($plan['end_date'] ?? ''); ?>',
                                                    '<?php echo addslashes($plan['image'] ?? ''); ?>'
                                                )">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <a href="strategic_plan.php?action=delete_strategic_plan&id=<?php echo $plan['id']; ?>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this strategic plan and all its related data?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Objectives Tab -->
                <?php if (hasPermission('hr_manager')): ?>
                <div id="objectives" class="tab-content <?php echo $current_tab === 'objectives' ? 'active' : ''; ?>">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Objectives</h3>
                            <button class="btn btn-primary" onclick="openModal('addObjectiveModal')">
                                <i class="fas fa-plus"></i> Add Objective
                            </button>
                        </div>
                        <?php if (empty($objectives)): ?>
                        <div class="empty-state">
                            <i class="fas fa-bullseye"></i>
                            <h3>No Objectives Found</h3>
                            <p>Get started by adding your first objective</p>
                            <button class="btn btn-primary mt-3" onclick="openModal('addObjectiveModal')">
                                <i class="fas fa-plus"></i> Add Objective
                            </button>
                        </div>
                        <?php else: ?>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Strategic Plan</th>
                                    <th>Objectives</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($objectives as $objective): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($objective['strategic_plan_name'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($objective['name']); ?></td>
                                    <td><?php echo formatDate($objective['start_date']); ?></td>
                                    <td><?php echo formatDate($objective['end_date']); ?></td>
                                    <td><?php echo formatDate($objective['created_at']); ?></td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="editObjective(
                                                    <?php echo intval($objective['id']); ?>,
                                                    <?php echo intval($objective['strategic_plan_id']); ?>,
                                                    '<?php echo addslashes($objective['name'] ?? ''); ?>',
                                                    '<?php echo addslashes($objective['start_date'] ?? ''); ?>',
                                                    '<?php echo addslashes($objective['end_date'] ?? ''); ?>'
                                                )">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <a href="strategic_plan.php?action=delete_objective&id=<?php echo $objective['id']; ?>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this objective?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Strategies Tab -->
                <?php if (hasPermission('hr_manager')): ?>
                <div id="strategies" class="tab-content <?php echo $current_tab === 'strategies' ? 'active' : ''; ?>">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Strategies</h3>
                            <button class="btn btn-primary" onclick="openModal('addStrategyModal')">
                                <i class="fas fa-plus"></i> Add Strategy
                            </button>
                        </div>
                        <?php if (empty($strategies)): ?>
                        <div class="empty-state">
                            <i class="fas fa-lightbulb"></i>
                            <h3>No Strategies Found</h3>
                            <p>Get started by adding your first strategy</p>
                            <button class="btn btn-primary mt-3" onclick="openModal('addStrategyModal')">
                                <i class="fas fa-plus"></i> Add Strategy
                            </button>
                        </div>
                        <?php else: ?>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Strategic Plan</th>
                                    <th>Objective</th>
                                    <th>Strategy</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($strategies as $strategy): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($strategy['strategic_plan_name'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($strategy['objective_name'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($strategy['name']); ?></td>
                                    <td><?php echo formatDate($strategy['start_date']); ?></td>
                                    <td><?php echo formatDate($strategy['end_date']); ?></td>
                                    <td><?php echo formatDate($strategy['created_at']); ?></td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="editStrategy(
                                                    <?php echo intval($strategy['id']); ?>,
                                                    <?php echo intval($strategy['strategic_plan_id']); ?>,
                                                    <?php echo $strategy['objective_id'] ? intval($strategy['objective_id']) : 'null'; ?>,
                                                    '<?php echo addslashes($strategy['name'] ?? ''); ?>',
                                                    '<?php echo addslashes($strategy['start_date'] ?? ''); ?>',
                                                    '<?php echo addslashes($strategy['end_date'] ?? ''); ?>'
                                                )">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <a href="strategic_plan.php?action=delete_strategy&id=<?php echo $strategy['id']; ?>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this strategy?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Activities Tab -->
                <?php if (hasPermission('hr_manager')): ?>
                <div id="activities" class="tab-content <?php echo $current_tab === 'activities' ? 'active' : ''; ?>">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Activities</h3>
                            <button class="btn btn-primary" onclick="openModal('addActivityModal')">
                                <i class="fas fa-plus"></i> Add Activity
                            </button>
                        </div>
                        <?php if (empty($activities)): ?>
                        <div class="empty-state">
                            <i class="fas fa-tasks"></i>
                            <h3>No Activities Found</h3>
                            <p>Get started by adding your first activity</p>
                            <button class="btn btn-primary mt-3" onclick="openModal('addActivityModal')">
                                <i class="fas fa-plus"></i> Add Activity
                            </button>
                        </div>
                        <?php else: ?>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Strategy</th>
                                    <th>Activity</th>
                                    <th>KPI</th>
                                    <th>Target</th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($activities as $activity): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($activity['strategy_name'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($activity['activity']); ?></td>
                                    <td><?php echo htmlspecialchars($activity['kpi'] ?? 'N/A'); ?></td>
                                    <td><?php echo htmlspecialchars($activity['target'] ?? 'N/A'); ?></td>
                                    <td><?php echo formatDate($activity['created_at']); ?></td>
                                    <td>
                                        <button class="btn btn-sm btn-primary edit-activity-btn" 
                                                data-id="<?php echo intval($activity['id']); ?>"
                                                data-activity="<?php echo htmlspecialchars($activity['activity'] ?? ''); ?>"
                                                data-kpi="<?php echo htmlspecialchars($activity['kpi'] ?? ''); ?>"
                                                data-target="<?php echo htmlspecialchars($activity['target'] ?? ''); ?>"
                                                data-y1="<?php echo htmlspecialchars($activity['Y1'] ?? ''); ?>"
                                                data-y2="<?php echo htmlspecialchars($activity['Y2'] ?? ''); ?>"
                                                data-y3="<?php echo htmlspecialchars($activity['Y3'] ?? ''); ?>"
                                                data-y4="<?php echo htmlspecialchars($activity['Y4'] ?? ''); ?>"
                                                data-y5="<?php echo htmlspecialchars($activity['Y5'] ?? ''); ?>"
                                                data-comment="<?php echo htmlspecialchars($activity['comment'] ?? ''); ?>">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <a href="strategic_plan.php?action=delete_activity&id=<?php echo $activity['id']; ?>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this activity?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Modals -->
                <?php if (hasPermission('hr_manager')): ?>
                <!-- All modals remain unchanged (no inline CSS) -->
                <div id="addStrategicPlanModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="name">Plan Name</label>
                                <input type="text" class="form-control" name="name" placeholder="Plan Name" required>
                            </div>
                            <div class="form-group">
                                <label for="start_date">Start Date</label>
                                <input type="date" class="form-control" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="end_date">End Date</label>
                                <input type="date" class="form-control" name="end_date" required>
                            </div>
                            <div class="form-group">
                                <label for="image">Image</label>
                                <input type="file" class="form-control" name="image" accept="image/*">
                            </div>
                            <button type="submit" class="btn btn-primary" name="add_strategic_plan">Add Strategic Plan</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addStrategicPlanModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Edit Strategic Plan Modal -->
                <div id="editStrategicPlanModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php" enctype="multipart/form-data">
                            <input type="hidden" id="edit_strategic_plan_id" name="id">
                            <div class="form-group">
                                <label for="edit_name">Plan Name</label>
                                <input type="text" class="form-control" id="edit_name" name="name" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_start_date">Start Date</label>
                                <input type="date" class="form-control" id="edit_start_date" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_end_date">End Date</label>
                                <input type="date" class="form-control" id="edit_end_date" name="end_date" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_image">Image</label>
                                <input type="file" class="form-control" id="edit_image" name="image" accept="image/*">
                                <img id="edit_image_preview" style="display: none; margin-top: 10px;" width="100" alt="Preview">
                            </div>
                            <button type="submit" class="btn btn-primary" name="update_strategic_plan">Update Strategic Plan</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('editStrategicPlanModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Add Objective Modal -->
                <div id="addObjectiveModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <div class="form-group">
                                <label for="strategic_plan_id">Strategic Plan</label>
                                <select class="form-control" name="strategic_plan_id" required>
                                    <?php foreach ($strategic_plans_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="name">Objective Name</label>
                                <input type="text" class="form-control" name="name" placeholder="Objective Name" required>
                            </div>
                            <div class="form-group">
                                <label for="start_date">Start Date</label>
                                <input type="date" class="form-control" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="end_date">End Date</label>
                                <input type="date" class="form-control" name="end_date" required>
                            </div>
                            <button type="submit" class="btn btn-primary" name="add_objective">Add Objective</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addObjectiveModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Edit Objective Modal -->
                <div id="editObjectiveModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <input type="hidden" id="edit_objective_id" name="id">
                            <div class="form-group">
                                <label for="edit_obj_strategic_plan_id">Strategic Plan</label>
                                <select class="form-control" id="edit_obj_strategic_plan_id" name="strategic_plan_id" required>
                                    <?php foreach ($strategic_plans_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="edit_obj_name">Objective Name</label>
                                <input type="text" class="form-control" id="edit_obj_name" name="name" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_obj_start_date">Start Date</label>
                                <input type="date" class="form-control" id="edit_obj_start_date" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_obj_end_date">End Date</label>
                                <input type="date" class="form-control" id="edit_obj_end_date" name="end_date" required>
                            </div>
                            <button type="submit" class="btn btn-primary" name="update_objective">Update Objective</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('editObjectiveModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Add Strategy Modal -->
                <div id="addStrategyModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <div class="form-group">
                                <label for="strategic_plan_id">Strategic Plan</label>
                                <select class="form-control" name="strategic_plan_id" required>
                                    <?php foreach ($strategic_plans_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="objective_id">Objective (Optional)</label>
                                <select class="form-control" name="objective_id">
                                    <option value="">Select Objective</option>
                                    <?php foreach ($objectives_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="name">Strategy Name</label>
                                <input type="text" class="form-control" name="name" placeholder="Strategy Name" required>
                            </div>
                            <div class="form-group">
                                <label for="start_date">Start Date</label>
                                <input type="date" class="form-control" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="end_date">End Date</label>
                                <input type="date" class="form-control" name="end_date" required>
                            </div>
                            <button type="submit" class="btn btn-primary" name="add_strategy">Add Strategy</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addStrategyModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Edit Strategy Modal -->
                <div id="editStrategyModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <input type="hidden" id="edit_strategy_id" name="id">
                            <div class="form-group">
                                <label for="edit_strategy_strategic_plan_id">Strategic Plan</label>
                                <select class="form-control" id="edit_strategy_strategic_plan_id" name="strategic_plan_id" required>
                                    <?php foreach ($strategic_plans_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="edit_strategy_objective_id">Objective (Optional)</label>
                                <select class="form-control" id="edit_strategy_objective_id" name="objective_id">
                                    <option value="">Select Objective</option>
                                    <?php foreach ($objectives_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="edit_strategy_name">Strategy Name</label>
                                <input type="text" class="form-control" id="edit_strategy_name" name="name" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_strategy_start_date">Start Date</label>
                                <input type="date" class="form-control" id="edit_strategy_start_date" name="start_date" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_strategy_end_date">End Date</label>
                                <input type="date" class="form-control" id="edit_strategy_end_date" name="end_date" required>
                            </div>
                            <button type="submit" class="btn btn-primary" name="update_strategy">Update Strategy</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('editStrategyModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Add Activity Modal -->
                <div id="addActivityModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <div class="form-group">
                                <label for="strategy_id">Strategy</label>
                                <select class="form-control" name="strategy_id" required>
                                    <?php foreach ($strategies_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="activity">Activity</label>
                                <input type="text" class="form-control" name="activity" placeholder="Activity" required>
                            </div>
                            <div class="form-group">
                                <label for="kpi">KPI</label>
                                <input type="text" class="form-control" name="kpi" placeholder="KPI">
                            </div>
                            <div class="form-group">
                                <label for="target">Target</label>
                                <input type="text" class="form-control" name="target" placeholder="Target">
                            </div>
                            <div class="form-group">
                                <label for="Y1">Year 1</label>
                                <input type="text" class="form-control" name="Y1" placeholder="Year 1">
                            </div>
                            <div class="form-group">
                                <label for="Y2">Year 2</label>
                                <input type="text" class="form-control" name="Y2" placeholder="Year 2">
                            </div>
                            <div class="form-group">
                                <label for="Y3">Year 3</label>
                                <input type="text" class="form-control" name="Y3" placeholder="Year 3">
                            </div>
                            <div class="form-group">
                                <label for="Y4">Year 4</label>
                                <input type="text" class="form-control" name="Y4" placeholder="Year 4">
                            </div>
                            <div class="form-group">
                                <label for="Y5">Year 5</label>
                                <input type="text" class="form-control" name="Y5" placeholder="Year 5">
                            </div>
                            <div class="form-group">
                                <label for="comment">Comment</label>
                                <textarea class="form-control" name="comment" placeholder="Comment"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" name="add_activity">Add Activity</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('addActivityModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <!-- Edit Activity Modal -->
                <div id="editActivityModal" class="modal">
                    <div class="modal-content">
                        <form method="post" action="strategic_plan.php">
                            <input type="hidden" id="edit_activity_id" name="id">
                            <div class="form-group">
                                <label for="strategy_id">Strategy</label>
                                <select class="form-control" name="strategy_id" required>
                                    <?php foreach ($strategies_dropdown as $id => $name): ?>
                                    <option value="<?php echo $id; ?>"><?php echo htmlspecialchars($name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="edit_activity">Activity</label>
                                <input type="text" class="form-control" id="edit_activity" name="activity" required>
                            </div>
                            <div class="form-group">
                                <label for="edit_kpi">KPI</label>
                                <input type="text" class="form-control" id="edit_kpi" name="kpi">
                            </div>
                            <div class="form-group">
                                <label for="edit_target">Target</label>
                                <input type="text" class="form-control" id="edit_target" name="target">
                            </div>
                            <div class="form-group">
                                <label for="edit_y1">Year 1</label>
                                <input type="text" class="form-control" id="edit_y1" name="Y1">
                            </div>
                            <div class="form-group">
                                <label for="edit_y2">Year 2</label>
                                <input type="text" class="form-control" id="edit_y2" name="Y2">
                            </div>
                            <div class="form-group">
                                <label for="edit_y3">Year 3</label>
                                <input type="text" class="form-control" id="edit_y3" name="Y3">
                            </div>
                            <div class="form-group">
                                <label for="edit_y4">Year 4</label>
                                <input type="text" class="form-control" id="edit_y4" name="Y4">
                            </div>
                            <div class="form-group">
                                <label for="edit_y5">Year 5</label>
                                <input type="text" class="form-control" id="edit_y5" name="Y5">
                            </div>
                            <div class="form-group">
                                <label for="edit_comment">Comment</label>
                                <textarea class="form-control" id="edit_comment" name="comment"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary" name="update_activity">Update Activity</button>
                            <button type="button" class="btn btn-secondary" onclick="closeModal('editActivityModal')">Cancel</button>
                        </form>
                    </div>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script>
        // Ensure tab content visibility (since missing in global CSS)
        const style = document.createElement('style');
        style.textContent = `
            .tab-content { display: none; }
            .tab-content.active { display: block; }
        `;
        document.head.appendChild(style);

        // Tab switching
        document.querySelectorAll('.tab-link').forEach(tab => {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.tab-link').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                this.classList.add('active');
                document.getElementById(this.dataset.tab).classList.add('active');
            });
        });

        // Modal handling
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.style.display = 'block';
        }
        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.style.display = 'none';
        }
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }

        // Edit Activity - FIXED: Using data attributes instead of inline JavaScript
        function editActivity(id, activity, kpi, target, y1, y2, y3, y4, y5, comment) {
            const modal = document.getElementById('editActivityModal');
            if (!modal) {
                console.error('Edit Activity Modal not found');
                return;
            }
            
            // Safely set values with fallbacks
            document.getElementById('edit_activity_id').value = id || '';
            document.getElementById('edit_activity').value = activity || '';
            document.getElementById('edit_kpi').value = kpi || '';
            document.getElementById('edit_target').value = target || '';
            document.getElementById('edit_y1').value = y1 || '';
            document.getElementById('edit_y2').value = y2 || '';
            document.getElementById('edit_y3').value = y3 || '';
            document.getElementById('edit_y4').value = y4 || '';
            document.getElementById('edit_y5').value = y5 || '';
            document.getElementById('edit_comment').value = comment || '';
            
            openModal('editActivityModal');
        }

        // Edit Strategic Plan - FIXED: Using string parameters with proper escaping
        function editStrategicPlan(id, name, start_date, end_date, image) {
            const modal = document.getElementById('editStrategicPlanModal');
            if (!modal) {
                console.error('Edit Strategic Plan Modal not found');
                return;
            }
            
            document.getElementById('edit_strategic_plan_id').value = id || '';
            document.getElementById('edit_name').value = name || '';
            document.getElementById('edit_start_date').value = start_date || '';
            document.getElementById('edit_end_date').value = end_date || '';
            
            const preview = document.getElementById('edit_image_preview');
            if (preview) {
                if (image) {
                    preview.src = image;
                    preview.style.display = 'block';
                } else {
                    preview.style.display = 'none';
                }
            }
            
            openModal('editStrategicPlanModal');
        }

        // Edit Objective - FIXED: Using string parameters with proper escaping
        function editObjective(id, strategic_plan_id, name, start_date, end_date) {
            const modal = document.getElementById('editObjectiveModal');
            if (!modal) {
                console.error('Edit Objective Modal not found');
                return;
            }
            
            document.getElementById('edit_objective_id').value = id || '';
            document.getElementById('edit_obj_strategic_plan_id').value = strategic_plan_id || '';
            document.getElementById('edit_obj_name').value = name || '';
            document.getElementById('edit_obj_start_date').value = start_date || '';
            document.getElementById('edit_obj_end_date').value = end_date || '';
            
            openModal('editObjectiveModal');
        }

        // Edit Strategy - FIXED: Using string parameters with proper escaping
        function editStrategy(id, strategic_plan_id, objective_id, name, start_date, end_date) {
            const modal = document.getElementById('editStrategyModal');
            if (!modal) {
                console.error('Edit Strategy Modal not found');
                return;
            }
            
            document.getElementById('edit_strategy_id').value = id || '';
            document.getElementById('edit_strategy_strategic_plan_id').value = strategic_plan_id || '';
            document.getElementById('edit_strategy_objective_id').value = objective_id || '';
            document.getElementById('edit_strategy_name').value = name || '';
            document.getElementById('edit_strategy_start_date').value = start_date || '';
            document.getElementById('edit_strategy_end_date').value = end_date || '';
            
            openModal('editStrategyModal');
        }

        // Event delegation for edit activity buttons using data attributes
        document.addEventListener('click', function(e) {
            if (e.target.closest('.edit-activity-btn')) {
                const btn = e.target.closest('.edit-activity-btn');
                editActivity(
                    btn.dataset.id,
                    btn.dataset.activity,
                    btn.dataset.kpi,
                    btn.dataset.target,
                    btn.dataset.y1,
                    btn.dataset.y2,
                    btn.dataset.y3,
                    btn.dataset.y4,
                    btn.dataset.y5,
                    btn.dataset.comment
                );
            }
        });

        // Strategic Plan Image Update
        const planSelect = document.getElementById('strategic_plan_select');
        if (planSelect) {
            planSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const imagePath = selectedOption.dataset.image;
                const imageContainer = document.querySelector('.strategic-plan-image-container');
                if (imagePath) {
                    imageContainer.innerHTML = `<img id="strategic_plan_image" src="${imagePath}" alt="Strategic Plan">`;
                } else {
                    imageContainer.innerHTML = `
                        <div class="no-image-placeholder">
                            <i class="fas fa-image"></i>
                            <h3>No Strategic Plan Image Available</h3>
                            <p>Please select a strategic plan with an uploaded image</p>
                        </div>`;
                }
                const planId = this.value;
                const rows = document.querySelectorAll('#strategies-table tbody tr');
                rows.forEach(row => {
                    row.style.display = (!planId || row.dataset.planId == planId) ? '' : 'none';
                });
            });
            if (planSelect.value) {
                const event = new Event('change');
                planSelect.dispatchEvent(event);
            }
        }

        // Global error handler
        window.addEventListener('error', function(e) {
            console.error('JavaScript Error:', e.error);
            console.error('File:', e.filename);
            console.error('Line:', e.lineno);
            console.error('Column:', e.colno);
        });

        // Debug function to check if modals exist
        function checkModals() {
            const modals = [
                'editActivityModal',
                'editStrategicPlanModal', 
                'editObjectiveModal',
                'editStrategyModal'
            ];
            
            modals.forEach(modalId => {
                const modal = document.getElementById(modalId);
                console.log(`Modal ${modalId}:`, modal ? 'Found' : 'NOT FOUND');
            });
        }

        // Call this on page load to verify all modals exist
        document.addEventListener('DOMContentLoaded', function() {
            checkModals();
        });
    </script>
</body>
</html>