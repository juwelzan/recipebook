import 'package:recipebook/core/api/api_coller.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class ApiService {
  ApiService._();
  Future<List<RecipeModel>> getData() async {
    return await ApiColler.instance.getData();
  }
}
