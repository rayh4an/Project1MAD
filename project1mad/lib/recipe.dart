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
    'Custom',
  ];

  final Map<String, List<Map<String, String>>> recipeBycategory = {
    'American (North + South)': [
      {
        'name': 'Burger',
        'instruction': 'Grill the patty, add toppings, serve on a bun.',
      },
      {
        'name': 'BBQ Ribs',
        'instruction': 'Slow-cook the ribs, brush with BBQ sauce.',
      },
    ],
    'European': [
      {
        'name': 'Pasta Carbonara',
        'instruction': 'Mix eggs, cheese, and pasta. Add pancetta.',
      },
      {
        'name': 'French Ratatouille',
        'instruction': 'Sauté vegetables, simmer in a tomato base.',
      },
    ],
    'Asian': [
      {
        'name': 'Sushi Rolls',
        'instruction': 'Roll rice, nori, and fillings. Slice and serve.',
      },
      {
        'name': 'Pad Thai',
        'instruction': 'Stir-fry noodles with sauce, tofu, and shrimp.',
      },
    ],
    'African': [
      {
        'name': 'Jollof Rice',
        'instruction': 'Cook rice with tomatoes, spices, and vegetables.',
      },
      {
        'name': 'Bobotie',
        'instruction': 'Bake spiced meat with an egg-based topping.',
      },
    ],
    'Custom': [],
  };

  final Color primaryColor = const Color.fromARGB(255, 229, 158, 158);
  final Color secondaryColor = const Color.fromARGB(255, 152, 11, 11);
  final Color thirdColor = const Color.fromARGB(255, 50, 50, 50);
  final Color backgroundColor = const Color.fromARGB(255, 250, 244, 236);
  final Color dividerColor = const Color.fromARGB(255, 0, 0, 0);

  void _showAddRecipeDialog() {
    final _recipeNameController = TextEditingController();
    final _instructionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Recipe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _recipeNameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
              ),
              TextField(
                controller: _instructionController,
                decoration: const InputDecoration(labelText: 'Instructions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _recipeNameController.text.trim();
                final instructions = _instructionController.text.trim();

                if (name.isNotEmpty && instructions.isNotEmpty) {
                  setState(() {
                    recipeBycategory['Custom']!.add({
                      'name': name,
                      'instruction': instructions,
                    });
                  });
                }

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: backgroundColor,
        child: ListView(
          children:
              categories.map((category) {
                return ExpansionTile(
                  title: Text(
                    category,
                    style: TextStyle(color: secondaryColor),
                  ),
                  children: [
                    ...recipeBycategory[category]!.map((recipe) {
                      return ExpansionTile(
                        title: Text(
                          recipe['name']!,
                          style: TextStyle(color: thirdColor),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              recipe['instruction']!,
                              style: TextStyle(color: dividerColor),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    if (category == 'Custom')
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add Recipe'),
                        onTap: _showAddRecipeDialog,
                      ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
