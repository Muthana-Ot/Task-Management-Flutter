<?php
header("Content-Type: application/json");
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
  require_once 'connection.php';
  
  $sql = "SELECT tasks.id, tasks.title, tasks.description, task_status.status
  FROM tasks
  INNER JOIN task_status ON tasks.status_id = task_status.id";

if ($result = mysqli_query($conn,$sql))
  {
   $tasks = array();
   while($row =mysqli_fetch_assoc($result))
       $tasks[] = $row;

  echo json_encode($tasks);
  mysqli_close($conn);
}

?> 	