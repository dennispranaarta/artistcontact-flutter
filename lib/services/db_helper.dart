import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY, username TEXT, nama_lengkap TEXT, nohp TEXT, address TEXT, image_url TEXT, local_image_path TEXT)",
        );
      },
    );
  }

  Future<void> insertUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'user',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserData(int idUser) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [idUser],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.update(
      'user',
      userData,
      where: 'id = ?',
      whereArgs: [userData['id']],
    );
  }
}
