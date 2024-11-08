import 'package:app/src/utilities/context.dart';
import 'package:app/src/utilities/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:app/src/components/item_card.dart';

class ShoppingSession extends StatefulWidget {
  const ShoppingSession({super.key});

  @override
  ShoppingSessionState createState() => ShoppingSessionState();
}

class ShoppingSessionState extends State<ShoppingSession> {
  final TextEditingController _changeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load items from the database
  }

  Future<void> _loadItems() async {
    try {
      final sessionId = await _databaseHelper.getLatestShoppingSessionId();
      final items = await _databaseHelper.getShoppingSessionItems(sessionId);
      print('Loaded items from DB SESSION: $items');

      if (mounted) {
        setState(() {
          allItems =
              List<Map<String, dynamic>>.from(items); // Ensure mutability
          filteredItems = List<Map<String, dynamic>>.from(items)
            ..sort((a, b) {
              final checkedA = a['checked'] ?? 0; // Default to 0 if null
              final checkedB = b['checked'] ?? 0; // Default to 0 if null
              return checkedA.compareTo(checkedB);
            });
        });
      }
    } catch (error) {
      print('Error loading items: $error');
      // Optionally show an alert or snackbar to inform the user of the error
    }
  }

  void _filterItems(String query) {
    if (mounted) {
      setState(() {
        filteredItems = allItems
            .where((item) => item['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        filteredItems.sort((a, b) {
          final checkedA = a['checked'] ?? 0; // Default to 0 if null
          final checkedB = b['checked'] ?? 0; // Default to 0 if null
          return checkedA.compareTo(checkedB);
        });
      });
    }
  }

  Future<void> _updateItem(
      int index, String name, String quantity, String price) async {
    final id = filteredItems[index]['id'];
    final sessionId = await _databaseHelper.getLatestShoppingSessionId();

    await _databaseHelper.updateItemSession(
        sessionId, id, name, price, quantity);
    await _loadItems(); // Reload items to refresh UI
  }

  void _insertShoppingSession() async {
    final sessionId = await _databaseHelper.getLatestShoppingSessionId();
    await _databaseHelper.updateSessionDate(sessionId);
    await _databaseHelper.insertShoppingSession();
    await _loadItems();
  }

  void _removeFromCart(int itemId) async {
    final sessionId = await _databaseHelper.getLatestShoppingSessionId();
    await _databaseHelper.deleteItemFromShoppingSession(sessionId, itemId);
    await _loadItems();
  }

  void _changeCheck(int itemId, int checked) async {
    final sessionId = await _databaseHelper.getLatestShoppingSessionId();
    if (checked == 1) {
      await _databaseHelper.updateItemCheckStatus(sessionId, itemId, 0);
    } else {
      await _databaseHelper.updateItemCheckStatus(sessionId, itemId, 1);
    }
    await _loadItems();
  }

  double _calculateExpectedTotal() {
    double total = 0.0;
    for (final item in allItems) {
      final quantity = double.tryParse(item['quantity'] ?? '') ?? 0;
      final price = double.tryParse(item['current_price'] ?? '') ?? 0;
      total += quantity * price;
    }
    return total;
  }

  double _calculateTotal() {
    double total = 0.0;
    for (final item in allItems) {
      // Check if the item is checked
      if (item['checked'] == 1) {
        final quantity = double.tryParse(item['quantity'] ?? '') ?? 0;
        final price = double.tryParse(item['current_price'] ?? '') ?? 0;
        total += quantity * price;
      }
    }
    return total;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _changeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Items',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterItems, // Call filter function on text change
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  key: ValueKey(
                      filteredItems[index]['name']), // Unique key for each card
                  itemName: filteredItems[index]['name'],
                  quantity: filteredItems[index]['quantity'],
                  price: filteredItems[index]['current_price'],
                  state: ItemCardStatus.inSession,
                  checked: filteredItems[index]['checked'] == 1 ? true : false,
                  context: ItemCardContext.inSession,
                  onItemChanged: (name, quantity, price) {
                    _updateItem(index, name, quantity, price);
                  },
                  onDeleteItem: () {},
                  onChangeState: () {
                    _removeFromCart(filteredItems[index]['id']);
                  },
                  onCheckItem: () {
                    _changeCheck(filteredItems[index]['id'],
                        filteredItems[index]['checked']);
                  },
                ); // Display the ItemCard for each filtered item
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Expected: \$${_calculateExpectedTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _insertShoppingSession();
              },
              child: const Text('New Session'),
            ),
          )
        ],
      ),
    );
  }
}
