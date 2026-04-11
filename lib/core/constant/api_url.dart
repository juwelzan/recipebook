class ApiUrl {
  ApiUrl._();
  static const String apiKey = 'b09e4a41e8f54cc59e8670b903c6441a';
  static const String baseUrl = 'https://api.spoonacular.com/recipes';
  static const String recipes = '$baseUrl/complexSearch?apiKey=$apiKey';
  static const String products = '$baseUrl/products';
}
