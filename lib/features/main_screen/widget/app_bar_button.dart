import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/bouncing_button.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isClicked;
  final String? svgPath;
  const AppBarButton({
    super.key,
    this.onTap,
    this.isClicked = false,
    this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onTap: onTap,
      child: SizedBox(
        width: 30.w,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 200),
              tween: Tween<double>(begin: 1, end: isClicked ? 1 : 0),
              builder: (context, value, child) {
                return Container(
                  height: 5,
                  width: value * 25,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black,
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            SvgPicture.asset(
              svgPath ?? 'assets/svg/home.svg',
              height: 30,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
