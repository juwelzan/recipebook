import 'package:flutter/material.dart';
import 'package:recipebook/core/api/api_coller.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class SharedProvider with ChangeNotifier {
  int selectedIndex = 0;
  bool isLoading = false;

  List<String> categories = [
    'All',
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Ketogenic',
  ];

  List<String> get getCategories => categories;

  List<RecipeModel> recipes = [];

  void onTap(int index) async {
    selectedIndex = index;
    notifyListeners();
  }

  void getRecipes() async {
    isLoading = true;
    final apiService = await ApiColler.instance.getData();
    recipes.addAll(apiService);
    isLoading = false;
    notifyListeners();
  }
}
