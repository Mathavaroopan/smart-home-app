// database/database_provider.dart

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/electricity_usage.dart';

class DatabaseProvider {
  static const String tableName = 'electricity_usage';

  static Database? _database;

  DatabaseProvider._(); // Private constructor to prevent instantiation

  static final DatabaseProvider db = DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'electricity_usage.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deviceId TEXT,
            deviceName TEXT,
            roomId INTEGER, // Changed to INTEGER
            unitsConsumed INTEGER
          )
        ''');
      },
    );
  }

  Future<List<ElectricityUsage>> getElectricityUsage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return ElectricityUsage.fromMap(maps[i]);
    });
  }

  Future<void> insertElectricityUsage(ElectricityUsage usage) async {
    final db = await database;
    await db.insert(tableName, usage.toMap());
  }

// You can implement other CRUD operations as required
}
