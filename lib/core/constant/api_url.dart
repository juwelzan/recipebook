class ApiUrl {
  ApiUrl._();

  static const String baseUrl = 'https://api.spoonacular.com/recipes';
  static const String apiKey = "b09e4a41e8f54cc59e8670b903c6441a";

  static Uri recipes(Map<String, String> parameters) => Uri.parse(
    '$baseUrl/complexSearch',
  ).replace(queryParameters: {...parameters, 'apiKey': apiKey});

  static Uri recipeInformation(int id) => Uri.parse(
    '$baseUrl/$id/information',
  ).replace(queryParameters: {'apiKey': apiKey});
}
