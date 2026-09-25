import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recipebook/features/add_my_recipe_screen/model/local_recipe.dart';
import 'package:recipebook/features/user_profile_screen/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserContentProvider extends ChangeNotifier {
  static const _recipesKey = 'my_recipes_v1';
  static const _profileKey = 'user_profile_v1';
  static const _draftKey = 'my_recipe_draft_v1';

  List<LocalRecipe> _recipes = [];
  UserProfile _profile = const UserProfile();
  Map<String, dynamic>? _draft;
  bool isLoading = true;
  String? loadError;

  List<LocalRecipe> get recipes => List.unmodifiable(_recipes);
  UserProfile get profile => _profile;
  Map<String, dynamic>? get draft =>
      _draft == null ? null : Map.unmodifiable(_draft!);

  Future<void> load() async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _recipes = [];
      for (final raw in prefs.getStringList(_recipesKey) ?? const <String>[]) {
        try {
          _recipes.add(
            LocalRecipe.fromMap(
              Map<String, dynamic>.from(jsonDecode(raw) as Map),
            ),
          );
        } catch (error) {
          debugPrint(
            'Skipping invalid local recipe record: ${error.runtimeType}',
          );
        }
      }
      final profileJson = prefs.getString(_profileKey);
      if (profileJson != null) {
        try {
          _profile = UserProfile.fromMap(
            Map<String, dynamic>.from(jsonDecode(profileJson) as Map),
          );
        } catch (error) {
          debugPrint('Could not decode profile: ${error.runtimeType}');
        }
      }
      final draftJson = prefs.getString(_draftKey);
      if (draftJson == null) {
        _draft = null;
      } else {
        try {
          _draft = Map<String, dynamic>.from(jsonDecode(draftJson) as Map);
        } catch (error) {
          debugPrint('Could not decode recipe draft: ${error.runtimeType}');
          _draft = null;
        }
      }
    } catch (error) {
      debugPrint('Could not load local user data: ${error.runtimeType}');
      loadError = 'Could not load your saved data. Please retry.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLoad() => load();

  Future<void> saveRecipe(LocalRecipe recipe) async {
    final next = [..._recipes.where((item) => item.id != recipe.id), recipe]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _persistRecipes(next);
    _recipes = next;
    try {
      await clearDraft();
    } catch (error) {
      debugPrint('Could not clear recipe draft: ${error.runtimeType}');
    }
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    final next = _recipes.where((item) => item.id != id).toList();
    await _persistRecipes(next);
    _recipes = next;
    notifyListeners();
  }

  Future<void> _persistRecipes(List<LocalRecipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setStringList(
      _recipesKey,
      recipes.map((item) => jsonEncode(item.toMap())).toList(),
    );
    if (!ok) throw Exception('Could not save recipe data.');
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(_profileKey, jsonEncode(profile.toMap()));
    if (!ok) throw Exception('Could not save profile.');
    _profile = profile;
    notifyListeners();
  }

  Future<void> saveDraft(Map<String, dynamic> draft) async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(_draftKey, jsonEncode(draft));
    if (!ok) throw Exception('Could not save draft.');
    _draft = Map.of(draft);
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
    _draft = null;
  }
}
