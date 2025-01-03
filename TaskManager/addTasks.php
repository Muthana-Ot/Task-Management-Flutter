<?php
header("Content-Type: application/json");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

require_once('connection.php');

$title = $_POST['title'];
$description = $_POST['description'];
$status = $_POST['status'];
$status_id=1;

if ($title && $description && $status) {
    $sql = "INSERT INTO tasks (title, description, status_id) VALUES ('$title', '$description', 1)";
    $result = mysqli_query($conn, $sql);
    if ($result) {
        echo "Data Inserted Successfully";
    }
    exit();
}

$conn->close();