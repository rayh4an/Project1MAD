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

  final Map<String, List<Map<String, dynamic>>> recipeByCategory = {
    'American (North + South)': [
      {
        'name': 'Burger',
        'instruction': 'Preheat your grill to medium-high. Toast the buns lightly on the grill for 1–2 minutes. Grill the beef patty for about 4–5 minutes on each side until fully cooked. Add a slice of cheese on top and let it melt. Place the patty on the bun, then add lettuce, tomato, pickles, ketchup, and mustard as desired. Cover with the top bun.',
        'prepTime': '20 mins',
        'ingredients': 'Buns, Beef Patty, Cheese, Lettuce, Tomato, Pickles, Ketchup, Mustard',
      },
      {
        'name': 'BBQ Ribs',
        'instruction': 'Preheat oven to 300°F. Season ribs with salt, pepper, garlic powder, and onion powder. Wrap the ribs in foil and bake for 2 hours. Unwrap and brush generously with BBQ sauce. Grill for 10 more minutes to caramelize the sauce. Slice the ribs.',
        'prepTime': '2 hrs 30 mins',
        'ingredients': 'Beef Ribs, BBQ sauce, Salt, Pepper, Garlic powder, Onion powder',
      },
    ],
    'European': [
      {
        'name': 'Pasta Carbonara',
        'instruction': 'Bring a large pot of salted water to a boil and cook spaghetti until al dente. In a pan, cook diced bacon until crispy. In a bowl, whisk together eggs and grated parmesan. Drain the pasta and quickly mix it with the hot bacon and the egg-cheese mixture while stirring continuously to avoid scrambling the eggs. Season with black pepper.',
        'prepTime': '30 mins',
        'ingredients': 'Spaghetti, Eggs, Parmesan, Bacon, Pepper',
      },
      {
        'name': 'French Ratatouille',
        'instruction': 'Preheat oven to 375°F. Thinly slice eggplant, zucchini, tomato, and bell peppers. In a pan, sauté minced garlic in olive oil. Spread garlic at the bottom of a baking dish and layer the vegetables in a spiral pattern. Drizzle with olive oil, season with salt and pepper, and bake for 1 hour. Garnish with herbs.',
        'prepTime': '1 hr 15 mins',
        'ingredients': 'Eggplant, Zucchini, Tomato, Bell pepper, Garlic, Olive oil',
      },
    ],
    'Asian': [
      {
        'name': 'Sushi Rolls',
        'instruction': 'Rinse and cook sushi rice according to package instructions. Mix with rice vinegar and let cool. Prepare fillings like sliced fish, cucumber, or avocado. Place a sheet of nori on a bamboo mat, spread rice evenly, and add fillings. Roll tightly using the mat, then slice into pieces with a wet knife. Serve the sushi alongside with soy sauce, wasabi, and pickled ginger.',
        'prepTime': '45 mins',
        'ingredients': 'Sushi rice, Nori, Fish, Cucumber, Avocado, Rice vinegar',
      },
      {
        'name': 'Pad Thai',
        'instruction': 'Soak rice noodles in warm water for 30 minutes until soft. In a wok, stir-fry tofu until golden, then push aside and crack in an egg. Scramble and combine. Add noodles and pad thai sauce (tamarind paste, fish sauce, sugar). Toss until coated. Add bean sprouts and peanuts. Serve the pad thai alongside with lime wedges.',
        'prepTime': '30 mins',
        'ingredients': 'Rice noodles, Tofu, Egg, Tamarind paste, Peanuts, Bean sprouts',
      },
    ],
    'African': [
      {
        'name': 'Jollof Rice',
        'instruction': 'Blend tomatoes, onions, and bell peppers into a smooth paste. Heat oil in a pot and fry the mixture until it thickens. Add spices like thyme, curry powder, and bouillon. Stir in rinsed rice and water or broth. Cover and cook until rice is tender and the liquid is absorbed. Finally fluff the rice with a fork.',
        'prepTime': '1 hr',
        'ingredients': 'Rice, Tomatoes, Onions, Bell pepper, Spices, Oil',
      },
      {
        'name': 'Bobotie',
        'instruction': 'Preheat oven to 350°F. Sauté chopped onions until golden. Add ground beef and cook through. Mix in curry powder, soaked bread, and raisins. Pour into a baking dish. Whisk eggs and milk together and pour on top. Bake until the custard is set and golden brown.',
        'prepTime': '1 hr 10 mins',
        'ingredients': 'Ground beef, Onion, Curry powder, Bread, Eggs, Milk, Raisins',
      },
    ],
    'Custom': [],
  };

  final Map<String, bool> liked = {};
  final Map<String, bool> addedToCart = {};

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
                    recipeByCategory['Custom']!.add({
                      'name': name,
                      'instruction': instructions,
                      'prepTime': 'Unknown',
                      'ingredients': 'Custom ingredients',
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
          children: categories.map((category) {
            return ExpansionTile(
              title: Text(
                category,
                style: TextStyle(color: secondaryColor),
              ),
              children: [
                ...recipeByCategory[category]!.map((recipe) {
                  final recipeName = recipe['name']!;
                  liked.putIfAbsent(recipeName, () => false);
                  addedToCart.putIfAbsent(recipeName, () => false);

                  return ExpansionTile(
                    title: Text(
                      recipeName,
                      style: TextStyle(color: thirdColor),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  addedToCart[recipeName] = !addedToCart[recipeName]!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: addedToCart[recipeName]! ? Colors.green : Colors.grey,
                              ),
                              child: Text(
                                'Grocery',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  liked[recipeName] = !liked[recipeName]!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: liked[recipeName]! ? Colors.pink : Colors.grey,
                              ),
                              child: Text(
                                'Favorite',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Preparation time: ${recipe['prepTime']}',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ingredients: ${recipe['ingredients']}',
                            style: TextStyle(color: thirdColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...recipe['instruction']
                                .toString()
                                .split('.')
                                .where((step) => step.trim().isNotEmpty)
                                .toList()
                                .asMap()
                                .entries
                                .map((entry) => Text('${entry.key + 1}. ${entry.value.trim()}.', textAlign: TextAlign.left)),
                          ],
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