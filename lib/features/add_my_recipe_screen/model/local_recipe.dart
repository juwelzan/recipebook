class RecipeIngredient {
  final String name;
  final String quantity;
  final String unit;

  const RecipeIngredient({
    required this.name,
    this.quantity = '',
    this.unit = '',
  });

  String get displayText =>
      [quantity, unit, name].where((part) => part.trim().isNotEmpty).join(' ');

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'unit': unit,
  };

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) =>
      RecipeIngredient(
        name: map['name'] is String ? map['name'] as String : '',
        quantity: map['quantity'] is String ? map['quantity'] as String : '',
        unit: map['unit'] is String ? map['unit'] as String : '',
      );
}

class LocalRecipe {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String cuisine;
  final String mealType;
  final String category;
  final int preparationMinutes;
  final int cookingMinutes;
  final int servings;
  final String difficulty;
  final List<RecipeIngredient> ingredients;
  final List<String> instructions;
  final List<String> tags;
  final String nutrition;
  final String notes;
  final DateTime updatedAt;

  const LocalRecipe({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    this.cuisine = '',
    this.mealType = '',
    this.category = '',
    this.preparationMinutes = 0,
    this.cookingMinutes = 0,
    this.servings = 1,
    this.difficulty = 'Easy',
    this.ingredients = const [],
    this.instructions = const [],
    this.tags = const [],
    this.nutrition = '',
    this.notes = '',
    required this.updatedAt,
  });

  int get totalMinutes => preparationMinutes + cookingMinutes;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'cuisine': cuisine,
    'mealType': mealType,
    'category': category,
    'preparationMinutes': preparationMinutes,
    'cookingMinutes': cookingMinutes,
    'servings': servings,
    'difficulty': difficulty,
    'ingredients': ingredients.map((item) => item.toMap()).toList(),
    'instructions': instructions,
    'tags': tags,
    'nutrition': nutrition,
    'notes': notes,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory LocalRecipe.fromMap(Map<String, dynamic> map) {
    final updatedAt = DateTime.tryParse(map['updatedAt'] as String? ?? '');
    return LocalRecipe(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      cuisine: map['cuisine'] as String? ?? '',
      mealType: map['mealType'] as String? ?? '',
      category: map['category'] as String? ?? '',
      preparationMinutes: map['preparationMinutes'] as int? ?? 0,
      cookingMinutes: map['cookingMinutes'] as int? ?? 0,
      servings: map['servings'] as int? ?? 1,
      difficulty: map['difficulty'] as String? ?? 'Easy',
      ingredients: (map['ingredients'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (item) => RecipeIngredient.fromMap(Map<String, dynamic>.from(item)),
          )
          .toList(),
      instructions: (map['instructions'] as List? ?? const [])
          .whereType<String>()
          .toList(),
      tags: (map['tags'] as List? ?? const []).whereType<String>().toList(),
      nutrition: map['nutrition'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
