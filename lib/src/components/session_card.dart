import 'package:app/src/pages/session_items.dart';
import 'package:flutter/material.dart';

class ShoppingSessionCard extends StatefulWidget {
  final String place;
  final String date;
  final int sessionId;
  final void Function() onDeleteItem;

  const ShoppingSessionCard({
    super.key,
    required this.place,
    required this.date,
    required this.sessionId,
    required this.onDeleteItem,
  });

  @override
  _ShoppingSessionCardState createState() => _ShoppingSessionCardState();
}

class _ShoppingSessionCardState extends State<ShoppingSessionCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('edit-${widget.sessionId}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          widget.onDeleteItem();
        } else if (direction == DismissDirection.startToEnd) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionItemsPage(
                sessionId: widget.sessionId,
              ),
            ),
          );
        }
        return false;
      },
      background: Container(
        color: Colors.grey,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Text("CHECK"),
      ),
      secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text("REMOVE")),
      child: Container(
        constraints: const BoxConstraints(minHeight: 90),
        child: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.place,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.date,
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
        ),
      ),
    );
  }
}
