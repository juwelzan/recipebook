import 'package:flutter/material.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/add_my_recipe_screen.dart';
import 'package:recipebook/features/home_screen/ui/home_screen.dart';
import 'package:recipebook/features/main_screen/widget/bottom_app_bars.dart';
import 'package:recipebook/features/save_recipe_screen/ui/save_recipe_screen.dart';
import 'package:recipebook/features/user_profile_screen/ui/user_profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                AddMyRecipeScreen(),
                SaveRecipeScreen(),
                UserProfileScreen(),
              ],
            ),
          ),
          Positioned(bottom: 20, left: 20, right: 20, child: BottomAppBars()),
        ],
      ),
    );
  }
}

PageController pageController = PageController();
