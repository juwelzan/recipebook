import 'package:flutter/material.dart';
import 'dart:async';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/core/service/api_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  static const int pageSize = 10;
  final List<String> categories = const [
    'All',
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Ketogenic',
  ];
  List<RecipeModel> allRecipes = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = false;
  String? loadMoreError;
  String? errorMessage;
  String selectedCategory = 'All';
  String searchQuery = '';
  int _requestId = 0;
  Timer? _searchDebounce;

  Future<void> getRecipesByCategory(String category) async {
    selectedCategory = category;
    await _load();
  }

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery == searchQuery) return;
    searchQuery = normalizedQuery;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), _load);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> getAllRecipes() async {
    _searchDebounce?.cancel();
    selectedCategory = 'All';
    searchQuery = '';
    await _load();
  }

  Future<void> _load() async {
    _searchDebounce?.cancel();
    _searchDebounce = null;
    final requestId = ++_requestId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final recipes = await ApiService.getRecipes(
        query: searchQuery,
        diet: selectedCategory,
      );
      if (requestId != _requestId) return;
      allRecipes = recipes;
      hasMore = recipes.length == pageSize;
      loadMoreError = null;
    } catch (error) {
      if (requestId != _requestId) return;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (requestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    loadMoreError = null;
    notifyListeners();
    try {
      final recipes = await ApiService.getRecipes(
        query: searchQuery,
        diet: selectedCategory,
        offset: allRecipes.length,
        number: pageSize,
      );
      final existingIds = allRecipes.map((recipe) => recipe.id).toSet();
      final freshRecipes = recipes.where(
        (recipe) => !existingIds.contains(recipe.id),
      );
      allRecipes = [...allRecipes, ...freshRecipes];
      hasMore = recipes.length == pageSize && freshRecipes.isNotEmpty;
    } catch (error) {
      loadMoreError = error.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
