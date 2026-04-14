import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/home_screen/provider/home_screen_provider.dart';
import 'package:recipebook/features/home_screen/widgets/custom_appbar.dart';
import 'package:recipebook/features/home_screen/widgets/header_delegate.dart';
import 'package:recipebook/features/home_screen/widgets/popular_recipes_widget.dart';
import 'package:recipebook/features/home_screen/widgets/recipes_of_the_weeks_widget.dart';
import 'package:recipebook/main.dart';
import 'package:recipebook/shared/widgets/loding_lottie.dart';

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
    return Consumer<HomeScreenProvider>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: state.isLoading ? null : const CustomAppbar(),
          body: state.isLoading
              ? LodingLottie()
              : RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<HomeScreenProvider>(
                      context,
                      listen: false,
                    ).getAllRecipes();
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: HeaderDelegate(),
                        floating: true,
                        pinned: true,
                      ),
                      const PopularRecipesWidget(),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 10.0,
                          bottom: 20.0,
                        ),
                        sliver: const SliverToBoxAdapter(
                          child: Text(
                            'Recipes of the Week',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const RecipesOfTheWeeksWidget(),
                      SliverPadding(padding: EdgeInsets.only(bottom: 20.0.h)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
