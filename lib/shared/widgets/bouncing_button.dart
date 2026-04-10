import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const BouncingButton({super.key, required this.child, this.onTap});

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 150),
      tween: Tween<double>(begin: 0, end: isPressed ? 0.8 : 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: onTap,
            onLongPressStart: onLongPressStart,
            onLongPressEnd: onLongPressEnd,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }

  void onTap() {
    setState(() => isPressed = true);
    Future.delayed(Duration(milliseconds: 150), () {
      setState(() => isPressed = false);
      widget.onTap?.call();
    });
  }

  void onLongPressStart(LongPressStartDetails details) {
    setState(() {
      isPressed = true;
    });
  }

  void onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      isPressed = false;
      widget.onTap?.call();
    });
  }
}
