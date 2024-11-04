import 'package:flutter/material.dart';

class ShoppingSessionCard extends StatelessWidget {
  final String place;
  final DateTime date;

  const ShoppingSessionCard({
    Key? key,
    required this.place,
    required this.date,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    // Format date to a more readable string
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
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
                flex: 2,
                child: Text(
                  _formatDate(date),
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
    );
  }
}
