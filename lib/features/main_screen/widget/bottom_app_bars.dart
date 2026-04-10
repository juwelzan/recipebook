// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/features/main_screen/ui/main_screen.dart';
import 'package:recipebook/features/main_screen/widget/app_bar_button.dart';
import 'package:recipebook/features/main_screen/widget/qr_code_scan_button.dart';
import 'package:recipebook/main.dart';

class BottomAppBars extends StatefulWidget {
  const BottomAppBars({super.key});

  @override
  State<BottomAppBars> createState() => _BottomAppBarsState();
}

class _BottomAppBarsState extends State<BottomAppBars> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      height: 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarButton(
            onTap: () => onTap(0),
            isClicked: selectedIndex == 0,
            svgPath: selectedIndex == 0 ? SvgImg.homeFilled : SvgImg.home,
          ),
          AppBarButton(
            onTap: () => onTap(1),
            isClicked: selectedIndex == 1,
            svgPath: selectedIndex == 1 ? SvgImg.listFilled : SvgImg.list,
          ),
          QrCodeScanButton(),
          AppBarButton(
            onTap: () => onTap(2),
            isClicked: selectedIndex == 2,
            svgPath: selectedIndex == 2
                ? SvgImg.favoriteFilled
                : SvgImg.favorite,
          ),
          AppBarButton(
            onTap: () => onTap(3),
            isClicked: selectedIndex == 3,
            svgPath: selectedIndex == 3 ? SvgImg.profileFilled : SvgImg.profile,
          ),
        ],
      ),
    );
  }

  void onTap(int index) async {
    pageController.jumpToPage(index);
    await Future.delayed(Duration(milliseconds: 150));
    setState(() => selectedIndex = index);
  }
}
