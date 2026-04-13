import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/core/service/api_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<String> categories = [
    'All',
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Ketogenic',
  ];
  List<String> get getCategories => categories;
  List<RecipeModel> allRecipes = [];

  bool isLoading = false;
  bool isCategoryScreen = false;

  Future<void> getRecipesByCategory(String category) async {
    isLoading = true;
    isCategoryScreen = true;
    notifyListeners();

    String search = category.toLowerCase();

    if (search == "all") {
      await getAllRecipes();
    } else {
      allRecipes = await ApiService.getRecipes(search);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllRecipes() async {
    isLoading = true;
    isCategoryScreen = false;
    notifyListeners();

    allRecipes = await ApiService.getRecipes("All");

    isLoading = false;
    notifyListeners();
  }
}
