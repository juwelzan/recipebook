import 'package:flutter/material.dart';
import 'package:recipebook/features/main_screen/widget/bottom_app_bars.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(bottom: 20, left: 20, right: 20, child: BottomAppBars()),
        ],
      ),
    );
  }
}
