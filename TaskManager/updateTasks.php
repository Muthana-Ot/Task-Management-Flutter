<?php
    require_once('connection.php');

$id = $_POST['id'];
$status = $_POST['status'];
$status_id=1;
if($status=="Completed")
$status_id=2;

$sql = "UPDATE tasks SET status_id = $status_id WHERE id='$id'";

if ($conn->query($sql) === TRUE) {
    echo "Task status updated successfully";
} else {
    echo "Error updating task status: " . $conn->error;
}

$conn->close();
?>