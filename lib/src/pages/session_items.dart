import 'package:app/src/components/item_card.dart';
import 'package:app/src/utilities/context.dart';
import 'package:app/src/utilities/database_helper.dart';
import 'package:flutter/material.dart';

class SessionItemsPage extends StatefulWidget {
  final int sessionId;

  const SessionItemsPage({super.key, required this.sessionId});

  @override
  SessionItemsPageState createState() => SessionItemsPageState();
}

class SessionItemsPageState extends State<SessionItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadItems(); // Load items from the database
  }

  Future<void> _loadItems() async {
    try {
      final items =
          await _databaseHelper.getShoppingSessionItems(widget.sessionId);
      print('Loaded items from DB Session Items: $items');

      setState(() {
        allItems = List<Map<String, dynamic>>.from(items); // Ensure mutability
        filteredItems = List<Map<String, dynamic>>.from(items);
      });
    } catch (error) {
      print('Error loading items: $error');
      // Optionally show an alert or snackbar to inform the user of the error
    }
  }

  void _filterItems(String query) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Items'),
      ),
      body: Column(children: [
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
                checked: true,
                context: ItemCardContext.inDisplay,
                onItemChanged: (name, quantity, price) {},
                onDeleteItem: () {},
                onChangeState: () {},
                onCheckItem: () {},
              );
            },
          ),
        ),
      ]),
    );
  }
}
