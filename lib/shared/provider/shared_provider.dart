import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedProvider extends ChangeNotifier {
  static const _storageKey = 'saved_recipes_v1';
  final Map<int, RecipeModel> _favorites = {};
  bool _loaded = false;

  List<RecipeModel> get favorites => List.unmodifiable(_favorites.values);
  bool isFavorite(int id) => _favorites.containsKey(id);

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final values = prefs.getStringList(_storageKey) ?? const [];
      for (final value in values) {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          final recipe = RecipeModel.fromMap(decoded);
          _favorites[recipe.id] = recipe;
        }
      }
    } catch (error) {
      debugPrint('Could not restore saved recipes: $error');
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(RecipeModel recipe) async {
    if (!_loaded) await loadFavorites();
    if (_favorites.containsKey(recipe.id)) {
      _favorites.remove(recipe.id);
    } else {
      _favorites[recipe.id] = recipe;
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _storageKey,
        _favorites.values.map((item) => jsonEncode(item.toMap())).toList(),
      );
    } catch (error) {
      debugPrint('Could not persist saved recipes: $error');
    }
  }
}
