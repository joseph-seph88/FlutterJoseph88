import 'package:check_app_ver02/CHECK_IN_OUT_APP/models/check_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDB('joseph_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS Joseph_Table');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Joseph_Table(
      id INTEGER PRIMARY KEY, 
      name TEXT,
      time TEXT,
      lateCount INTEGER
      )
    ''');
  }

  Future<void> initializeDatabase() async {
    List<String> namesList = ['Joseph', 'Mark', 'Eve', 'Any', 'Alice'];
    Random random = Random();

    for (String name in namesList) {
      int lateCount = random.nextInt(5);
      await insertName(NameModel(
          name: name, time: DateTime.now().toString(), lateCount: lateCount));
    }
  }

  Future<void> insertName(NameModel name) async {
    final db = await instance.database;
    await db.insert('Joseph_Table', name.dbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NameModel>> fetchAllNames() async {
    final db = await instance.database;
    final result = await db.query('Joseph_Table');
    //쿼리한 값 형태 : List<Map<String, dynamic>>
    return result.map((records) => NameModel.fromMap(records)).toList();
    //map으로 각요소 전달하면 NameModel타입으로 변경됨
  }
}
