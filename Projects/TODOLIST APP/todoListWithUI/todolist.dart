import 'package:flutter/material.dart';

import 'database.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Priority List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PriorityListView(),
    );
  }
}

class PriorityListView extends StatefulWidget {
  @override
  _PriorityListViewState createState() => _PriorityListViewState();
}

class _PriorityListViewState extends State<PriorityListView> {
  List<Map<String, dynamic>> items = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Fetch tasks from database
  void _loadTasks() async {
    List<Map<String, dynamic>> taskList = await dbHelper.queryAllRows();
    setState(() {
      items = taskList;
    });
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // Sorting function
  void _sortItems(String sortOrder) {
    setState(() {
      // Copy the items list to a mutable one before sorting
      List<Map<String, dynamic>> sortedItems = List.from(items);

      if (sortOrder == 'A->Z') {
        sortedItems.sort((a, b) => a['task'].toString().compareTo(b['task'].toString()));
      } else if (sortOrder == 'Z->A') {
        sortedItems.sort((a, b) => b['task'].toString().compareTo(a['task'].toString()));
      }

      // Update the state with the sorted list
      items = sortedItems;
    });
  }




  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    String selectedPriority = 'Low';  // Default value is Low

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Task Name'),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedPriority,
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedPriority = newValue!;
                      });
                    },
                    items: <String>['Low', 'Medium', 'High']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String taskName = taskController.text.trim();

                    if (taskName.isNotEmpty) {
                      Map<String, dynamic> newTask = {
                        'task': taskName,
                        'priority': selectedPriority,
                      };
                      dbHelper.insert(newTask);
                      _loadTasks(); // Refresh the task list after insertion
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    TextEditingController taskController = TextEditingController(text: items[index]['task']);
    String selectedPriority = items[index]['priority']; // Default value is current priority

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Task Name'),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedPriority,
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedPriority = newValue!;
                      });
                    },
                    items: <String>['Low', 'Medium', 'High']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String taskName = taskController.text.trim();

                    if (taskName.isNotEmpty) {
                      Map<String, dynamic> updatedTask = {
                        '_id': items[index]['_id'], // Use the same id to update
                        'task': taskName,
                        'priority': selectedPriority,
                      };

                      dbHelper.update(updatedTask); // Update task in the database
                      _loadTasks(); // Refresh the task list
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Update Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTask(int index) {
    int taskId = items[index]['_id'];

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without deleting
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform deletion
                dbHelper.delete(taskId).then((_) {
                  _loadTasks(); // Refresh the task list after deletion
                  Navigator.of(context).pop(); // Close the dialog
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Priority List View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _sortItems('A->Z'),
                  child: Text('Sort A->Z'),
                ),
                ElevatedButton(
                  onPressed: () => _sortItems('Z->A'),
                  child: Text('Sort Z->A'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String task = items[index]['task'];
                  String priority = items[index]['priority'];
                  Color priorityColor = getPriorityColor(priority);

                  return Card(
                    color: priorityColor.withOpacity(0.2),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        task,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Priority: $priority'),
                      leading: Icon(
                        Icons.flag,
                        color: priorityColor,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditTaskDialog(index), // Edit functionality
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(index), // Delete functionality
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
