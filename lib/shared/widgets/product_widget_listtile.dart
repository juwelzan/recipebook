import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/main.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: double.infinity,
                width: 100.w,
                color: Colors.grey[400],
                child: CachedNetworkImage(
                  imageUrl: recipe.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CircleBlaurButton(
                        child: Icon(Icons.favorite_border, size: 20),
                      ),
                    ],
                  ),
                  Text(
                    '⭐ 4.5 (200 reviews)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    "By Chef's Name",
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
