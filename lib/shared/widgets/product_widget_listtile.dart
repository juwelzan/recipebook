import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class ProductWidgetListtile extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback? onTap;

  const ProductWidgetListtile({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            // IMAGE
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: recipe.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // CONTENT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      CircleBlaurButton(
                        child: const Icon(Icons.favorite_border, size: 20),
                      ),
                    ],
                  ),

                  Text(
                    '⭐ 4.5 (200 reviews)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                  Text(
                    "By Chef's Name",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
