<?php
header("Content-Type: application/json");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

require_once 'connection.php';

$data = json_decode(file_get_contents('php://input'), true);

$title = $data['title'];
$description = $data['description'];
$status = $data['status'];
$status_Id = 1;
if ($status == "Completed") {
    $status_Id = 2;
}

if ($title && $description && $status) {
    // Use placeholders for the values to prevent SQL injection
    $stmt = $conn->prepare("INSERT INTO tasks (title, description, status) VALUES (?, ?, ?)");

    // Bind the values to the placeholders
    $stmt->bind_param("ssi", $title, $description, $status_Id);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Task added successfully"]);
    } else {
        echo json_encode(["message" => "Failed to add task"]);
    }

    $stmt->close();
} else {
    echo json_encode(["message" => "Invalid input"]);
}

$conn->close();
?>
