import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/add_my_recipe_screen/ui/add_my_recipe_screen.dart';
import 'package:recipebook/features/home_screen/ui/home_screen.dart';
import 'package:recipebook/features/main_screen/provider/main_screen_provider.dart';
import 'package:recipebook/features/main_screen/widget/bottom_app_bars.dart';
import 'package:recipebook/features/save_recipe_screen/ui/save_recipe_screen.dart';
import 'package:recipebook/features/user_profile_screen/ui/user_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: pageController,
              itemBuilder: (context, index) => pages[index],
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: BottomAppBars(onPageChanged: onPageChanged),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const AddMyRecipeScreen(),
    const SaveRecipeScreen(),
    const UserProfileScreen(),
  ];
  bool isPageChanged = false;
  void onPageChanged(int index) {
    context.read<MainScreenProvider>().onTap(index);
    if (isPageChanged) return;
    isPageChanged = true;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      isPageChanged = false;
    });
  }
}
