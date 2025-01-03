<?php
header("Content-Type: application/json");
require_once('connection.php');

$id = $_POST['id'];
$title = $_POST['title'];
$description = $_POST['description'];


$sql = "UPDATE tasks SET title='$title',description='$description' WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo "Task updated successfully";
} else {
    echo "Error updating task: " . $conn->error;
}

$conn->close();
?>