import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database!;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Todo.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("""
          CREATE TABLE Todos(
          userId INTEGER NOT NULL,
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          completed INTEGER NOT NULL
          )
          """,);
        });
  }

  // Insert employee on database
  createTodo(TodoModel newTodo) async {
    final db = await database;
    final res = await db.insert('Todo', newTodo.toJson());
    return res;
  }

  // Delete all employees
  Future<int> deleteAllTodos() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Todo');

    return res;
  }

  Future<List<TodoModel>> getAllTodos() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Todo");

    List<TodoModel> list =
    res.isNotEmpty ? res.map((c) => TodoModel.fromJson(c)).toList() : [];

    return list;
  }
}