import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';

class DraggableSheetWidget extends StatelessWidget {
  final DraggableScrollableController? controller;
  final RecipeModel recipe;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const DraggableSheetWidget({
    super.key,
    this.controller,
    required this.recipe,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    initialChildSize: .58,
    minChildSize: .5,
    maxChildSize: .9,
    controller: controller,
    builder: (context, scrollController) => Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            recipe.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              if (recipe.readyInMinutes != null)
                _fact(Icons.schedule, '${recipe.readyInMinutes} min'),
              if (recipe.servings != null)
                _fact(Icons.people_outline, '${recipe.servings} servings'),
              if (recipe.healthScore != null)
                _fact(
                  Icons.favorite_border,
                  'Health ${recipe.healthScore!.round()}%',
                ),
            ],
          ),
          if (recipe.cuisines.isNotEmpty ||
              recipe.mealTypes.isNotEmpty ||
              recipe.diets.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              [
                ...recipe.cuisines,
                ...recipe.mealTypes,
                ...recipe.diets,
              ].join(' • '),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
          const SizedBox(height: 24),
          if (isLoading) const LinearProgressIndicator(),
          if (errorMessage != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(errorMessage!),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          if (recipe.ingredients.isNotEmpty) ...[
            Text(
              'Ingredients',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (recipe.instructions.isNotEmpty) ...[
            Text(
              'Instructions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.instructions.indexed.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      child: Text(
                        '${entry.$1 + 1}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(entry.$2)),
                  ],
                ),
              ),
            ),
          ],
          if (!isLoading &&
              recipe.ingredients.isEmpty &&
              recipe.instructions.isEmpty &&
              errorMessage == null)
            const Text(
              'Detailed ingredients and instructions are not available for this recipe.',
            ),
        ],
      ),
    ),
  );

  Widget _fact(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Colors.grey.shade700),
      const SizedBox(width: 5),
      Text(label),
    ],
  );
}
