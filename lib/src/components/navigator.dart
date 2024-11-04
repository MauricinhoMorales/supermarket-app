import 'package:app/src/pages/recipes.dart';
import 'package:app/src/pages/shopping.dart';
import 'package:app/src/pages/storage.dart';
import 'package:app/src/pages/user.dart';
import 'package:flutter/material.dart';

import '../pages/registry.dart';

class Navigation extends StatelessWidget {
  final VoidCallback toggleTheme;

  const Navigation({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Update length to 5 since there are 5 tabs
      child: Scaffold(
        body: TabBarView(
          children: [
            const ShoppingPage(),
            const RegistryPage(),
            const StoragePage(),
            const RecipesPage(),
            UserPage(toggleTheme: toggleTheme), // Pass toggleTheme here
          ],
        ),
        bottomNavigationBar: const BottomAppBar(
          padding: EdgeInsets.zero,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.store_outlined)),
              Tab(icon: Icon(Icons.receipt_long_rounded)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
      ),
    );
  }
}
