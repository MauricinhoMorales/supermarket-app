import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    hintColor: Colors.orange,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 40, 
        color: Colors.blueAccent
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
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

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    hintColor: Colors.red,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 40, 
        color: Colors.redAccent
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
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
