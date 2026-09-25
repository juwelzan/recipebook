class ApiUrl {
  ApiUrl._();

  static const String baseUrl = 'https://api.spoonacular.com/recipes';
  static const String apiKey = String.fromEnvironment('SPOONACULAR_API_KEY');

  static Uri recipes(Map<String, String> parameters) => Uri.parse(
    '$baseUrl/complexSearch',
  ).replace(queryParameters: {...parameters, 'apiKey': apiKey});

  static Uri recipeInformation(int id) => Uri.parse(
    '$baseUrl/$id/information',
  ).replace(queryParameters: {'apiKey': apiKey});
}
