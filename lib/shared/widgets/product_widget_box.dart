import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';

class ProductWidgetBox extends StatelessWidget {
  final RecipeModel recipe;
  const ProductWidgetBox({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,

      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const Icon(Icons.restaurant),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    recipe.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (recipe.readyInMinutes != null)
                  Text(
                    '${recipe.readyInMinutes} min',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleBlaurButton(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, size: 15, color: Colors.white),
                      Text(
                        ' ${recipe.readyInMinutes ?? '—'} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<SharedProvider>(
                  builder: (context, saved, _) {
                    final isSaved = saved.isFavorite(recipe.id);
                    return CircleBlaurButton(
                      onTap: () => saved.toggleFavorite(recipe),
                      child: SvgPicture.asset(
                        isSaved ? SvgImg.favoriteFilled : SvgImg.favorite,
                        height: 20,
                        width: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
