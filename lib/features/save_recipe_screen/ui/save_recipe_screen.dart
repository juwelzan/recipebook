import 'package:flutter/material.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/features/save_recipe_screen/widget/custom_app_bar_save.dart';
import 'package:recipebook/shared/widgets/product_widget_listtile.dart';

class SaveRecipeScreen extends StatefulWidget {
  const SaveRecipeScreen({super.key});

  @override
  State<SaveRecipeScreen> createState() => _SaveRecipeScreenState();
}

class _SaveRecipeScreenState extends State<SaveRecipeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBarSave(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 20.0, bottom: 150.0),
          itemCount: 20,
          itemBuilder: (context, index) {
            return ProductWidgetListtile(
              recipe: RecipeModel(
                title: 'Recipe Title $index',
                image: 'https://example.com/image$index.jpg',
                id: 1,
                imageType: '',
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(thickness: 1, color: Colors.grey, height: 30);
          },
        ),
      ),
    );
  }
}
