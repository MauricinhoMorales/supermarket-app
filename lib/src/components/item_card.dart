import 'package:app/src/utilities/context.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String itemName;
  final String quantity;
  final String price;
  final String state;
  final void Function(String, String, String) onItemChanged;
  final void Function() onDeleteItem;
  final void Function() onChangeState;
  final ItemCardContext context; // Add this parameter

  const ItemCard({
    super.key,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.state,
    required this.onItemChanged,
    required this.onDeleteItem, // Add this parameter
    required this.onChangeState,
    required this.context,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}
class _ItemCardState extends State<ItemCard> {
  bool _showAlternative = true;
  bool _checked = false;
  late String itemName;
  late String quantity;
  late String price;

  // Temporary variables for editing
  late String _tempItemName;
  late String _tempQuantity;
  late String _tempPrice;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    itemName = widget.itemName;
    quantity = widget.quantity;
    price = widget.price;
    
    // Initialize temporary variables with current values
    _tempItemName = itemName;
    _tempQuantity = quantity;
    _tempPrice = price;

    // Initialize controllers with current values
    _itemNameController.text = itemName;
    _quantityController.text = quantity;
    _priceController.text = price;
  }

  void _toggleWidget() {
    setState(() {
      _showAlternative = !_showAlternative;
      if (_showAlternative) {
        // If toggling back to view mode, update the display values
        itemName = _tempItemName;
        quantity = _tempQuantity;
        price = _tempPrice;
      } else {
        // If toggling to edit mode, initialize temp values with current display values
        _tempItemName = itemName;
        _tempQuantity = quantity;
        _tempPrice = price;
      }
    });
  }

    void _checkItem() {
    setState(() {
      _checked = !_checked;
    });
  }

  void _updateItem() {
    // Call the callback function with the updated values
    widget.onItemChanged(itemName, quantity, price);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showAlternative ? _cardShowValue() : _cardEditValue(),
    );
  }
Widget _cardEditValue() {
  return Card(
    key: ValueKey('edit-${itemName}'),
    margin: const EdgeInsets.all(8.0),
    elevation: 4.0,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              textAlign: TextAlign.center,
              onChanged: (value) {
                _tempItemName = value;
              },
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (value) {
                _tempPrice = value;
              },
            ),
          ),
          const Spacer(),
          if (widget.context == ItemCardContext.cart)
          Expanded(
            flex: 2,
            child: TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (value) {
                _tempQuantity = value;
              },
            ),
          ),
          if (widget.context == ItemCardContext.cart)
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              setState(() {
                itemName = _tempItemName;
                quantity = _tempQuantity;
                price = _tempPrice;
              });
              _toggleWidget();
              _updateItem(); // Notify parent about the change
            },
          ),
          if (widget.context == ItemCardContext.storage)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDeleteItem, // Trigger the delete callback
          ),
        ],
      ),
    ),
  );
}

Widget _cardShowValue() {
  return Card(
    key: ValueKey('show-${itemName}'),
    margin: const EdgeInsets.all(8.0),
    elevation: 4.0,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          if (widget.context == ItemCardContext.storage)
          IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              color: widget.state == 'cart' ? Colors.red : Colors.blue,
            ),
            onPressed: widget.onChangeState, // Trigger the delete callback
          ),
          if (widget.context == ItemCardContext.cart)
          IconButton(
            icon: Icon(
               _checked ? Icons.check_box : Icons.check_box_outline_blank,
              color: _checked ? Colors.green: Colors.red,
            ),
            onPressed: _checkItem, // Trigger the delete callback
          ),
          Expanded(
            flex: 3,
            child: Text(
              itemName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              '$price \$',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          if (widget.context == ItemCardContext.cart)
          Expanded(
            flex: 2,
            child: Text(
              'x $quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleWidget,
          ),
          if (widget.context == ItemCardContext.cart)
          IconButton(
            icon: Icon(
              Icons.file_upload_outlined,
              color: widget.state == 'cart' ? Colors.red : Colors.blue,
            ),
            onPressed: widget.onChangeState, // Trigger the delete callback
          ),
        ],
      ),
    ),
  );
}
}