// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';

class CircleBlaurButton extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape? boxShape;
  final EdgeInsets? padding;
  const CircleBlaurButton({
    super.key,
    required this.child,
    this.borderRadius,
    this.boxShape,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        shape:
            boxShape ??
            (borderRadius != null ? BoxShape.rectangle : BoxShape.circle),
        borderRadius: boxShape != null ? null : borderRadius,
        color: Colors.transparent,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: padding ?? const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape:
                boxShape ??
                (borderRadius != null ? BoxShape.rectangle : BoxShape.circle),
            borderRadius: boxShape != null ? null : borderRadius,
            color: Colors.transparent,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
