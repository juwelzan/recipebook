import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductWidgetBox extends StatelessWidget {
  final RecipeModel recipe;
  const ProductWidgetBox({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    child: Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: .1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (recipe.image.isEmpty)
                  ColoredBox(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.restaurant, size: 42),
                  )
                else
                  CachedNetworkImage(
                    imageUrl: recipe.image,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        ColoredBox(color: Colors.grey.shade100),
                    errorWidget: (_, _, _) => ColoredBox(
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.broken_image_outlined, size: 36),
                    ),
                  ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .58),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipe.readyInMinutes == null
                                ? 'Time varies'
                                : '${recipe.readyInMinutes} min',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Consumer<SharedProvider>(
                    builder: (context, saved, _) {
                      final isSaved = saved.isFavorite(recipe.id);
                      return Material(
                        color: Colors.white.withValues(alpha: .94),
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: isSaved
                              ? 'Remove saved recipe'
                              : 'Save recipe',
                          onPressed: () => saved.toggleFavorite(recipe),
                          icon: SvgPicture.asset(
                            isSaved ? SvgImg.favoriteFilled : SvgImg.favorite,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              isSaved ? Colors.red : const Color(0xFF27342B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          recipe.cuisines.isNotEmpty
                              ? recipe.cuisines.first
                              : recipe.mealTypes.isNotEmpty
                              ? recipe.mealTypes.first
                              : 'Recipe idea',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      if (recipe.healthScore != null) ...[
                        const Icon(
                          Icons.favorite_outline,
                          size: 15,
                          color: Color(0xFF52734D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.healthScore!.round()}%',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
