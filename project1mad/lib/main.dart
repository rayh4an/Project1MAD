import 'package:flutter/material.dart';
import 'recipe.dart';
import 'groceries.dart';
import 'favorite.dart';
import 'loginpage.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 152, 11, 11),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User currentUser;
  final String title;

  const MyHomePage({super.key, required this.title, required this.currentUser});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> favoriteRecipes = [];
  final Set<String> favoritedRecipeNames = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _toggleFavorite(Map<String, dynamic> recipe) async {
    final name = recipe['name'];
    final db = DatabaseHelper.instance;

    setState(() {
      if (favoritedRecipeNames.contains(name)) {
        favoritedRecipeNames.remove(name);
        favoriteRecipes.removeWhere((r) => r['name'] == name);
        db.removeFavorite(widget.currentUser.id!, name);
      } else {
        favoritedRecipeNames.add(name);
        favoriteRecipes.add(recipe);
        db.addFavorite(widget.currentUser.id!, recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'Deal with your meal in much easier way.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipePage(
                      currentUser: widget.currentUser,
                      onToggleFavorite: _toggleFavorite,
                      favoriteRecipes: favoriteRecipes,
                      favoritedRecipeNames: favoritedRecipeNames,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.food_bank_rounded, size: 55),
                  SizedBox(width: 10),
                  Text('Recipes', style: TextStyle(fontSize: 35)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroceriesPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.trolley, size: 55),
                  SizedBox(width: 10),
                  Text('Groceries', style: TextStyle(fontSize: 35)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritePage(
                      favoriteRecipes: favoriteRecipes,
                      toggleFavorite: _toggleFavorite,
                      favoritedRecipeNames: favoritedRecipeNames,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.favorite, size: 55),
                  SizedBox(width: 10),
                  Text('Favorite Recipes', style: TextStyle(fontSize: 35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _loadFavorites() async {
    final db = DatabaseHelper.instance;
    final loadedFavorites = await db.getFavorites(widget.currentUser.id!);
    print("Loaded favorites: ${loadedFavorites.map((r) => r['name'])}");
    setState(() {
      favoriteRecipes.clear();
      favoritedRecipeNames.clear();
      favoriteRecipes.addAll(loadedFavorites);
      favoritedRecipeNames.addAll(
        loadedFavorites.map((r) => r['name'] as String),
      );
    });
  }

}
