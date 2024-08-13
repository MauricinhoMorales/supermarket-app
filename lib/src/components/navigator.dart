import 'package:app/src/pages/recipes.dart';
import 'package:app/src/pages/shopping.dart';
import 'package:app/src/pages/storage.dart';
import 'package:flutter/material.dart';

import '../pages/registry.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});
  
  @override
  Widget build(BuildContext context) {

    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            ShoppingPage(),
            RegistryPage(),
            StoragePage(),
            RecipesPage(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.store_outlined)),
              Tab(icon: Icon(Icons.receipt_long_rounded)),
            ],
          ),
        ),
      ),
    );
  }
}
