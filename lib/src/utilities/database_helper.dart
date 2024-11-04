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
      onCreate: (db, version) async {
        db.execute('''
        CREATE TABLE items(
          id INTEGER PRIMARY KEY,
          name TEXT,
          current_price TEXT
        )
        ''');

        db.execute('''
        CREATE TABLE item_prices(
          id INTEGER PRIMARY KEY,
          item_id INTEGER,
          price TEXT,
          date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
        )
        ''');

        db.execute('''
        CREATE TABLE shopping_sessions(
          id INTEGER PRIMARY KEY,
          place TEXT,
          date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

        db.execute('''
        CREATE TABLE shopping_items(
          session_id INTEGER,
          item_id INTEGER,
          price TEXT,
          quantity TEXT,
          checked INTEGER,
          FOREIGN KEY (session_id) REFERENCES shopping_sessions (id) ON DELETE CASCADE,
          FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE,
          PRIMARY KEY (session_id, item_id)
        )
        ''');
      },
    );
  }

  // Retrieve all items
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  // Retrieve item name, current price, and in_session flag for the given session_id
  Future<List<Map<String, dynamic>>> getItemsWithSessionStatus(
      int sessionId) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        items.id,
        items.name,
        items.current_price,
        CASE 
          WHEN shopping_items.session_id IS NOT NULL THEN 1 
          ELSE 0 
        END AS in_session
      FROM 
        items
      LEFT JOIN 
        shopping_items 
      ON 
        items.id = shopping_items.item_id AND shopping_items.session_id = ?
    ''', [sessionId]);
  }

  // Insert a new item with its initial price
  Future<void> insertItem(String name, String price) async {
    final db = await database;
    int itemId = await db.insert('items', {
      'name': name,
      'current_price': price
    }); // Update here to include current_price
    await db.insert('item_prices', {'item_id': itemId, 'price': price});
  }

  // Update item details (name) and add new price history if price changes
  Future<void> updateItemStorage(int id, String name, String price) async {
    final db = await database;

    // Update item details in the items table
    await db.update(
        'items',
        {
          'name': name,
          'current_price': price,
        },
        where: 'id = ?',
        whereArgs: [id]);

    // Insert new price entry if it has changed
    List<Map<String, dynamic>> currentPrice = await db.query('item_prices',
        where: 'item_id = ?', whereArgs: [id], orderBy: 'date DESC', limit: 1);

    // Check if the price has changed and add a new entry if so
    if (currentPrice.isEmpty || currentPrice[0]['price'] != price) {
      await db.insert('item_prices', {'item_id': id, 'price': price});
    }
  }

  // Update item details (name) and add new price history if price changes
  Future<void> updateItemSession(int sessionId, int itemId, String name,
      String price, String quantity) async {
    final db = await database;

    // Update item details in the items table
    await db.update(
        'items',
        {
          'name': name,
          'current_price': price,
        },
        where: 'id = ?',
        whereArgs: [itemId]);

    // Insert new price entry if it has changed
    List<Map<String, dynamic>> currentPrice = await db.query('item_prices',
        where: 'item_id = ?',
        whereArgs: [itemId],
        orderBy: 'date DESC',
        limit: 1);

    // Check if the price has changed and add a new entry if so
    if (currentPrice.isEmpty || currentPrice[0]['price'] != price) {
      await db.insert('item_prices', {'item_id': itemId, 'price': price});
    }

    // Update quantity in the shopping_items table
    await db.update(
      'shopping_items',
      {'quantity': quantity, 'price': price},
      where: 'session_id = ? AND item_id = ?',
      whereArgs: [sessionId, itemId],
    );
  }

  // Delete an item and its associated data
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

// Retrieve items in a specific shopping session, including the current price and checked status
  Future<List<Map<String, dynamic>>> getShoppingSessionItems(
      int sessionId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT items.id, items.name, shopping_items.quantity,
           items.current_price, shopping_items.checked  
    FROM shopping_items
    JOIN items ON shopping_items.item_id = items.id
    WHERE shopping_items.session_id = ?
  ''', [sessionId]);
  }

  // Insert a shopping session
  Future<int> insertShoppingSession() async {
    final db = await database;
    return await db.insert('shopping_sessions', {
      'place': "Rio",
    });
  }

  // Function to add an item to a shopping session with default checked as 0 (unchecked)
  Future<void> addItemToShoppingSession(
      int sessionId, int itemId, String quantity) async {
    final db = await database;
    await db.insert('shopping_items', {
      'session_id': sessionId,
      'item_id': itemId,
      'quantity': quantity,
      'checked': 0,
    });
  }

  // Function to remove an item from a shopping session
  Future<void> deleteItemFromShoppingSession(int sessionId, int itemId) async {
    final db = await database;
    await db.delete(
      'shopping_items',
      where: 'session_id = ? AND item_id = ?',
      whereArgs: [sessionId, itemId],
    );
  }

  // Function to update the checked status of an item in a shopping session
  Future<void> updateItemCheckStatus(
      int sessionId, int itemId, int checked) async {
    final db = await database;
    await db.update(
      'shopping_items',
      {'checked': checked},
      where: 'session_id = ? AND item_id = ?',
      whereArgs: [sessionId, itemId],
    );
  }

  // Delete a shopping session and its items
  Future<void> deleteShoppingSession(int sessionId) async {
    final db = await database;
    await db.delete(
      'shopping_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
    // No need for additional deletion logic for shopping_items
  }

  // Retrieve price history of an item
  Future<List<Map<String, dynamic>>> getPriceHistory(int itemId) async {
    final db = await database;
    return await db.query('item_prices',
        where: 'item_id = ?', whereArgs: [itemId], orderBy: 'date DESC');
  }

  // Function to check if an item is in a shopping session
  Future<bool> isItemInShoppingSession(int shoppingId, int itemId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'shopping_items',
      columns: ['item_id'],
      where: 'session_id = ? AND item_id = ?',
      whereArgs: [shoppingId, itemId],
    );

    return result.isNotEmpty;
  }

  Future<int> getLatestShoppingSessionId() async {
    final db = await database; // Your database instance
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT id FROM shopping_sessions ORDER BY id DESC LIMIT 1');

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return 0;
  }
}
