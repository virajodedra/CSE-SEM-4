import 'package:flutter/cupertino.dart';
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
  List<Map<String, dynamic>> data = List.empty(growable: true);

  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database =
        await openDatabase(join(await getDatabasesPath(), 'mydatabase.db'),
            onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE sampleTable( id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT ");
    }, version: 1);
  }

  Future<void> _ferchData() async {
    List<Map<String, dynamic>> userData = await _database.query('sampleTable');
    setState(() {
      data = userData;
    });
    print(data);
  }

  Future<void> addData(String title, String desc) async {
    await _database.insert('sampleTable', {'title': title, 'desc': desc});

    _ferchData();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     floatingActionButton: MaterialButton(onPressed: (){}, child: Text('ADD !'),),
  //     body: Column(
  //       children: [
  //
  //       ],
  //     ),
  //
  //   );
  // }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        //   child: Text('Cancel'),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            addData(title.text, desc.text);
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
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
          );
        },
      ),
    );
  }
}
