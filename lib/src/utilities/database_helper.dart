import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopping_storage.db');
    return await openDatabase(
      path,
      version: 1, 
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, quantity TEXT, price TEXT, state TEXT, checked INTEGER)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('items', where: 'state = ?', whereArgs: ['cart']);
  }

  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('items', item);
  }

  Future<void> updateItem(int id, Map<String, dynamic> item) async {
    final db = await database;
    await db.update('items', item, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addToCart(int id) async {
    final db = await database;
    await db.update('items', {'state': 'cart'}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeFromCart(int id) async {
    final db = await database;
    await db.update('items', {'state': 'storage'}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> checkItem(int id) async {
    final db = await database;
    await db.update('items', {'checked': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> uncheckItem(int id) async {
    final db = await database;
    await db.update('items', {'checked': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
