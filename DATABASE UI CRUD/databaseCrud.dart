import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasedemo extends StatefulWidget {
  const Databasedemo({super.key});

  @override
  State<Databasedemo> createState() => _DatabasedemoState();
}

class _DatabasedemoState extends State<Databasedemo> {
  late Database _database;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mydatabase.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE sampleTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT)",
        );
      },
    );
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<Map<String, dynamic>> userData =
    await _database.query('sampleTable');
    setState(() {
      data = userData;
    });
  }

  Future<void> addData(String title, String desc) async {
    await _database.insert('sampleTable', {'title': title, 'desc': desc});
    title = '';
    desc = '';
    _fetchData();
  }

  Future<void> deleteData(int id) async {
    await _database.delete('sampleTable', where: "id = ?", whereArgs: [id]);
    _fetchData();
  }

  Future<void> updateData(int id, String title, String desc) async {
    await _database.update(
      'sampleTable',
      {'title': title, 'desc': desc},
      where: "id = ?",
      whereArgs: [id],
    );
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Demo')),
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
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: desc,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await addData(title.text, desc.text);
                        title.clear();
                        desc.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]['title']),
            subtitle: Text(data[index]['desc']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  onPressed: () {
                    // Show Edit Modal Bottom Sheet
                    title.text = data[index]['title'];
                    desc.text = data[index]['desc'];

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
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: desc,
                                decoration: InputDecoration(labelText: 'Description'),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  await updateData(
                                    data[index]['id'],
                                    title.text,
                                    desc.text,
                                  );
                                  title.clear();
                                  desc.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Edit'),
                ),
                MaterialButton(
                  onPressed: () {
                    // Show Delete Confirmation Dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                              'Do you really want to delete this record?'),
                          actions: [
                            MaterialButton(
                              onPressed: () async {
                                await deleteData(data[index]['id']);
                                Navigator.pop(context);
                              },
                              child: Text("Yes, Delete"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Delete'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
