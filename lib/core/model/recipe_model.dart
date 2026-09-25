import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  final int id;
  final String title;
  final String image;
  final String imageType;
  final int? readyInMinutes;
  final int? servings;
  final double? healthScore;
  final List<String> cuisines;
  final List<String> mealTypes;
  final List<String> diets;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    this.imageType = '',
    this.readyInMinutes,
    this.servings,
    this.healthScore,
    this.cuisines = const [],
    this.mealTypes = const [],
    this.diets = const [],
    this.ingredients = const [],
    this.instructions = const [],
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    final id = int.tryParse('${map['id']}');
    if (id == null || map['title'] is! String) {
      throw const FormatException('Recipe is missing a valid id or title.');
    }
    final ingredients = map['extendedIngredients'] ?? map['ingredients'];
    final analyzed = map['analyzedInstructions'];
    final rawInstructions = map['instructions'];
    final steps = rawInstructions is List
        ? rawInstructions
        : rawInstructions is String && rawInstructions.trim().isNotEmpty
        ? [rawInstructions]
        : analyzed is List && analyzed.isNotEmpty && analyzed.first is Map
        ? (analyzed.first['steps'] as List? ?? const [])
        : const [];
    return RecipeModel(
      id: id,
      title: map['title'] as String,
      image: map['image'] is String ? map['image'] as String : '',
      imageType: map['imageType'] is String ? map['imageType'] as String : '',
      readyInMinutes: map['readyInMinutes'] is num
          ? (map['readyInMinutes'] as num).toInt()
          : null,
      servings: map['servings'] is num
          ? (map['servings'] as num).toInt()
          : null,
      healthScore: map['healthScore'] is num
          ? (map['healthScore'] as num).toDouble()
          : null,
      cuisines: _strings(map['cuisines']),
      mealTypes: _strings(map['dishTypes']),
      diets: _strings(map['diets']),
      ingredients:
          ingredients is List &&
              (ingredients.isEmpty || ingredients.first is Map)
          ? ingredients
                .whereType<Map>()
                .map((item) {
                  final original = item['original'];
                  final name = item['name'];
                  return original is String
                      ? original
                      : name is String
                      ? name
                      : '';
                })
                .where((value) => value.isNotEmpty)
                .toList()
          : ingredients is List
          ? ingredients.whereType<String>().toList()
          : const [],
      instructions: steps.isEmpty || steps.first is Map
          ? steps
                .whereType<Map>()
                .map((step) {
                  final text = step['step'];
                  return text is String ? text : '';
                })
                .where((value) => value.isNotEmpty)
                .toList()
          : steps.whereType<String>().toList(),
    );
  }

  static List<String> _strings(dynamic value) => value is List
      ? value.whereType<String>().toList(growable: false)
      : const [];

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'image': image,
    'imageType': imageType,
    'readyInMinutes': readyInMinutes,
    'servings': servings,
    'healthScore': healthScore,
    'cuisines': cuisines,
    'dishTypes': mealTypes,
    'diets': diets,
    'ingredients': ingredients,
    'instructions': instructions,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    image,
    imageType,
    readyInMinutes,
    servings,
    healthScore,
    cuisines,
    mealTypes,
    diets,
    ingredients,
    instructions,
  ];
}
