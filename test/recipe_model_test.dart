import 'package:flutter_test/flutter_test.dart';
import 'package:recipebook/core/model/recipe_model.dart';

void main() {
  group('RecipeModel.fromMap', () {
    test(
      'parses search and detail fields and ignores optional missing values',
      () {
        final recipe = RecipeModel.fromMap({
          'id': 42,
          'title': 'Roasted vegetables',
          'image': 'https://example.test/recipe.jpg',
          'readyInMinutes': 35,
          'servings': 4,
          'healthScore': 81.5,
          'cuisines': ['Mediterranean'],
          'dishTypes': ['dinner'],
          'diets': ['vegetarian'],
          'extendedIngredients': [
            {'original': '2 cups chopped vegetables'},
          ],
          'analyzedInstructions': [
            {
              'steps': [
                {'step': 'Preheat the oven.'},
                {'step': 'Roast until tender.'},
              ],
            },
          ],
        });

        expect(recipe.id, 42);
        expect(recipe.readyInMinutes, 35);
        expect(recipe.cuisines, ['Mediterranean']);
        expect(recipe.ingredients, ['2 cups chopped vegetables']);
        expect(recipe.instructions, [
          'Preheat the oven.',
          'Roast until tender.',
        ]);
        expect(
          RecipeModel.fromMap({'id': '7', 'title': 'Simple'}).image,
          isEmpty,
        );
      },
    );

    test('rejects invalid required fields clearly', () {
      expect(
        () => RecipeModel.fromMap({'id': 'bad', 'title': 'Broken'}),
        throwsFormatException,
      );
    });
  });
}
