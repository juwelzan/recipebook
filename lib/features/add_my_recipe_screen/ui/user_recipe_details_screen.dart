import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/add_my_recipe_screen/model/local_recipe.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/recipe_form_screen.dart';
import 'package:recipebook/features/user_profile_screen/provider/user_content_provider.dart';

class UserRecipeDetailsScreen extends StatefulWidget {
  final LocalRecipe recipe;
  const UserRecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<UserRecipeDetailsScreen> createState() =>
      _UserRecipeDetailsScreenState();
}

class _UserRecipeDetailsScreenState extends State<UserRecipeDetailsScreen> {
  late LocalRecipe recipe = widget.recipe;

  Future<void> _edit() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => RecipeFormScreen(recipe: recipe)),
    );
    if (!mounted) return;
    final latest = context.read<UserContentProvider>().recipes.where(
      (item) => item.id == recipe.id,
    );
    if (latest.isEmpty) {
      Navigator.pop(context);
    } else {
      setState(() => recipe = latest.first);
    }
  }

  Future<void> _delete() async {
    final shouldDelete = await showDialog<bool>(
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
    if (shouldDelete != true || !mounted) return;
    try {
      await context.read<UserContentProvider>().deleteRecipe(recipe.id);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete recipe. Please retry.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          actions: [
            IconButton(
              tooltip: 'Edit recipe',
              onPressed: _edit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete recipe',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              recipe.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: recipe.imageUrl.isEmpty
                ? ColoredBox(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.restaurant, size: 60),
                  )
                : CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => ColoredBox(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image_outlined, size: 50),
                    ),
                  ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              if (recipe.description.isNotEmpty)
                Text(
                  recipe.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (recipe.totalMinutes > 0)
                    _fact(Icons.schedule, '${recipe.totalMinutes} min total'),
                  if (recipe.preparationMinutes > 0)
                    _fact(
                      Icons.timer_outlined,
                      '${recipe.preparationMinutes} min prep',
                    ),
                  if (recipe.cookingMinutes > 0)
                    _fact(
                      Icons.local_fire_department_outlined,
                      '${recipe.cookingMinutes} min cook',
                    ),
                  _fact(Icons.people_outline, '${recipe.servings} servings'),
                  _fact(Icons.signal_cellular_alt, recipe.difficulty),
                ],
              ),
              if ([
                recipe.cuisine,
                recipe.mealType,
                recipe.category,
              ].any((item) => item.isNotEmpty)) ...[
                const SizedBox(height: 10),
                Text(
                  [
                    recipe.cuisine,
                    recipe.mealType,
                    recipe.category,
                  ].where((item) => item.isNotEmpty).join(' · '),
                ),
              ],
              if (recipe.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: recipe.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 24),
              _heading('Ingredients'),
              ...recipe.ingredients.map(
                (item) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(item.displayText),
                ),
              ),
              const SizedBox(height: 20),
              _heading('Instructions'),
              ...recipe.instructions.indexed.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 15,
                    child: Text(
                      '${item.$1 + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(item.$2),
                ),
              ),
              if (recipe.nutrition.isNotEmpty) ...[
                const SizedBox(height: 20),
                _heading('Nutrition'),
                Text(recipe.nutrition),
              ],
              if (recipe.notes.isNotEmpty) ...[
                const SizedBox(height: 20),
                _heading('Private notes'),
                Text(recipe.notes),
              ],
              const SizedBox(height: 35),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  Widget _fact(IconData icon, String text) =>
      Chip(avatar: Icon(icon, size: 17), label: Text(text));
}
