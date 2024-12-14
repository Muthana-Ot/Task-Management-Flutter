import 'package:flutter/material.dart';
import 'package:taskmanagementproject/model/Task.dart';
import 'package:taskmanagementproject/widgets/TabItemWidget.dart';
import 'package:taskmanagementproject/widgets/TasksListWidget.dart';
import 'package:taskmanagementproject/widgets/TextBoxWidget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
final List<Task> tasks = [
    Task(
      title: 'Prepare Chess Club',
      description:
          'Get boards, organize the training room',
      status: 'Ongoing',
    ),
    Task(
      title: 'Social Media Posters',
      description:
          'Workshops Posters for 14/12/2024',
      status: 'Completed',
    ),
    Task(
      title: 'Submit Flutter Project 1',
      description:
          'Complete the code and publish on github',
      status: 'Ongoing',
    ),
    Task(
      title: 'Submit Web Project 1',
      description:
          'Complete the code and publish on github',
      status: 'Completed',
    ),
  ];

  void updateTaskStatus(Task task, String newStatus) {
    setState(() {
      final index = tasks.indexOf(task);
      if (index != -1) {
        tasks[index] = Task(
          title: task.title,
          description: task.description,
          status: newStatus,
        );
      }
    });
  }

 void _AddTask() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add New Task", style: TextStyle(color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBoxWidget(
                    labelText: "Enter Task Title", controller: titleController),
                SizedBox(
                  height: 10,
                ),
                TextBoxWidget(
                    labelText: "Enter Task Description",
                    controller: descriptionController),
              ],
            ),
            actions: [
              Center(
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        child: Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          final String title = titleController.text.trim();
                          final String description = descriptionController.text.trim();
                          if(title.isNotEmpty && description.isNotEmpty){
                            setState(() {                              
                          tasks.add(
                            Task(
                            title: title, 
                            description: description, 
                            status: 'Ongoing')
                             );                           
                            }
                           );
                          }
                            Navigator.of(context).pop();
                      },
                   child: Text("Add Task"))
                  ],
                ),
              )
            ],
          );
        }
      );
    }


  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'My Tasks',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: IconButton(
            onPressed: _AddTask,
            icon: const Icon(Icons.add),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey[100],
                      ),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black45,
                        tabs: [
                          TabItemWidget(title: 'In Progress'),
                          TabItemWidget(title: 'Completed'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: TasksListWidget(
                tasks: tasks.where((tasks) => tasks.status == 'Ongoing').toList(),
                statusChange: updateTaskStatus,
              ),
            ),
            Center(
              child: TasksListWidget(
                tasks: tasks.where((tasks) => tasks.status == 'Completed').toList(),
                statusChange: updateTaskStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
