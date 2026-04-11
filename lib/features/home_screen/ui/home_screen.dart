import 'package:flutter/material.dart';
import 'package:recipebook/features/home_screen/widgets/custom_appbar.dart';
import 'package:recipebook/features/home_screen/widgets/header_delegate.dart';
import 'package:recipebook/features/home_screen/widgets/popular_recipes_widget.dart';
import 'package:recipebook/features/home_screen/widgets/recipes_of_the_weeks_widget.dart';
import 'package:recipebook/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const CustomAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: HeaderDelegate(),
            floating: true,
            pinned: true,
          ),
          const PopularRecipesWidget(),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 20.0),
            sliver: const SliverToBoxAdapter(
              child: Text(
                'Recipes of the Week',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const RecipesOfTheWeeksWidget(),
          SliverPadding(padding: EdgeInsets.only(bottom: 20.0.h)),
        ],
      ),
    );
  }
}
