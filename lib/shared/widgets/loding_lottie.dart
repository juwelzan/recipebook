import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:recipebook/core/assets/lottie_file.dart';

class LodingLottie extends StatelessWidget {
  const LodingLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset(LottieFile.loading),
      ),
    );
  }
}
