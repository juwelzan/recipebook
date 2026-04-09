import 'package:flutter/material.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/product_widget_box.dart';

class PopularRecipesWidget extends StatelessWidget {
  const PopularRecipesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 190.h,
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const ProductWidgetBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
