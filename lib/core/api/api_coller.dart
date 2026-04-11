import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipebook/core/constant/api_url.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class ApiColler {
  ApiColler._();

  static final ApiColler instance = ApiColler._();
  Future<List<RecipeModel>> getData() async {
    debugPrint('Fetching data from API...');
    try {
      final response = await http.get(Uri.parse(ApiUrl.recipes));
      if (response.statusCode == 200) {
        debugPrint('Data loaded successfully');
        final data = json.decode(response.body);
        final List<RecipeModel> recipes = (data['results'] as List)
            .map((item) => RecipeModel.fromMap(item))
            .toList();
        debugPrint('Received data: $data');
        return recipes;
      } else {
        debugPrint('Failed to load data: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      debugPrint('Error occurred: $e');
      return [];
    }
  }
}
