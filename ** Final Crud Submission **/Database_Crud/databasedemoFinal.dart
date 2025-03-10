import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  // Open the database (call this before using any CRUD operations)
  Future<void> open() async {
    // Get the path where the database will be stored
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'todos.db');

    // Open the database and create the table if it doesn't exist
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

  // CREATE: Add a new todo
  Future<void> addTodo(String title, String description) async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    await _database!.insert('todos', {
      'title': title,
      'description': description,
    });
  }

  // READ: Get all todos
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    if (_database == null) {
      await open(); // Open the database if it’s not already open
    }
    return await _database!.query('todos');
  }

  // UPDATE: Edit a todo by its ID
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

  // DELETE: Remove a todo by its ID
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

  // Close the database (optional, call when you're done using it)
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}