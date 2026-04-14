import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/home_screen/provider/home_screen_provider.dart';
import 'package:recipebook/features/prodact_details_screen/ui/prodact_details_screen.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/product_widget_box.dart';

class PopularRecipesWidget extends StatelessWidget {
  const PopularRecipesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<HomeScreenProvider>(
        builder: (context, state, child) {
          return SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Popular Recipes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final data = state.allRecipes[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProdactDetailsScreen(recipeModel: data),
                          ),
                        ),
                        child: ProductWidgetBox(recipe: data),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
