import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/prodact_details_screen/ui/prodact_details_screen.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class SaveRecipeScreen extends StatelessWidget {
  const SaveRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved recipes')),
      body: Consumer<SharedProvider>(
        builder: (context, saved, _) {
          if (saved.favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_border, size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No saved recipes yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tap the bookmark on a recipe to keep it here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: saved.favorites.length,
            separatorBuilder: (_, _) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final recipe = saved.favorites[index];
              return ProductWidgetListtile(
                recipe: recipe,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProdactDetailsScreen(recipeModel: recipe),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
