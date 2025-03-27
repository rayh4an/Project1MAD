import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  static const _databaseVersion = 2; // 🔼 Upgraded from 1 to 2

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
        userId INTEGER NOT NULL,
        recipeName TEXT NOT NULL,
        recipeIngredients TEXT,
        recipePrepTime TEXT,
        recipeInstruction TEXT
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

  Future<void> addFavorite(int userId, Map<String, dynamic> recipe) async {
    final db = await database;
    await db.insert('favorites', {
      'userId': userId,
      'recipeName': recipe['name'],
      'recipeIngredients': recipe['ingredients'],
      'recipePrepTime': recipe['prepTime'],
      'recipeInstruction': recipe['instruction'],
    });
  }

  Future<void> removeFavorite(int userId, String recipeName) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'userId = ? AND recipeName = ?',
      whereArgs: [userId, recipeName],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.map((row) {
      return {
        'name': row['recipeName'],
        'ingredients': row['recipeIngredients'],
        'prepTime': row['recipePrepTime'],
        'instruction': row['recipeInstruction'],
      };
    }).toList();
  }
  
}
