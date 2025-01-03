import 'package:flutter/material.dart';
import 'package:taskmanagementproject/model/Task.dart';

class TasksListWidget extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task, String) statusChange;
  final Function(Task) deleteTask;
  const TasksListWidget({super.key, required this.tasks, required this.statusChange, required this.deleteTask});

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.tasks.length,
      itemBuilder: (context, index){
        final task = widget.tasks[index];
         return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: task.status=="Ongoing"
            ? Colors.blue.shade300
            : Colors.green.shade300
          ),
          margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: ListTile(
            title: Text(task.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(task.description),
           trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      onPressed: () {
        final newStatus =
            task.status == 'Ongoing' ? 'Completed' : 'Ongoing';
        widget.statusChange(task, newStatus);
      },
      icon: Icon(
        Icons.playlist_add_check_circle_sharp,
        color: task.status == 'Ongoing' ? Colors.grey : Colors.green.shade500,
      ),
    ),
    IconButton(
      onPressed: () {
        widget.deleteTask(task);
      },
      icon: Icon(
        Icons.delete_forever, // Replace with the desired icon
        color: const Color.fromARGB(255, 181, 117, 113), // Choose the color you want for the second button
      ),
    ),
  ],
),

          ),

         );

    }
   );
  }
}