import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/add_my_recipe_screen/model/local_recipe.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/recipe_form_screen.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/user_recipe_details_screen.dart';
import 'package:recipebook/features/user_profile_screen/provider/user_content_provider.dart';

class AddMyRecipeScreen extends StatelessWidget {
  const AddMyRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'My Recipes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          tooltip: 'Add recipe',
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add_circle_outline),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: Consumer<UserContentProvider>(
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.loadError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.loadError!, textAlign: TextAlign.center),
                TextButton.icon(
                  onPressed: state.retryLoad,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state.recipes.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your recipe collection starts here',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a recipe and it will be saved on this device.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => _openForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add your first recipe'),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          itemCount: state.recipes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final recipe = state.recipes[index];
            return _RecipeCard(
              recipe: recipe,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserRecipeDetailsScreen(recipe: recipe),
                ),
              ),
              onEdit: () => _openForm(context, recipe: recipe),
              onDelete: () => _confirmDelete(context, state, recipe),
            );
          },
        );
      },
    ),
  );

  void _openForm(BuildContext context, {LocalRecipe? recipe}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeFormScreen(recipe: recipe)),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    UserContentProvider state,
    LocalRecipe recipe,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('“${recipe.name}” will be removed from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (delete != true || !context.mounted) return;
    try {
      await state.deleteRecipe(recipe.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Recipe deleted')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete recipe. Please retry.'),
          ),
        );
      }
    }
  }
}

class _RecipeCard extends StatelessWidget {
  final LocalRecipe recipe;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecipeCard({
    required this.recipe,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    elevation: 1,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: recipe.imageUrl.isEmpty
                ? ColoredBox(
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.restaurant, size: 48),
                  )
                : CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        ColoredBox(color: Colors.grey.shade100),
                    errorWidget: (_, _, _) => ColoredBox(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        [
                          if (recipe.totalMinutes > 0)
                            '${recipe.totalMinutes} min',
                          '${recipe.difficulty} · ${recipe.servings} servings',
                        ].join('  •  '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit recipe',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete recipe',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
