import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Recipe {
  final int? id;
  final String name;
  final String instructions;

  Recipe({this.id, required this.name, required this.instructions});

  // Convert a Recipe to a Map (for storing in the database)
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'instructions': instructions};
  }

  // Convert a Map to a Recipe (for reading from the database)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      instructions: map['instructions'],
    );
  }
}

class DatabaseHelper {
  static const _databaseName = "recipes.db";
  static const _databaseVersion = 1;

  static const table = 'recipes';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnInstructions = 'instructions';

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

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
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnInstructions TEXT NOT NULL
      )
    ''');
  }

  // Insert a new recipe
  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert(table, recipe.toMap());
  }

  // Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;
    final result = await db.query(table);
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  // Update an existing recipe
  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      table,
      recipe.toMap(),
      where: '$columnId = ?',
      whereArgs: [recipe.id],
    );
  }

  // Delete a recipe
  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
