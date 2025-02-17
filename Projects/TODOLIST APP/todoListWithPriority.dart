import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabasedemoTodoListPriority extends StatefulWidget {
  const DatabasedemoTodoListPriority({super.key});

  @override
  State<DatabasedemoTodoListPriority> createState() => _DatabasedemoTodoListPriorityState();
}

class _DatabasedemoTodoListPriorityState extends State<DatabasedemoTodoListPriority> {
  late Database _database;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  String? _priority;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mydatabase2.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE sampleTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, priority TEXT, completed INTEGER)",
        );
      },
    );
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<Map<String, dynamic>> userData = await _database.query(
      'sampleTable',
      orderBy: 'CASE WHEN priority = "High" THEN 1 WHEN priority = "Medium" THEN 2 ELSE 3 END',
    );
    setState(() {
      data = userData;
    });
  }

  Future<void> addData(String title, String desc, String priority) async {
    await _database.insert('sampleTable', {
      'title': title,
      'desc': desc,
      'priority': priority,
      'completed': 0, // New tasks are not completed
    });
    title = '';
    desc = '';
    _priority = null;
    _fetchData();
  }

  Future<void> deleteData(int id) async {
    await _database.delete('sampleTable', where: "id = ?", whereArgs: [id]);
    _fetchData();
  }

  Future<void> updateData(int id, String title, String desc, String priority, bool completed) async {
    await _database.update(
      'sampleTable',
      {
        'title': title,
        'desc': desc,
        'priority': priority,
        'completed': completed ? 1 : 0,
      },
      where: "id = ?",
      whereArgs: [id],
    );
    _fetchData();
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.greenAccent;
      case 'Low':
        return Colors.purple[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo List with Priority')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: title,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: desc,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    DropdownButton<String>(
                      value: _priority,
                      hint: const Text('Select Priority'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _priority = newValue;
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_priority != null) {
                          await addData(title.text, desc.text, _priority!);
                          title.clear();
                          desc.clear();
                          setState(() {
                            _priority = null;
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          String priority = data[index]['priority'];
          return Container(
            color: getPriorityColor(priority), // Set row color based on priority
            child: ListTile(
              title: Text(data[index]['title']),
              subtitle: Text('Priority: $priority'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: data[index]['completed'] == 1,
                    onChanged: (bool? value) {
                      updateData(
                        data[index]['id'],
                        data[index]['title'],
                        data[index]['desc'],
                        data[index]['priority'],
                        value ?? false,
                      );
                    },
                  ),
                  MaterialButton(
                    onPressed: () {
                      // Show Edit Modal Bottom Sheet
                      title.text = data[index]['title'];
                      desc.text = data[index]['desc'];
                      _priority = data[index]['priority'];

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: title,
                                  decoration: const InputDecoration(labelText: 'Title'),
                                ),
                                TextField(
                                  controller: desc,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                ),
                                DropdownButton<String>(
                                  value: _priority,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _priority = newValue;
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
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    await updateData(
                                      data[index]['id'],
                                      title.text,
                                      desc.text,
                                      _priority!,
                                      data[index]['completed'] == 1,
                                    );
                                    title.clear();
                                    desc.clear();
                                    setState(() {
                                      _priority = null;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Edit'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      // Show Delete Confirmation Dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Do you really want to delete this record?'),
                            actions: [
                              MaterialButton(
                                onPressed: () async {
                                  await deleteData(data[index]['id']);
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes, Delete"),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabasedemoTodoListPriority extends StatefulWidget {
//   const DatabasedemoTodoListPriority({super.key});
//
//   @override
//   State<DatabasedemoTodoListPriority> createState() => _DatabasedemoTodoListPriorityState();
// }
//
// class _DatabasedemoTodoListPriorityState extends State<DatabasedemoTodoListPriority> {
//   late Database _database;
//   TextEditingController title = TextEditingController();
//   TextEditingController desc = TextEditingController();
//   String? _priority;
//   List<Map<String, dynamic>> data = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//   }
//
//   Future<void> _initDatabase() async {
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'mydatabase2.db'),
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute(
//           "CREATE TABLE sampleTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, priority TEXT, completed INTEGER)",
//         );
//       },
//     );
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     final List<Map<String, dynamic>> userData = await _database.query(
//       'sampleTable',
//       orderBy: 'CASE WHEN priority = "High" THEN 1 WHEN priority = "Medium" THEN 2 ELSE 3 END',
//     );
//     setState(() {
//       data = userData;
//     });
//   }
//
//   Future<void> addData(String title, String desc, String priority) async {
//     await _database.insert('sampleTable', {
//       'title': title,
//       'desc': desc,
//       'priority': priority,
//       'completed': 0, // New tasks are not completed
//     });
//     title = '';
//     desc = '';
//     _priority = null;
//     _fetchData();
//   }
//
//   Future<void> deleteData(int id) async {
//     await _database.delete('sampleTable', where: "id = ?", whereArgs: [id]);
//     _fetchData();
//   }
//
//   Future<void> updateData(int id, String title, String desc, String priority, bool completed) async {
//     await _database.update(
//       'sampleTable',
//       {
//         'title': title,
//         'desc': desc,
//         'priority': priority,
//         'completed': completed ? 1 : 0,
//       },
//       where: "id = ?",
//       whereArgs: [id],
//     );
//     _fetchData();
//   }
//
//   Color getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.yellow;
//       case 'Low':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('ToDo List with Priority')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             builder: (BuildContext context) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: title,
//                       decoration: const InputDecoration(labelText: 'Title'),
//                     ),
//                     TextField(
//                       controller: desc,
//                       decoration: const InputDecoration(labelText: 'Description'),
//                     ),
//                     DropdownButton<String>(
//                       value: _priority,
//                       hint: const Text('Select Priority'),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _priority = newValue;
//                         });
//                       },
//                       items: <String>['Low', 'Medium', 'High']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_priority != null) {
//                           await addData(title.text, desc.text, _priority!);
//                           title.clear();
//                           desc.clear();
//                           setState(() {
//                             _priority = null;
//                           });
//                           Navigator.of(context).pop();
//                         }
//                       },
//                       child: const Text('Add'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           String priority = data[index]['priority'];
//           return ListTile(
//             title: Text(
//               data[index]['title'],
//               style: TextStyle(color: getPriorityColor(priority)),
//             ),
//             subtitle: Text('Priority: $priority'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Checkbox(
//                   value: data[index]['completed'] == 1,
//                   onChanged: (bool? value) {
//                     updateData(
//                       data[index]['id'],
//                       data[index]['title'],
//                       data[index]['desc'],
//                       data[index]['priority'],
//                       value ?? false,
//                     );
//                   },
//                 ),
//                 MaterialButton(
//                   onPressed: () {
//                     // Show Edit Modal Bottom Sheet
//                     title.text = data[index]['title'];
//                     desc.text = data[index]['desc'];
//                     _priority = data[index]['priority'];
//
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       builder: (BuildContext context) {
//                         return Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               TextField(
//                                 controller: title,
//                                 decoration: const InputDecoration(labelText: 'Title'),
//                               ),
//                               TextField(
//                                 controller: desc,
//                                 decoration: const InputDecoration(labelText: 'Description'),
//                               ),
//                               DropdownButton<String>(
//                                 value: _priority,
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     _priority = newValue;
//                                   });
//                                 },
//                                 items: <String>['Low', 'Medium', 'High']
//                                     .map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 }).toList(),
//                               ),
//                               const SizedBox(height: 20),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   await updateData(
//                                     data[index]['id'],
//                                     title.text,
//                                     desc.text,
//                                     _priority!,
//                                     data[index]['completed'] == 1,
//                                   );
//                                   title.clear();
//                                   desc.clear();
//                                   setState(() {
//                                     _priority = null;
//                                   });
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text('Update'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   child: const Text('Edit'),
//                 ),
//                 MaterialButton(
//                   onPressed: () {
//                     // Show Delete Confirmation Dialog
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: const Text('Are you sure?'),
//                           content: const Text('Do you really want to delete this record?'),
//                           actions: [
//                             MaterialButton(
//                               onPressed: () async {
//                                 await deleteData(data[index]['id']);
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Yes, Delete"),
//                             ),
//                             MaterialButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("Cancel"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: const Text('Delete'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';
// //
// // class DatabasedemoTodoListPriority extends StatefulWidget {
// //   const DatabasedemoTodoListPriority({super.key});
// //
// //   @override
// //   State<DatabasedemoTodoListPriority> createState() => _DatabasedemoTodoListPriorityState();
// // }
// //
// // class _DatabasedemoTodoListPriorityState extends State<DatabasedemoTodoListPriority> {
// //   late Database _database;
// //   TextEditingController title = TextEditingController();
// //   TextEditingController desc = TextEditingController();
// //   String? _priority;
// //   List<Map<String, dynamic>> data = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initDatabase();
// //   }
// //
// //   Future<void> _initDatabase() async {
// //     _database = await openDatabase(
// //       join(await getDatabasesPath(), 'mydatabase2.db'),
// //       version: 1,
// //       onCreate: (db, version) async {
// //         await db.execute(
// //           "CREATE TABLE sampleTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, priority TEXT, completed INTEGER)",
// //         );
// //       },
// //     );
// //     _fetchData();
// //   }
// //
// //   Future<void> _fetchData() async {
// //     final List<Map<String, dynamic>> userData =
// //     await _database.query('sampleTable');
// //     setState(() {
// //       data = userData;
// //     });
// //   }
// //
// //   Future<void> addData(String title, String desc, String priority) async {
// //     await _database.insert('sampleTable', {
// //       'title': title,
// //       'desc': desc,
// //       'priority': priority,
// //       'completed': 0, // New tasks are not completed
// //     });
// //     title = '';
// //     desc = '';
// //     _priority = null;
// //     _fetchData();
// //   }
// //
// //   Future<void> deleteData(int id) async {
// //     await _database.delete('sampleTable', where: "id = ?", whereArgs: [id]);
// //     _fetchData();
// //   }
// //
// //   Future<void> updateData(int id, String title, String desc, String priority, bool completed) async {
// //     await _database.update(
// //       'sampleTable',
// //       {
// //         'title': title,
// //         'desc': desc,
// //         'priority': priority,
// //         'completed': completed ? 1 : 0,
// //       },
// //       where: "id = ?",
// //       whereArgs: [id],
// //     );
// //     _fetchData();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('ToDo List with Priority')),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           showModalBottomSheet(
// //             context: context,
// //             isScrollControlled: true,
// //             builder: (BuildContext context) {
// //               return Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     TextField(
// //                       controller: title,
// //                       decoration: const InputDecoration(labelText: 'Title'),
// //                     ),
// //                     TextField(
// //                       controller: desc,
// //                       decoration: const InputDecoration(labelText: 'Description'),
// //                     ),
// //                     DropdownButton<String>(
// //                       value: _priority,
// //                       hint: const Text('Select Priority'),
// //                       onChanged: (String? newValue) {
// //                         setState(() {
// //                           _priority = newValue;
// //                         });
// //                       },
// //                       items: <String>['Low', 'Medium', 'High']
// //                           .map<DropdownMenuItem<String>>((String value) {
// //                         return DropdownMenuItem<String>(
// //                           value: value,
// //                           child: Text(value),
// //                         );
// //                       }).toList(),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     ElevatedButton(
// //                       onPressed: () async {
// //                         if (_priority != null) {
// //                           await addData(title.text, desc.text, _priority!);
// //                           title.clear();
// //                           desc.clear();
// //                           setState(() {
// //                             _priority = null;
// //                             title.clear();
// //                             desc.clear();
// //                           });
// //                           Navigator.of(context).pop();
// //                         }
// //                       },
// //                       child: const Text('Add'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //       body: ListView.builder(
// //         itemCount: data.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(data[index]['title']),
// //             subtitle: Text('Priority: ${data[index]['priority']}'),
// //             trailing: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Checkbox(
// //                   value: data[index]['completed'] == 1,
// //                   onChanged: (bool? value) {
// //                     updateData(
// //                       data[index]['id'],
// //                       data[index]['title'],
// //                       data[index]['desc'],
// //                       data[index]['priority'],
// //                       value ?? false,
// //                     );
// //                   },
// //                 ),
// //                 MaterialButton(
// //                   onPressed: () {
// //                     // Show Edit Modal Bottom Sheet
// //                     title.text = data[index]['title'];
// //                     desc.text = data[index]['desc'];
// //                     _priority = data[index]['priority'];
// //
// //                     showModalBottomSheet(
// //                       context: context,
// //                       isScrollControlled: true,
// //                       builder: (BuildContext context) {
// //                         return Padding(
// //                           padding: const EdgeInsets.all(16.0),
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               TextField(
// //                                 controller: title,
// //                                 decoration: const InputDecoration(labelText: 'Title'),
// //                               ),
// //                               TextField(
// //                                 controller: desc,
// //                                 decoration: const InputDecoration(labelText: 'Description'),
// //                               ),
// //                               DropdownButton<String>(
// //                                 value: _priority,
// //                                 onChanged: (String? newValue) {
// //                                   setState(() {
// //                                     _priority = newValue;
// //                                   });
// //                                 },
// //                                 items: <String>['Low', 'Medium', 'High']
// //                                     .map<DropdownMenuItem<String>>((String value) {
// //                                   return DropdownMenuItem<String>(
// //                                     value: value,
// //                                     child: Text(value),
// //                                   );
// //                                 }).toList(),
// //                               ),
// //                               const SizedBox(height: 20),
// //                               ElevatedButton(
// //                                 onPressed: () async {
// //                                   await updateData(
// //                                     data[index]['id'],
// //                                     title.text,
// //                                     desc.text,
// //                                     _priority!,
// //                                     data[index]['completed'] == 1,
// //                                   );
// //                                   title.clear();
// //                                   desc.clear();
// //                                   setState(() {
// //                                     _priority = null;
// //                                   });
// //                                   Navigator.of(context).pop();
// //                                 },
// //                                 child: const Text('Update'),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   },
// //                   child: const Text('Edit'),
// //                 ),
// //                 MaterialButton(
// //                   onPressed: () {
// //                     // Show Delete Confirmation Dialog
// //                     showDialog(
// //                       context: context,
// //                       builder: (context) {
// //                         return AlertDialog(
// //                           title: const Text('Are you sure?'),
// //                           content: const Text('Do you really want to delete this record?'),
// //                           actions: [
// //                             MaterialButton(
// //                               onPressed: () async {
// //                                 await deleteData(data[index]['id']);
// //                                 Navigator.pop(context);
// //                               },
// //                               child: const Text("Yes, Delete"),
// //                             ),
// //                             MaterialButton(
// //                               onPressed: () {
// //                                 Navigator.pop(context);
// //                               },
// //                               child: const Text("Cancel"),
// //                             ),
// //                           ],
// //                         );
// //                       },
// //                     );
// //                   },
// //                   child: const Text('Delete'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
