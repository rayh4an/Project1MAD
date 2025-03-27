import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipe.dart';

/// === RECIPE MODEL ===
class Recipe {
  final int? id;
  final String name;
  final String instructions;
  final String prepTime;
  final String ingredients;
  final int userId;

  Recipe({
    this.id,
    required this.name,
    required this.instructions,
    required this.prepTime,
    required this.ingredients,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'instructions': instructions,
      'prepTime': prepTime,
      'ingredients': ingredients,
      'userId': userId,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      instructions: map['instructions'],
      prepTime: map['prepTime'],
      ingredients: map['ingredients'],
      userId: map['userId'],
    );
  }
}

/// === USER MODEL ===
class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}

/// === DATABASE HELPER ===
class DatabaseHelper {
  static const _databaseName = "app_database.db";
  static const _databaseVersion = 4; // 🔼 Upgraded from 1 to 2

  static const customRecipeTable = 'custom_recipes';
  static const userTable = 'users';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $customRecipeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        instructions TEXT NOT NULL,
        prepTime TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES $userTable(id)
      )
    ''');
    await db.execute('''
  CREATE TABLE favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    recipe_name TEXT NOT NULL,
    UNIQUE(user_id, recipe_name)
  )
''');

    await db.execute('''
  CREATE TABLE groceries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    recipeName TEXT NOT NULL,
    item TEXT NOT NULL,
    FOREIGN KEY (userId) REFERENCES users(id)
  )
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $customRecipeTable ADD COLUMN userId INTEGER NOT NULL DEFAULT 1
      ''');
    }
  }

  // === Recipe CRUD ===
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert(customRecipeTable, recipe.toMap());
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      customRecipeTable,
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<List<Recipe>> getAllCustomRecipes() async {
    final db = await database;
    final result = await db.query(customRecipeTable);
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getCustomRecipesByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      customRecipeTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(customRecipeTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteRecipeById(int id) async {
    final db = await database;
    await db.delete(
      customRecipeTable, // ✅ use your actual table name here
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // === User CRUD ===
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(userTable, user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      userTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(userTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, List<String>>> getGroceriesByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'groceries',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    Map<String, List<String>> groceryMap = {};
    for (var row in result) {
      final recipe = row['recipeName'] as String;
      final item = row['item'] as String;
      groceryMap.putIfAbsent(recipe, () => []).add(item);
    }

    return groceryMap;
  }

  // Add grocery item to database
  Future<void> addGroceryItem(
    int userId,
    String recipeName,
    String item,
  ) async {
    final db = await database;
    await db.insert('groceries', {
      'userId': userId,
      'recipeName': recipeName,
      'item': item,
    });
  }

  // Remove grocery item from database
  Future<void> removeGroceryItem(
    int userId,
    String recipeName,
    String item,
  ) async {
    final db = await database;
    await db.delete(
      'groceries',
      where: 'userId = ? AND recipeName = ? AND item = ?',
      whereArgs: [userId, recipeName, item],
    );
  }

  // Add to favorites
  Future<void> addFavorite(int userId, String recipeName) async {
    final db = await database;
    await db.insert('favorites', {
      'user_id': userId,
      'recipe_name': recipeName,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int userId, String recipeName) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND recipe_name = ?',
      whereArgs: [userId, recipeName],
    );
  }

  Future<List<String>> getFavoritesByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((row) => row['recipe_name'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getAllRecipesForUser(int userId) async {
    final db = await database;

    // Load user-created custom recipes
    final customRecipes = await db.query(
      'custom_recipes',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Get all hardcoded recipes from recipeByCategory
    List<Map<String, dynamic>> hardcodedRecipes = [];
    recipeByCategory.forEach((category, recipes) {
      for (var r in recipes) {
        hardcodedRecipes.add(r);
      }
    });

    return [...hardcodedRecipes, ...customRecipes];
  }
}

  // Load all grocery items for a user

