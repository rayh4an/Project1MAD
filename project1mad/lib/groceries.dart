import 'package:flutter/material.dart';

class GroceriesPage extends StatelessWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groceries')),
      body: const Center(child: Text('Grocery List Page')),
    );
  }
}
