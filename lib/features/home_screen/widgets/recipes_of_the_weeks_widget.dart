import 'package:flutter/material.dart';
import 'package:recipebook/main.dart';

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
          return Container(
            height: 100,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'Recipe of the Week $index',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
