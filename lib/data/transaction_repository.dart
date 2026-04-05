import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as app_tx;

class TransactionRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            type TEXT,
            category TEXT,
            date TEXT,
            note TEXT
          )
        ''');
      },
    );
  }

  Future<List<app_tx.Transaction>> getTransactions() async {
    final db = await database;
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map((e) => app_tx.Transaction.fromMap(e)).toList();
  }

  Future<int> insertTransaction(app_tx.Transaction tx) async {
    final db = await database;
    return await db.insert('transactions', tx.toMap());
  }

  Future<int> updateTransaction(app_tx.Transaction tx) async {
    final db = await database;
    return await db.update('transactions', tx.toMap(), where: 'id = ?', whereArgs: [tx.id]);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<app_tx.Transaction>> filterTransactions({String? type, String? category}) async {
    final db = await database;
    String where = '';
    List<String> whereArgs = [];
    if (type != null) {
      where += 'type = ?';
      whereArgs.add(type);
    }
    if (category != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'category = ?';
      whereArgs.add(category);
    }
    final maps = await db.query('transactions', where: where.isEmpty ? null : where, whereArgs: whereArgs.isEmpty ? null : whereArgs, orderBy: 'date DESC');
    return maps.map((e) => app_tx.Transaction.fromMap(e)).toList();
  }
}
