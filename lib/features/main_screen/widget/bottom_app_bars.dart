import 'package:flutter/material.dart';
import 'package:recipebook/features/main_screen/widget/app_bar_button.dart';
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
      color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBarButton(onTap: () => onTap(0), isClicked: selectedIndex == 0),
          AppBarButton(onTap: () => onTap(1), isClicked: selectedIndex == 1),
          AppBarButton(onTap: () => onTap(2), isClicked: selectedIndex == 2),
          AppBarButton(onTap: () => onTap(3), isClicked: selectedIndex == 3),
        ],
      ),
    );
  }

  void onTap(int index) {
    setState(() => selectedIndex = index);
  }
}
