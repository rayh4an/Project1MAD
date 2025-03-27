import 'package:flutter/material.dart';
import 'database_helper.dart';

class RecipePage extends StatefulWidget {
  final User currentUser;
  final void Function(Map<String, dynamic>) onToggleFavorite;
  final List<Map<String, dynamic>> favoriteRecipes;
  final Set<String> favoritedRecipeNames;

  const RecipePage({
    super.key,
    required this.currentUser,
    required this.onToggleFavorite,
    required this.favoriteRecipes,
    required this.favoritedRecipeNames,
  });

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
        'instruction':
            'Preheat your grill to medium-high. Toast the buns lightly on the grill for 1–2 minutes. Grill the beef patty for about 4–5 minutes on each side until fully cooked. Add a slice of cheese on top and let it melt. Place the patty on the bun, then add lettuce, tomato, pickles, ketchup, and mustard as desired. Cover with the top bun.',
        'prepTime': '20 mins',
        'ingredients':
            'Buns, Beef Patty, Cheese, Lettuce, Tomato, Pickles, Ketchup, Mustard',
      },
      {
        'name': 'BBQ Ribs',
        'instruction':
            'Preheat oven to 300°F. Season ribs with salt, pepper, garlic powder, and onion powder. Wrap the ribs in foil and bake for 2 hours. Unwrap and brush generously with BBQ sauce. Grill for 10 more minutes to caramelize the sauce. Slice the ribs.',
        'prepTime': '2 hrs 30 mins',
        'ingredients':
            'Beef Ribs, BBQ sauce, Salt, Pepper, Garlic powder, Onion powder',
      },
      {
        'name': 'Tacos',
        'instruction':
            'Heat a pan over medium heat and cook the ground beef until browned. Drain excess grease and stir in taco seasoning with a splash of water. Simmer for 5 minutes. Warm tortillas in a skillet or microwave. Fill each tortilla with beef, shredded lettuce, diced tomatoes, cheese, and a dollop of sour cream. Serve the tacos with salsa on the side.',
        'prepTime': '25 mins',
        'ingredients':
            'Tortillas, Ground beef, Taco seasoning, Lettuce, Tomato, Cheese, Sour cream, Salsa',
      },
      {
        'name': 'Empanadas',
        'instruction':
            'In a skillet, cook chopped onion and garlic until translucent. Add ground beef and cook through. Stir in paprika and chopped green olives. Let filling cool. Roll out dough and place a spoonful of filling in the center. Fold and crimp edges. Brush with beaten egg. Bake at 375°F for 25 minutes until golden.',
        'prepTime': '45 mins',
        'ingredients':
            'Empanada dough, Ground beef, Onion, Garlic, Paprika, Green olives, Egg',
      },
    ],
    'European': [
      {
        'name': 'Pasta Carbonara',
        'instruction':
            'Bring a large pot of salted water to a boil and cook spaghetti until al dente. In a pan, cook diced bacon until crispy. In a bowl, whisk together eggs and grated parmesan. Drain the pasta and quickly mix it with the hot bacon and the egg-cheese mixture while stirring continuously to avoid scrambling the eggs. Season with black pepper.',
        'prepTime': '30 mins',
        'ingredients': 'Spaghetti, Eggs, Parmesan, Bacon, Pepper',
      },
      {
        'name': 'French Ratatouille',
        'instruction':
            'Preheat oven to 375°F. Thinly slice eggplant, zucchini, tomato, and bell peppers. In a pan, sauté minced garlic in olive oil. Spread garlic at the bottom of a baking dish and layer the vegetables in a spiral pattern. Drizzle with olive oil, season with salt and pepper, and bake for 1 hour. Garnish with herbs.',
        'prepTime': '1 hr 15 mins',
        'ingredients':
            'Eggplant, Zucchini, Tomato, Bell pepper, Garlic, Olive oil',
      },
      {
        'name': 'Paella',
        'instruction':
            'Heat oil in a wide skillet and brown the chicken and chorizo. Remove and sauté onions and garlic. Stir in rice and saffron. Add broth and return meat. Simmer for 15 minutes, then add shrimp and peas. Cook without stirring until rice absorbs liquid. Let the paella rest.',
        'prepTime': '1 hr',
        'ingredients':
            'Arborio rice, Chicken, Shrimp, Chorizo, Bell pepper, Onion, Garlic, Saffron, Peas',
      },
      {
        'name': 'Fish and Chips',
        'instruction':
            'Cut potatoes into fries and soak in water for 30 minutes. Drain and pat dry. Heat oil and fry potatoes until golden. In a bowl, mix flour, baking powder, salt, and beer to make batter. Dip fish into batter and fry until crispy. Serve the fish alongside fries and tartar sauce.',
        'prepTime': '40 mins',
        'ingredients':
            'Cod fillets, Potatoes, Flour, Baking powder, Beer, Salt, Oil',
      },
    ],
    'Asian': [
      {
        'name': 'Sushi Rolls',
        'instruction':
            'Rinse and cook sushi rice according to package instructions. Mix with rice vinegar and let cool. Prepare fillings like sliced fish, cucumber, or avocado. Place a sheet of nori on a bamboo mat, spread rice evenly, and add fillings. Roll tightly using the mat, then slice into pieces with a wet knife. Serve the sushi alongside with soy sauce, wasabi, and pickled ginger.',
        'prepTime': '45 mins',
        'ingredients':
            'Sushi rice, Nori, Fish, Cucumber, Avocado, Rice vinegar',
      },
      {
        'name': 'Pad Thai',
        'instruction':
            'Soak rice noodles in warm water for 30 minutes until soft. In a wok, stir-fry tofu until golden, then push aside and crack in an egg. Scramble and combine. Add noodles and pad thai sauce (tamarind paste, fish sauce, sugar). Toss until coated. Add bean sprouts and peanuts. Serve the pad thai alongside with lime wedges.',
        'prepTime': '30 mins',
        'ingredients':
            'Rice noodles, Tofu, Egg, Tamarind paste, Peanuts, Bean sprouts',
      },
      {
        'name': 'Egg Fried Rice',
        'instruction':
            'Scramble eggs in a hot wok with sesame oil. Remove and set aside. Add diced carrots and peas to the wok and cook until tender. Add cold cooked rice and stir-fry. Stir in soy sauce and green onions. Return eggs and mix thoroughly with rice.',
        'prepTime': '25 mins',
        'ingredients':
            'Cooked rice, Eggs, Green onion, Soy sauce, Peas, Carrots, Sesame oil',
      },
      {
        'name': 'Mutton Biryani',
        'instruction':
            'Marinate mutton in yogurt and spices for 1 hour. Sauté onions until golden, then add tomatoes and cook down. Add marinated mutton and cook until tender. In another pot, parboil rice. Layer rice and mutton in a pot. Top with fried onions and ghee. Cover and steam the meal for atleast 20 mins.',
        'prepTime': '1 hr 30 mins',
        'ingredients':
            'Mutton, Basmati rice, Onion, Tomato, Yogurt, Spices, Ghee',
      },
    ],
    'African': [
      {
        'name': 'Jollof Rice',
        'instruction':
            'Blend tomatoes, onions, and bell peppers into a smooth paste. Heat oil in a pot and fry the mixture until it thickens. Add spices like thyme, curry powder, and bouillon. Stir in rinsed rice and water or broth. Cover and cook until rice is tender and the liquid is absorbed. Finally fluff the rice with a fork.',
        'prepTime': '1 hr',
        'ingredients': 'Rice, Tomatoes, Onions, Bell pepper, Spices, Oil',
      },
      {
        'name': 'Bobotie',
        'instruction':
            'Preheat oven to 350°F. Sauté chopped onions until golden. Add ground beef and cook through. Mix in curry powder, soaked bread, and raisins. Pour into a baking dish. Whisk eggs and milk together and pour on top. Bake until the custard is set and golden brown.',
        'prepTime': '1 hr 10 mins',
        'ingredients':
            'Ground beef, Onion, Curry powder, Bread, Eggs, Milk, Raisins',
      },
      {
        'name': 'Shakshouka',
        'instruction':
            'Sauté onion, garlic, and bell pepper until soft. Stir in tomatoes, paprika, and cumin. Simmer until thickened. Make wells in the sauce and crack eggs into them. Cover and cook until eggs are just set.',
        'prepTime': '35 mins',
        'ingredients':
            'Eggs, Tomato, Onion, Bell pepper, Garlic, Paprika, Cumin',
      },
      {
        'name': 'Suya',
        'instruction':
            'Slice beef into thin strips and marinate with a mix of ground peanuts, paprika, cayenne, ginger, and onion powder. Thread onto skewers. Grill over medium heat, turning often, until cooked through and charred. Serve the Suya alongside onions and tomatoes.',
        'prepTime': '45 mins',
        'ingredients':
            'Beef skewers, Peanut powder, Paprika, Cayenne, Ginger, Onion powder, Oil',
      },
    ],
    'Custom': [],
  };

  final Color primaryColor = const Color.fromARGB(255, 229, 158, 158);
  final Color secondaryColor = const Color.fromARGB(255, 152, 11, 11);
  final Color thirdColor = const Color.fromARGB(255, 50, 50, 50);
  final Color backgroundColor = const Color.fromARGB(255, 250, 244, 236);

  final List<Map<String, dynamic>> favoriteRecipes = [];
  final List<String> groceryList = [];

  final Set<String> groceryIngredientKeys = {};

  void _toggleFavorite(Map<String, dynamic> recipe) {
    widget.onToggleFavorite(recipe);
    setState(() {}); // to refresh the UI (icon state)
  }

  void _toggleGroceries(String ingredients) {
    final key = ingredients.trim();
    final items = ingredients.split(',').map((e) => e.trim()).toList();
    setState(() {
      if (groceryIngredientKeys.contains(key)) {
        groceryIngredientKeys.remove(key);
        groceryList.removeWhere((item) => items.contains(item));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Removed from groceries')));
      } else {
        groceryIngredientKeys.add(key);
        groceryList.addAll(items);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Added to groceries')));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomRecipes();
  }

  Future<void> _loadCustomRecipes() async {
    try {
      final recipes = await DatabaseHelper.instance.getCustomRecipesByUser(
        widget.currentUser.id!,
      );
      setState(() {
        recipeByCategory['Custom'] =
            recipes.map((r) {
              return {
                'id': r.id,
                'name': r.name,
                'instruction': r.instructions,
                'prepTime': r.prepTime,
                'ingredients': r.ingredients,
              };
            }).toList();
      });
    } catch (e) {
      print("Error loading custom recipes: $e");
    }
  }

  Future<void> _addRecipeToDatabase(
    String name,
    String instructions,
    String prepTime,
    String ingredients,
  ) async {
    if (widget.currentUser.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User ID is invalid!")));
      return;
    }

    try {
      final recipe = Recipe(
        name: name,
        instructions: instructions,
        prepTime: prepTime,
        ingredients: ingredients,
        userId: widget.currentUser.id!,
      );

      final id = await DatabaseHelper.instance.insertRecipe(recipe);
      _loadCustomRecipes();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recipe added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add recipe: $e")));
    }
  }

  void _deleteCustomRecipe(int id) async {
    try {
      await DatabaseHelper.instance.deleteRecipe(id);
      _loadCustomRecipes();
    } catch (e) {
      print("Error deleting recipe: $e");
    }
  }

  void _showAddRecipeDialog() {
    final recipeNameController = TextEditingController();
    final instructionController = TextEditingController();
    final prepTimeController = TextEditingController();
    final ingredientsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Recipe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: recipeNameController,
                  decoration: const InputDecoration(labelText: 'Recipe Name'),
                ),
                TextField(
                  controller: prepTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Preparation Time',
                  ),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                ),
                TextField(
                  controller: instructionController,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = recipeNameController.text.trim();
                final instructions = instructionController.text.trim();
                final prepTime = prepTimeController.text.trim();
                final ingredients = ingredientsController.text.trim();

                if (name.isNotEmpty &&
                    instructions.isNotEmpty &&
                    prepTime.isNotEmpty &&
                    ingredients.isNotEmpty) {
                  await _addRecipeToDatabase(
                    name,
                    instructions,
                    prepTime,
                    ingredients,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRecipeDialog(Map<String, dynamic> recipe) {
    final nameController = TextEditingController(text: recipe['name']);
    final prepTimeController = TextEditingController(text: recipe['prepTime']);
    final ingredientsController = TextEditingController(
      text: recipe['ingredients'],
    );
    final instructionsController = TextEditingController(
      text: recipe['instruction'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Recipe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: prepTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Preparation Time',
                  ),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredients'),
                ),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(labelText: 'Instructions'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedRecipe = Recipe(
                  id: recipe['id'],
                  name: nameController.text,
                  instructions: instructionsController.text,
                  prepTime: prepTimeController.text,
                  ingredients: ingredientsController.text,
                  userId: widget.currentUser.id!,
                );

                await DatabaseHelper.instance.updateRecipe(updatedRecipe);
                Navigator.of(context).pop();
                _loadCustomRecipes();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe updated!')),
                );
              },
              child: const Text('Save'),
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
                    ...recipeByCategory[category]!.map((recipe) {
                      final recipeName = recipe['name']!;
                      return ExpansionTile(
                        title: Text(
                          recipeName,
                          style: TextStyle(color: thirdColor),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preparation time: ${recipe['prepTime']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ingredients: ${recipe['ingredients']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Instructions:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Instructions:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ...recipe['instruction']
                                      .toString()
                                      .split('.')
                                      .where((step) => step.trim().isNotEmpty)
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => Text(
                                          "${entry.key + 1}. ${entry.value.trim()}.",
                                        ),
                                      ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed:
                                            () => _toggleFavorite(recipe),
                                        icon: Icon(
                                          widget.favoritedRecipeNames.contains(recipe['name'])
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Favorite',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              widget.favoritedRecipeNames.contains(recipe['name'])
                                                  ? const Color.fromARGB(
                                                    255,
                                                    224,
                                                    69,
                                                    58,
                                                  )
                                                  : const Color.fromARGB(
                                                    255,
                                                    124,
                                                    124,
                                                    124,
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed:
                                            () => _toggleGroceries(
                                              recipe['ingredients'],
                                            ),
                                        icon: Icon(
                                          Icons.shopping_cart,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Groceries',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              groceryIngredientKeys.contains(
                                                    recipe['ingredients'],
                                                  )
                                                  ? const Color.fromARGB(
                                                    255,
                                                    101,
                                                    239,
                                                    106,
                                                  )
                                                  : const Color.fromARGB(
                                                    255,
                                                    124,
                                                    124,
                                                    124,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (category == 'Custom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      () => _showEditRecipeDialog(recipe),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit'),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      () => _deleteCustomRecipe(recipe['id']),
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
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
