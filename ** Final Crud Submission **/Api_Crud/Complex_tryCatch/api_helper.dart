import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  // Replace with your actual API base URL
  final String baseUrl = 'https://67b41a5c392f4aa94fa95325.mockapi.io/todo/todo';

  // CREATE: Add a new todo
  Future<void> addTodo(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      print('Add Todo Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 201) {
        throw Exception('Failed to add todo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in addTodo: $e');
      rethrow;
    }
  }

  // READ: Get all todos
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('Get Todos Response Status: ${response.statusCode}');
      print('Get Todos Response Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((todo) => {
          'id': todo['id']?.toString() ?? '', // Handle null id
          'title': todo['title']?.toString() ?? '', // Handle null title
          'description': todo['description']?.toString() ?? '', // Handle null description
        }).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllTodos: $e');
      rethrow;
    }
  }

  // UPDATE: Edit a todo by its ID
  Future<void> updateTodo(String id, String title, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      print('Update Todo Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateTodo: $e');
      rethrow;
    }
  }

  // DELETE: Remove a todo by its ID
  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      print('Delete Todo Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteTodo: $e');
      rethrow;
    }
  }
}