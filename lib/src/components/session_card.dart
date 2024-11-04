import 'package:app/src/pages/session_items.dart';
import 'package:flutter/material.dart';

class ShoppingSessionCard extends StatelessWidget {
  final String place;
  final String date;
  final int sessionId;

  const ShoppingSessionCard({
    super.key,
    required this.place,
    required this.date,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the new page to show items
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionItemsPage(
              sessionId: sessionId,
            ),
          ),
        );
      },
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
                    place,
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
                    date,
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
