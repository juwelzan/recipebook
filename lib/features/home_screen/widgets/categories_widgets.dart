import 'package:flutter/material.dart';

class CategoriesWidgets extends StatelessWidget {
  const CategoriesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: List.generate(
        20,
        (index) => ListTile(title: Text('Category $index')),
      ),
    );
  }
}
