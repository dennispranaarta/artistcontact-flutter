import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelperOrder {
  static final DBHelperOrder _instance = DBHelperOrder._internal();
  static Database? _database;

  factory DBHelperOrder() {
    return _instance;
  }

  DBHelperOrder._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'orders.db');
    return await openDatabase(
      path,
      version: 2, // Ubah versi database
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE orders ADD COLUMN transfer_proof BLOB');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_date TEXT,
        show_date TEXT,
        artist_category TEXT,
        artist TEXT,
        transfer_proof BLOB
      )
    ''');
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    Database db = await database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    Database db = await database;
    return await db.query('orders');
  }

  Future<int> updateOrder(int id, Map<String, dynamic> order) async {
    Database db = await database;
    return await db.update('orders', order, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOrder(int id) async {
    Database db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
