import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteRecipes;
  final void Function(Map<String, dynamic>) toggleFavorite;
  final Set<String> favoritedRecipeNames;

  const FavoritePage({
    super.key,
    required this.favoriteRecipes,
    required this.toggleFavorite,
    required this.favoritedRecipeNames,
  });

  @override
  Widget build(BuildContext context) {
    const thirdColor = Color.fromARGB(255, 50, 50, 50);
    const backgroundColor = Color.fromARGB(255, 250, 244, 236);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Recipes')),
      body: Container(
        color: backgroundColor,
        child: ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = favoriteRecipes[index];
            final recipeName = recipe['name'];

            return ExpansionTile(
              title: Text(
                recipeName,
                style: const TextStyle(color: thirdColor),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                        ElevatedButton.icon(
                          onPressed: () => toggleFavorite(recipe),
                          icon: Icon(
                            favoritedRecipeNames.contains(recipeName)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Favorite',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: favoritedRecipeNames.contains(recipeName)
                                ? Color.fromARGB(255, 224, 69, 58)
                                : Color.fromARGB(255, 124, 124, 124),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
