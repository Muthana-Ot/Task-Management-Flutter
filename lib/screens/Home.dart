import 'package:flutter/material.dart';
import 'package:taskmanagementproject/model/Task.dart';
import 'package:taskmanagementproject/widgets/TabItemWidget.dart';
import 'package:taskmanagementproject/widgets/TasksListWidget.dart';
import 'package:taskmanagementproject/widgets/TextBoxWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController edittitleController = TextEditingController();
  final TextEditingController editdescriptionController = TextEditingController();
  final List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getTasks(); // Fetch tasks when the widget is initialized
  }

  void updateTaskStatus(Task task, String newStatus) async {
    print("Task ID: ${task.id}, New Status: $newStatus");
    String serverPath =
        "http://10.0.2.2:80/taskmanager/updateTasks.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(
        url,
        body: {"id": task.id.toString(), "status": newStatus},
      );
      await getTasks();
    } catch (e) {
      print("Error: $e");
    }
  }

  void editTask(Task task, String title, String description) async {
    print("Task ID: ${task.id}, Title: ${title}, Description: ${description}");
    String serverPath =
        "http://10.0.2.2:80/taskmanager/editTasks.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(
        url,
        body: {"id": task.id.toString(), "title": title, "description": description},
      );
      await getTasks();
    } catch (e) {
      print("Error: $e");
    }
  }

   deleteTask(Task task) async {
     print("Task ID: ${task.id}");
    String serverPath =
        "http://10.0.2.2:80/taskmanager/deleteTasks.php";
    Uri url = Uri.parse(serverPath);
    try {
      var response = await http.post(
        url,
        body: {"id": task.id.toString()},
      );
      await getTasks();
    } catch (e) {
      print("Error: $e");
    }
  }

    addTask() async {
    String server = "http://10.0.2.2:80/taskmanager/addTasks.php";
    Uri url = Uri.parse(server);

    try {
      var response = await http.post(url, body: {
        "title": titleController.text,
        "description": descriptionController.text,
        "status": "Ongoing",
      });

      if (response.statusCode == 200) {
        getTasks();
      } else {
        throw Exception("Failed to add task");
      }
    } catch (error) {
      print("Error adding task: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add task")),
      );
    }
  }

    getTasks() async {
    String serverPath = "http://10.0.2.2:80/taskmanager/getTasks.php";
    Uri url = Uri.parse(serverPath);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          tasks.clear();
          var retrievedData = convert.jsonDecode(response.body);
          for (var retrievedTask in retrievedData) {
            tasks.add(Task(
              id: int.parse(retrievedTask["id"]) ,
              title: retrievedTask["title"],
              description: retrievedTask["description"],
              status: retrievedTask["status"],
            ));
          }
        });
      } else {
        throw Exception("Failed to fetch tasks");
      }
    } catch (error) {
      print("Error fetching tasks: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching tasks: $error")),
      );
    }
  }

  void _showAddTaskModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Task", style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBoxWidget(
                  labelText: "Enter Task Title",
                  controller: titleController,
                ),
                SizedBox(height: 10),
                TextBoxWidget(
                  labelText: "Enter Task Description",
                  controller: descriptionController,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.of(context).pop();                 
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String title = titleController.text.trim();
                    final String description =
                        descriptionController.text.trim();

                    if (title.isNotEmpty && description.isNotEmpty) {
                      addTask();
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Add Task"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskModal(Task task, String title, String description) {
    edittitleController.text = title;
    editdescriptionController.text = description;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Your Task", style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBoxWidget(
                  labelText: "Edit Task Title",
                  controller: edittitleController,
                ),
                SizedBox(height: 10),
                TextBoxWidget(
                  labelText: "Edit Task Description",
                  controller: editdescriptionController,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    edittitleController.clear();
                    editdescriptionController.clear();
                    Navigator.of(context).pop();                 
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String editedTitle = edittitleController.text.trim();
                    final String editedDescription = editdescriptionController.text.trim();

                    if (editedTitle.isNotEmpty && editedDescription.isNotEmpty) {
                      editTask(task, editedTitle, editedDescription);
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Edit Task"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
            onPressed: _showAddTaskModal,
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
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
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
                tasks:
                    tasks.where((task) => task.status == 'Ongoing').toList(),
                statusChange: updateTaskStatus,
                deleteTask: deleteTask,
                editTask: _showEditTaskModal,
              ),
            ),
            Center(
              child: TasksListWidget(
                tasks:
                    tasks.where((task) => task.status == 'Completed').toList(),
                statusChange: updateTaskStatus,
                deleteTask: deleteTask,
                editTask: _showEditTaskModal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
