import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/electricity_usage.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, 'domus.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE ElectricityUsage(
            id INTEGER PRIMARY KEY,
            deviceId TEXT,
            deviceName TEXT,
            roomId INTEGER,
            unitsConsumed INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertElectricityUsage(ElectricityUsage electricityUsage) async {
    final db = await database;
    await db!.insert(
      'ElectricityUsage',
      electricityUsage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
