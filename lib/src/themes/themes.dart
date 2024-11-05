import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return ThemeData(
      primarySwatch: Colors.green,
      hintColor: Colors.orange,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        height: screenHeight * 0.08,
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey, // Background color
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Removes rounded corners
          ),
          elevation: 5,
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
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30,
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        height: screenHeight * 0.08,
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Removes rounded corners
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
