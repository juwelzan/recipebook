import 'package:flutter/material.dart';
import 'package:recipebook/shared/widgets/bouncing_button.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isClicked;
  const AppBarButton({super.key, this.onTap, this.isClicked = false});

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 200),
            tween: Tween<double>(begin: 1, end: isClicked ? 1 : 0),
            builder: (context, value, child) {
              return Container(
                height: 5,
                width: value * 30,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black,
                ),
              );
            },
          ),
          Icon(Icons.menu, size: 30),
        ],
      ),
    );
  }
}
