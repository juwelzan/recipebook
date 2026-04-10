import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/circle_blaur_button.dart';

class CustomAppBarSave extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarSave({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleBlaurButton(
            padding: EdgeInsets.all(7.5),
            child: SvgPicture.asset(SvgImg.back, height: 25, width: 25),
          ),
          Text(
            'Save Recipe',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          CircleBlaurButton(
            child: SvgPicture.asset(SvgImg.search, height: 20, width: 20),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
