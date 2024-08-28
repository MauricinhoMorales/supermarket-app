import 'package:app/src/utilities/context.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String itemName;
  final String quantity;
  final String price;
  final String state;
  final bool checked;
  final void Function(String, String, String) onItemChanged;
  final void Function() onDeleteItem;
  final void Function() onChangeState;
  final void Function() onCheckItem;
  final ItemCardContext context;

  const ItemCard({
    super.key,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.state,
    required this.checked,
    required this.onItemChanged,
    required this.onDeleteItem,
    required this.onChangeState,
    required this.onCheckItem,
    required this.context,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _showAlternative = true;
  late String itemName;
  late String quantity;
  late String price;
  late bool checked;

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
    checked = widget.checked;

    _tempItemName = itemName;
    _tempQuantity = quantity;
    _tempPrice = price;

    _itemNameController.text = itemName;
    _quantityController.text = quantity;
    _priceController.text = price;
  }

  void _toggleWidget() {
    setState(() {
      _showAlternative = !_showAlternative;
      if (_showAlternative) {
        itemName = _tempItemName;
        quantity = _tempQuantity;
        price = _tempPrice;
      } else {
        _tempItemName = itemName;
        _tempQuantity = quantity;
        _tempPrice = price;
      }
    });
  }

  void _checkItem() {
    setState(() {
      checked = !checked;
    });
    widget.onCheckItem();
  }

  void _updateItem() {
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
    return Dismissible(
      key: ValueKey('edit-${itemName}'),
      direction: DismissDirection.horizontal, // Enable swipe in both directions
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
        } else if (direction == DismissDirection.startToEnd) {
          setState(() {
            itemName = _tempItemName;
            quantity = _tempQuantity;
            price = _tempPrice;
          });
          _toggleWidget();
          _updateItem();
        }
        return false;
      },
      background: Container(
        color: Colors.grey, // Swipe right to left action background
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Text("EDIT"),
      ),
      secondaryBackground: Container(
        color: widget.state == 'cart' ? Colors.red : Colors.green, // Swipe left to right action background
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: widget.state == 'cart' ? const Text("REMOVE"): const Text("ADD"),
      ),
      child: _buildCardContent(
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
            if (widget.context == ItemCardContext.cart) const Spacer(),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                setState(() {
                  itemName = _tempItemName;
                  quantity = _tempQuantity;
                  price = _tempPrice;
                });
                _toggleWidget();
                _updateItem();
              },
            ),
            if (widget.context == ItemCardContext.storage)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onDeleteItem,
              ),
          ],
        ),
      ),
    );
  }

  Widget _cardShowValue() {
    return Dismissible(
      key: ValueKey('edit-${itemName}'),
      direction: DismissDirection.horizontal, // Enable swipe in both directions
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swiped left to right
          widget.onChangeState(); // Handle delete action
        } else if (direction == DismissDirection.startToEnd) {
          // Swiped right to left
          _toggleWidget(); // Handle state change action
        }
        return false;
      },
      background: Container(
        color: Colors.grey, // Swipe right to left action background
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Text("EDIT"),
      ),
      secondaryBackground: Container(
        color: widget.state == 'cart' ? Colors.red : Colors.green, // Swipe left to right action background
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: widget.state == 'cart' ? const Text("REMOVE"): const Text("ADD"),
      ),
      child: _buildCardContent(
        child: Row(
          children: [
            if (widget.context == ItemCardContext.storage)
              Icon(
                Icons.file_download_outlined,
                color: widget.state == 'cart' ? Colors.red : Colors.blue,
              ),
            if (widget.context == ItemCardContext.cart)
              IconButton(
                icon: Icon(
                  checked ? Icons.check_box : Icons.check_box_outline_blank,
                  color: checked ? Colors.green : Colors.red,
                ),
                onPressed: _checkItem,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent({required Widget child}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 90), // Ensuring a minimum height
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
      ),
    );
  }
}