// import 'package:flutter/material.dart';

// class ShimmerEffect extends StatefulWidget {
//   final Widget child;
//   final bool isLoding;
//   const ShimmerEffect({super.key, required this.child, this.isLoding = true});

//   @override
//   State<ShimmerEffect> createState() => _ShimmerEffectState();
// }

// class _ShimmerEffectState extends State<ShimmerEffect>
//     with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   late AnimationController animationController;

//   @override
//   void initState() {
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..repeat();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     if (!widget.isLoding) {
//       return widget.child;
//     }

//     return RepaintBoundary(
//       child: AnimatedBuilder(
//         animation: animationController,
//         builder: (context, child) {
//           return ShaderMask(
//             shaderCallback: (bounds) {
//               return LinearGradient(
//                 colors: [Colors.grey, Colors.grey.shade100, Colors.grey],
//                 begin: Alignment(-1 + animationController.value * 2, 0),
//                 end: Alignment(1 + animationController.value * 2, 0),
//               ).createShader(bounds);
//             },
//             blendMode: BlendMode.srcATop,
//             child: Material(
//               borderRadius: BorderRadius.circular(8),
//               clipBehavior: Clip.antiAlias,
//               child: widget.child,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     animationController.stop();
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

// extension ShimmerEffectExtension on Widget {
//   Widget shimmer() {
//     return ShimmerEffect(isLoding: true, child: this);
//   }
// }
