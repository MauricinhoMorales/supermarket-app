import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return ThemeData(
      primarySwatch: Colors.green,
      hintColor: Colors.orange,
      appBarTheme: const AppBarTheme(
        centerTitle: true, // Centers the title horizontally
        titleTextStyle: TextStyle(
          fontSize: 30, // Customize the font size
          color: Colors.blueAccent, // Customize the color
          fontWeight: FontWeight.bold, // Customize the font weight
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        height: screenHeight * 0.08, // 8% of screen height
        color: Colors.blue[50],
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black54,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return ThemeData(
      primarySwatch: Colors.grey,
      hintColor: Colors.red,
      appBarTheme: const AppBarTheme(
        centerTitle: true, // Centers the title horizontally
        titleTextStyle: TextStyle(
          fontSize: 30, // Customize the font size
          color: Colors.redAccent, // Customize the color
          fontWeight: FontWeight.bold, // Customize the font weight
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        height: screenHeight * 0.08, // 8% of screen height
        color: Colors.grey[800],
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.red,
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}