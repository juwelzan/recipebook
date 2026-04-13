import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/home_screen/provider/home_screen_provider.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class RecipesOfTheWeeksWidget extends StatelessWidget {
  const RecipesOfTheWeeksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, state, child) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) =>
                const Divider(thickness: 2, height: 30),
            itemCount: state.allRecipes.length,
            itemBuilder: (context, index) {
              final data = state.allRecipes[index];
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ProductWidgetListtile(recipe: data);
            },
          ),
        );
      },
    );
  }
}
