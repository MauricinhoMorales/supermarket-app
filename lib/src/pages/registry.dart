import 'package:flutter/material.dart';

class RegistryPage extends StatelessWidget {

  const RegistryPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registry"),
      ),
      body: const Center(
        child: Text("Registry"),
      ),
    );
  }
}
