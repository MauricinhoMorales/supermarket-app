import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const UserPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("User"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleTheme,
              child: const Text("Toggle Theme"),
            ),
          ],
        ),
      ),
    );
  }
}
