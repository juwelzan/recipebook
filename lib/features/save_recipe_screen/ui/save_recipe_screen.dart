import 'package:flutter/material.dart';
import 'package:recipebook/features/save_recipe_screen/widget/custom_app_bar_save.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class SaveRecipeScreen extends StatelessWidget {
  const SaveRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSave(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 20.0, bottom: 150.0),
          itemCount: 20,
          itemBuilder: (context, index) {
            return ProductWidgetListtile();
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 1, color: Colors.grey, height: 30);
          },
        ),
      ),
    );
  }
}
