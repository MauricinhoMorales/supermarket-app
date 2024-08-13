import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _showAlternative = false;
  String quantity = '0';
  String price = '0';

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _toggleWidget() {
    setState(() {
      _showAlternative = !_showAlternative;
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(), // Unique key for each item
      direction: DismissDirection.horizontal, // Set the swipe direction
      onDismissed: (direction) {
        // Handle the action based on the swipe direction
        if (direction == DismissDirection.endToStart) {
          // Action for swipe left
          _toggleWidget();
        } else if (direction == DismissDirection.startToEnd) {
          _toggleWidget(); // Change widget on swipe right
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.green, // Background color for swipe right
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
        ),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red, // Background color for swipe left
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
        ),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showAlternative ? _buildAlternativeWidget() : _buildOriginalWidget(),
      ),
    );
  }

  Widget _buildOriginalWidget() {
    return Card(
      key: const ValueKey('show'),
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 40.0),
            const SizedBox(width: 20), // Spacing between the icon and text
            const Expanded(
              child: Text(
                'Item',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              width: 70.0,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number, // Allows numeric input
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    quantity = value; // Update the quantity
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 70.0,
              child: TextField(
                controller: _priceController,
                keyboardType: TextInputType.number, // Allows numeric input
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    price = value; // Update the price
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeWidget() {
    return Card(
      key: const ValueKey('edit'),
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 40.0),
            const SizedBox(width: 20), // Spacing between the icon and text
            const Expanded(
              child: Text(
                'Item',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Text(
              quantity,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}