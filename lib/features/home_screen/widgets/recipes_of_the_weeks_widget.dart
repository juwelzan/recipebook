import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class RecipesOfTheWeeksWidget extends StatelessWidget {
  const RecipesOfTheWeeksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedProvider>(
      builder: (context, state, child) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) =>
                const Divider(thickness: 2, height: 30),
            itemCount: state.recipes.length,
            itemBuilder: (context, index) {
              final data = state.recipes[index];
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
