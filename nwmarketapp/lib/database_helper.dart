import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final String tableName = 'string_table';
  static final String columnId = 'id';
  static final String columnString = 'string';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'string_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnString TEXT)',
        );
      },
    );
  }

  Future<void> insertString(String newString) async {
    final db = await database;
    await db.insert(
      tableName,
      {columnString: newString},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getAllStrings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return maps[i][columnString];
    });
  }

  Future<void> deleteString(String str) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnString = ?',
      whereArgs: [str],
    );
  }
}
