import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});
  
  @override
  Widget build(BuildContext context) {

    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(title: 'Page 1'),
            HomePage(title: 'Page 2'),
            HomePage(title: 'Page 3'),
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
