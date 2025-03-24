import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final List<String> categories = [
    'American (North + South)',
    'European',
    'Asian',
    'African',
    'Custom'
  ];

  final Map<String, bool> expanded = {
    'American (North + South)': false,
    'European': false,
    'Asian': false,
    'African': false,
    'Custom': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: ListView(
        children: categories.map((category) {
          return ExpansionTile(
            title: Text(category),
            initiallyExpanded: expanded[category] ?? false,
            onExpansionChanged: (value) {
              setState(() {
                expanded[category] = value;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No recipes added yet for $category.'),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
