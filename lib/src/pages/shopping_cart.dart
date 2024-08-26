import 'package:app/src/utilities/context.dart';
import 'package:app/src/utilities/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:app/src/components/item_card.dart'; // Adjust the import path as necessary

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load items from the database
  }

  Future<void> _loadItems() async {
    final items = await _databaseHelper.getCartItems();
    print('Loaded items from DB CART: $items');
    setState(() {
      allItems = items;
      filteredItems = items;
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) => item['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _updateItem(int index, String name, String quantity, String price) async {
    final id = filteredItems[index]['id'];
    final updatedItem = {'name': name, 'quantity': quantity, 'price': price};

    await _databaseHelper.updateItem(id, updatedItem);
    await _loadItems(); // Reload items to refresh UI
  }

  void _removeFromCart(int id) async {
    await _databaseHelper.removeFromCart(id); // Delete from database
    await _loadItems();
  }


  double _calculateTotal() {
    double total = 0.0;
    for (final item in allItems) {
      final quantity = double.tryParse(item['quantity'] ?? '') ?? 0;
      final price = double.tryParse(item['price'] ?? '') ?? 0;
      total += quantity * price;
    }
    return total;
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                  key: ValueKey(filteredItems[index]['name']), // Unique key for each card
                  itemName: filteredItems[index]['name'],
                  quantity: filteredItems[index]['quantity'],
                  price: filteredItems[index]['price'],
                  state: filteredItems[index]['state'], 
                  onItemChanged: (name, quantity, price) {
                    _updateItem(index, name, quantity, price);
                  },
                    onDeleteItem: () {
                  }, 
                  context: ItemCardContext.cart, 
                  onChangeState: () {  
                    _removeFromCart(filteredItems[index]['id']);
                  },
                ); // Display the ItemCard for each filtered item
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Value: \$${_calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
