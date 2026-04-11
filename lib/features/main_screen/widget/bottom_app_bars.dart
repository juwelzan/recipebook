// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/core/assets/svg_img.dart';
import 'package:recipebook/features/main_screen/widget/app_bar_button.dart';
import 'package:recipebook/features/main_screen/widget/qr_code_scan_button.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';

typedef OnPageChanged = void Function(int index);

class BottomAppBars extends StatefulWidget {
  final OnPageChanged onPageChanged;
  const BottomAppBars({super.key, required this.onPageChanged});

  @override
  State<BottomAppBars> createState() => _BottomAppBarsState();
}

class _BottomAppBarsState extends State<BottomAppBars> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedProvider>(
      builder: (context, sharedProvider, child) {
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
                isClicked: sharedProvider.selectedIndex == 0,
                svgPath: sharedProvider.selectedIndex == 0
                    ? SvgImg.homeFilled
                    : SvgImg.home,
              ),
              AppBarButton(
                onTap: () => onTap(1),
                isClicked: sharedProvider.selectedIndex == 1,
                svgPath: sharedProvider.selectedIndex == 1
                    ? SvgImg.listFilled
                    : SvgImg.list,
              ),
              QrCodeScanButton(),
              AppBarButton(
                onTap: () => onTap(2),
                isClicked: sharedProvider.selectedIndex == 2,
                svgPath: sharedProvider.selectedIndex == 2
                    ? SvgImg.favoriteFilled
                    : SvgImg.favorite,
              ),
              AppBarButton(
                onTap: () => onTap(3),
                isClicked: sharedProvider.selectedIndex == 3,
                svgPath: sharedProvider.selectedIndex == 3
                    ? SvgImg.profileFilled
                    : SvgImg.profile,
              ),
            ],
          ),
        );
      },
    );
  }

  void onTap(int index) {
    widget.onPageChanged(index);
  }
}
