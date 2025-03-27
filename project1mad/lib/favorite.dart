import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'recipe.dart';

enum FilterOption { all, vegetarian, nonVegetarian }

class FavoritePage extends StatefulWidget {
  final User currentUser;
  const FavoritePage({super.key, required this.currentUser});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  FilterOption _filterOption = FilterOption.all;
  Set<String> favoritedRecipeNames = {};
  Map<String, Map<String, dynamic>> allRecipes = {}; // name -> details

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await DatabaseHelper.instance.getFavoritesByUser(
      widget.currentUser.id!,
    );
    final customRecipes = await DatabaseHelper.instance.getCustomRecipesByUser(
      widget.currentUser.id!,
    );

    // Add hardcoded recipes from RecipePage
    final combined = <Map<String, dynamic>>[];

    recipeByCategory.forEach((category, recipes) {
      for (final r in recipes) {
        combined.add(r);
      }
    });

    combined.addAll(
      customRecipes.map(
        (r) => {
          'id': r.id,
          'name': r.name,
          'instruction': r.instructions,
          'prepTime': r.prepTime,
          'ingredients': r.ingredients,
        },
      ),
    );

    setState(() {
      favoritedRecipeNames = favorites.toSet();
      allRecipes = {for (var r in combined) r['name']: r};
    });
  }

  void _unfavorite(String name) async {
    await DatabaseHelper.instance.removeFavorite(widget.currentUser.id!, name);
    setState(() {
      favoritedRecipeNames.remove(name);
    });
  }

  bool _isVegetarian(String ingredients) {
    final lower = ingredients.toLowerCase();
    return !lower.contains("beef") &&
        !lower.contains("chicken") &&
        !lower.contains("mutton") &&
        !lower.contains("fish") &&
        !lower.contains("shrimp") &&
        !lower.contains("bacon") &&
        !lower.contains("meat");
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes =
        favoritedRecipeNames.where((name) {
          final recipe = allRecipes[name];
          if (recipe == null) return false;
          final ingredients = recipe['ingredients'] ?? '';
          if (_filterOption == FilterOption.vegetarian)
            return _isVegetarian(ingredients);
          if (_filterOption == FilterOption.nonVegetarian)
            return !_isVegetarian(ingredients);
          return true;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      _filterOption == FilterOption.all
                          ? Colors.lightBlueAccent
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed:
                      () => setState(() => _filterOption = FilterOption.all),
                  icon: const Text("All:", style: TextStyle(fontSize: 18)),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color:
                      _filterOption == FilterOption.vegetarian
                          ? Colors.lightGreen
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed:
                      () => setState(
                        () => _filterOption = FilterOption.vegetarian,
                      ),
                  icon: const Text(
                    "Vegetarian: 🥦",
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color:
                      _filterOption == FilterOption.nonVegetarian
                          ? Colors.deepOrange
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed:
                      () => setState(
                        () => _filterOption = FilterOption.nonVegetarian,
                      ),
                  icon: const Text(
                    "Non-vegetarian: 🥩",
                    style: TextStyle(fontSize: 18),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final name = filteredRecipes[index];
                final recipe = allRecipes[name]!;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(name),
                    children: [
                      ListTile(
                        title: Text("Prep Time: ${recipe['prepTime']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ingredients: ${recipe['ingredients']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Instructions:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...recipe['instruction']
                                .toString()
                                .split('.')
                                .where((s) => s.trim().isNotEmpty)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Text(
                                    "${entry.key + 1}. ${entry.value.trim()}",
                                  ),
                                ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _unfavorite(name),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  "Remove Favorite",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
