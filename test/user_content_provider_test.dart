import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/features/add_my_recipe_screen/model/local_recipe.dart';
import 'package:recipebook/features/user_profile_screen/model/user_profile.dart';
import 'package:recipebook/features/user_profile_screen/provider/user_content_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('recipes, profile, and draft survive provider reload', () async {
    final provider = UserContentProvider();
    await provider.load();
    final recipe = LocalRecipe(
      id: 'local-1',
      name: 'Lentil soup',
      preparationMinutes: 10,
      cookingMinutes: 25,
      servings: 3,
      ingredients: const [
        RecipeIngredient(name: 'Lentils', quantity: '1', unit: 'cup'),
      ],
      instructions: const ['Rinse lentils.', 'Simmer until tender.'],
      tags: const ['vegan', 'lunch'],
      updatedAt: DateTime.utc(2025, 1, 1),
    );
    await provider.saveRecipe(recipe);
    await provider.saveProfile(
      const UserProfile(name: 'A Cook', email: 'cook@example.com'),
    );
    await provider.saveDraft({'name': 'Unfinished bread', 'ingredients': []});

    final restored = UserContentProvider();
    await restored.load();

    expect(restored.recipes, hasLength(1));
    expect(restored.recipes.single.name, 'Lentil soup');
    expect(
      restored.recipes.single.ingredients.single.displayText,
      '1 cup Lentils',
    );
    expect(restored.recipes.single.totalMinutes, 35);
    expect(restored.profile.email, 'cook@example.com');
    expect(restored.draft?['name'], 'Unfinished bread');

    await restored.deleteRecipe('local-1');
    expect(restored.recipes, isEmpty);
  });
}
