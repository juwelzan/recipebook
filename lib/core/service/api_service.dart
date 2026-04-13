import 'package:recipebook/core/api/api_coller.dart';
import 'package:recipebook/core/constant/api_url.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class ApiService {
  ApiService._();
  static Future<List<RecipeModel>> getRecipes(String search) async {
    if (search == "All") {
      final data = await ApiColler.instance.getData(
        '${ApiUrl.recipes}&number=100',
      );
      if (data != null && data['results'] != null) {
        return List<RecipeModel>.from(
          data['results'].map((item) => RecipeModel.fromMap(item)),
        );
      } else {
        return [];
      }
    } else {
      final data = await ApiColler.instance.getData(
        '${ApiUrl.recipes}?query=$search&number=100',
      );
      if (data != null && data['results'] != null) {
        return List<RecipeModel>.from(
          data['results'].map((item) => RecipeModel.fromMap(item)),
        );
      } else {
        return [];
      }
    }
  }
}
