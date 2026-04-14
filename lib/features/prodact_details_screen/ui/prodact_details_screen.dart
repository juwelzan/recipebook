// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/core/model/recipe_model.dart';
import 'package:recipebook/features/prodact_details_screen/widgets/draggable_sheet_widget.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class ProdactDetailsScreen extends StatefulWidget {
  final RecipeModel recipeModel;
  const ProdactDetailsScreen({super.key, required this.recipeModel});

  @override
  State<ProdactDetailsScreen> createState() => _ProdactDetailsScreenState();
}

class _ProdactDetailsScreenState extends State<ProdactDetailsScreen> {
  late DraggableScrollableController _controller;
  double _currentSize = 0.6;
  @override
  void initState() {
    _controller = DraggableScrollableController();
    _controller.addListener(() {
      setState(() {
        _currentSize = _controller.size;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: _currentSize.clamp(0.6, 0.8) * 650,
            width: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.recipeModel.image,
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
            ),
          ),
          DraggableSheetWidget(
            controller: _controller,
            recipe: widget.recipeModel,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Row(
              children: [
                SizedBox(width: 20.w),
                CircleBlaurButton(
                  child: SvgPicture.asset(SvgImg.back),
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                CircleBlaurButton(
                  child: SvgPicture.asset(SvgImg.favorite),
                  onTap: () => print('Favorite tapped'),
                ),
                SizedBox(width: 20.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
