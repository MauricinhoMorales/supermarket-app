import 'package:app/src/pages/shopping.dart';
import 'package:app/src/pages/user.dart';
import 'package:flutter/material.dart';

import '../pages/registry.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});
  
  @override
  Widget build(BuildContext context) {

    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            ShoppingPage(),
            RegistryPage(),
            UserPage(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.settings)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
      ),
    );
  }
}
