import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/goal.dart';

class GoalRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_app2.db');
    print('Opening database at $path');
    return await openDatabase(
      path,
      version: 2, // Bump version to force upgrade
      onCreate: (db, version) async {
        print('onCreate called');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS goals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            targetAmount REAL,
            currentAmount REAL,
            name TEXT,
            deadline TEXT
          )
        ''');
        print('Goals table created');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('onUpgrade called');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS goals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            targetAmount REAL,
            currentAmount REAL,
            name TEXT,
            deadline TEXT
          )
        ''');
        print('Goals table created (upgrade)');
      },
    );
  }

  Future<List<Goal>> getGoals() async {
    final db = await database;
    try {
      final maps = await db.query('goals', orderBy: 'deadline ASC');
      return maps.map((e) => Goal.fromMap(e)).toList();
    } catch (e) {
      print('Error querying goals table: $e');
      rethrow;
    }
  }

  Future<int> insertGoal(Goal goal) async {
    final db = await database;
    return await db.insert('goals', goal.toMap());
  }

  Future<int> updateGoal(Goal goal) async {
    final db = await database;
    return await db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteGoal(int id) async {
    final db = await database;
    return await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }
}
