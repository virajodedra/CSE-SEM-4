import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  
  Future<void> open() async {
    // Get the path where the database will be stored
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'todos.db');


    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<void> addTodo(String title, String description) async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    await _database!.insert('todos', {
      'title': title,
      'description': description,
    });
  }

  // READ
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    return await _database!.query('todos');
  }

  // UPDATE
  Future<void> updateTodo(int id, String title, String description) async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    await _database!.update(
      'todos',
      {'title': title, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<void> deleteTodo(int id) async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    await _database!.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close 
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
