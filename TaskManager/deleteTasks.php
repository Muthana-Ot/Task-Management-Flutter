<?
header("Content-Type: application/json");

require_once 'connection.php';

$id = $_POST['id'];

$sql = "DELETE tasks WHERE id='$id'";

if ($conn->query($sql) === TRUE) {
    echo "Task deleted successfully";
} else {
    echo "Error deleting task: " . $conn->error;
}

$conn->close();