import 'package:recipebook/core/api/api_coller.dart';
import 'package:recipebook/core/constant/api_url.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class ApiService {
  ApiService._();

  static void _requireApiKey() {
    if (ApiUrl.apiKey.isEmpty) {
      throw const ApiException(
        'Recipe API key is not configured. Launch with --dart-define=SPOONACULAR_API_KEY=your_key.',
      );
    }
  }

  static Future<List<RecipeModel>> getRecipes({
    String? query,
    String? diet,
    int offset = 0,
    int number = 10,
  }) async {
    _requireApiKey();
    final parameters = <String, String>{
      'number': '$number',
      'offset': '$offset',
      'addRecipeInformation': 'true',
    };
    if (query != null && query.trim().isNotEmpty) {
      parameters['query'] = query.trim();
    }
    if (diet != null && diet.isNotEmpty && diet != 'All') {
      parameters['diet'] = diet;
    }
    final data = await ApiColler.instance.getData(ApiUrl.recipes(parameters));
    if (data is! Map || data['results'] is! List) {
      throw const ApiException(
        'Recipe service returned an unexpected response.',
      );
    }
    try {
      return (data['results'] as List)
          .whereType<Map>()
          .map((item) => RecipeModel.fromMap(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on FormatException catch (error) {
      throw ApiException(error.message);
    } on TypeError {
      throw const ApiException('Recipe service returned invalid recipe data.');
    }
  }

  static Future<RecipeModel> getRecipeInformation(int id) async {
    _requireApiKey();
    final data = await ApiColler.instance.getData(ApiUrl.recipeInformation(id));
    if (data is! Map) {
      throw const ApiException('Recipe details are unavailable.');
    }
    try {
      return RecipeModel.fromMap(Map<String, dynamic>.from(data));
    } on FormatException catch (error) {
      throw ApiException(error.message);
    } on TypeError {
      throw const ApiException('Recipe details contain invalid data.');
    }
  }
}
