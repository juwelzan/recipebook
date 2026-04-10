import 'package:flutter/material.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class RecipesOfTheWeeksWidget extends StatelessWidget {
  const RecipesOfTheWeeksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) =>
            const Divider(thickness: 2, height: 30),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ProductWidgetListtile();
        },
      ),
    );
  }
}
