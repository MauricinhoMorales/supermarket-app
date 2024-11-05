import 'package:app/src/components/session_card.dart';
import 'package:flutter/material.dart';
import 'package:app/src/utilities/database_helper.dart';

class RegistryPage extends StatefulWidget {
  const RegistryPage({super.key});

  @override
  RegistryState createState() => RegistryState();
}

class RegistryState extends State<RegistryPage> {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _databaseHelper.getShoppingSessions();
    print('Loaded session from DB Registry: $items');

    if (mounted) {
      setState(() {
        allItems = List<Map<String, dynamic>>.from(items);
        filteredItems = List<Map<String, dynamic>>.from(items);
      });
    }
  }

  void _deleteItem(int sessionId) async {
    bool confirmed = await _showDeleteConfirmationDialog();

    if (confirmed) {
      await _databaseHelper.deleteShoppingSession(sessionId);
      await _loadItems();
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete?'),
          content: const Text('Are you sure you want to delete this session?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registry"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ShoppingSessionCard(
                  place: filteredItems[index]['place'],
                  date: filteredItems[index]['date'],
                  sessionId: filteredItems[index]['id'],
                  onDeleteItem: () {
                    _deleteItem(filteredItems[index]['id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
