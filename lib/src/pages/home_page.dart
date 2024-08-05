import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    final TextStyle? textStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }
}