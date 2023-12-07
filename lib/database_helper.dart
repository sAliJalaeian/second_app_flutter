import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initialDatabase() async {
    final String path = join(await getDatabasesPath(), 'todos.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE todos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          isCompleted INTEGER
        )
        ''');
    });
  }

  Future<int> insertTodo(Todo todo) async {
    return await _database.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _database.query("todos");
    return List.generate(maps.length, (index) => Todo.fromMap(maps[index]));
  }

  Future<int> updateTodo(Todo todo) async {
    return await _database
        .update("todos", todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    return await _database.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
