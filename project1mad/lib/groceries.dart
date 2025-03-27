import 'package:flutter/material.dart';
import 'database_helper.dart';

class GroceriesPage extends StatefulWidget {
  final int userId;
  const GroceriesPage({super.key, required this.userId});

  @override
  State<GroceriesPage> createState() => _GroceriesPageState();
}

class _GroceriesPageState extends State<GroceriesPage> {
  Map<String, List<String>> groceryMap = {};
  Set<String> checkedItems = {};

  @override
  void initState() {
    super.initState();
    _loadGroceries();
  }

  Future<void> _loadGroceries() async {
    final data = await DatabaseHelper.instance.getGroceriesByUser(
      widget.userId,
    );
    setState(() {
      groceryMap = data;
    });
  }

  Future<void> _handleCheck(String recipe, String item) async {
    final key = '$recipe::$item';
    setState(() {
      checkedItems.add(key);
    });

    await Future.delayed(const Duration(milliseconds: 300));

    await DatabaseHelper.instance.removeGroceryItem(
      widget.userId,
      recipe,
      item,
    );
    await _loadGroceries();

    setState(() {
      checkedItems.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery List')),
      body:
          groceryMap.isEmpty
              ? const Center(child: Text('No groceries added.'))
              : ListView(
                children:
                    groceryMap.entries.map((entry) {
                      final recipeName = entry.key;
                      final ingredients = entry.value;

                      return ExpansionTile(
                        title: Text(
                          recipeName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children:
                            ingredients.map((item) {
                              final itemKey = '$recipeName::$item';
                              final isChecked = checkedItems.contains(itemKey);

                              return CheckboxListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    decoration:
                                        isChecked
                                            ? TextDecoration.lineThrough
                                            : null,
                                    color: isChecked ? Colors.grey : null,
                                  ),
                                ),
                                value: isChecked,
                                onChanged:
                                    (_) => _handleCheck(recipeName, item),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            }).toList(),
                      );
                    }).toList(),
              ),
    );
  }
}
