import 'package:flutter/material.dart';
import 'package:app/src/components/item_card.dart'; // Adjust the import path as necessary

class ShoppingStorage extends StatefulWidget {
  const ShoppingStorage({super.key});

  @override
  _ShoppingStorageState createState() => _ShoppingStorageState();
}

class _ShoppingStorageState extends State<ShoppingStorage> {
  List<Map<String, String>> allItems = [
    {'name': 'Apples', 'quantity': '0', 'price': '0'},
    {'name': 'Bananas', 'quantity': '0', 'price': '0'},
    {'name': 'Cherries', 'quantity': '0', 'price': '0'},
    {'name': 'Dates', 'quantity': '0', 'price': '0'},
    {'name': 'Elderberries', 'quantity': '0', 'price': '0'},
    {'name': 'Apples', 'quantity': '0', 'price': '0'},
    {'name': 'Bananas', 'quantity': '0', 'price': '0'},
    {'name': 'Cherries', 'quantity': '0', 'price': '0'},
    {'name': 'Dates', 'quantity': '0', 'price': '0'},
    {'name': 'Elderberries', 'quantity': '0', 'price': '0'},
  ]; // Full list of items
  List<Map<String, String>> filteredItems = []; // Filtered list based on search input

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = allItems; // Initially, all items are displayed
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) => item['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _updateItem(int index, String name, String quantity, String price) {
    setState(() {
      allItems[index] = {'name': name, 'quantity': quantity, 'price': price}; // Update item in the source list
      filteredItems = allItems // Update filtered list to reflect changes
          .where((item) => item['name']!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
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
                  itemName: filteredItems[index]['name']!,
                  quantity: filteredItems[index]['quantity']!,
                  price: filteredItems[index]['price']!,
                  onItemChanged: (name, quantity, price) {
                    _updateItem(index, name, quantity, price);
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

class ItemCardData {
  final String itemName;
  final String quantity;
  final String price;

  ItemCardData({
    required this.itemName,
    required this.quantity,
    required this.price,
  });
}
