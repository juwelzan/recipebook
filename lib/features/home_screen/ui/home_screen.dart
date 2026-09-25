import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/features/home_screen/provider/home_screen_provider.dart';
import 'package:recipebook/features/home_screen/widgets/custom_appbar.dart';
import 'package:recipebook/features/home_screen/widgets/header_delegate.dart';
import 'package:recipebook/features/home_screen/widgets/popular_recipes_widget.dart';
import 'package:recipebook/features/home_screen/widgets/recipes_of_the_weeks_widget.dart';
import 'package:recipebook/shared/widgets/loding_lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<HomeScreenProvider>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: CustomAppbar(
            onSearchTap: () => _searchFocusNode.requestFocus(),
          ),
          body: state.isLoading && state.allRecipes.isEmpty
              ? const LodingLottie()
              : state.errorMessage != null && state.allRecipes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off, size: 48),
                        const SizedBox(height: 12),
                        Text(state.errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: state.getAllRecipes,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: state.getAllRecipes,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            textInputAction: TextInputAction.search,
                            onChanged: state.search,
                            decoration: InputDecoration(
                              hintText: 'Search recipes',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  state.search('');
                                },
                                icon: const Icon(Icons.close),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: HeaderDelegate(),
                        floating: true,
                        pinned: true,
                      ),
                      if (state.isLoading)
                        const SliverToBoxAdapter(
                          child: LinearProgressIndicator(),
                        ),
                      if (state.errorMessage != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(child: Text(state.errorMessage!)),
                                IconButton(
                                  onPressed: state.getAllRecipes,
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'Retry',
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (state.allRecipes.isEmpty &&
                          !state.isLoading &&
                          state.errorMessage == null)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No recipes found. Try another search.',
                            ),
                          ),
                        )
                      else ...[
                        const PopularRecipesWidget(),
                        const SliverPadding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 16),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              'Recipes',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const RecipesOfTheWeeksWidget(),
                        if (state.loadMoreError != null)
                          SliverToBoxAdapter(
                            child: Center(
                              child: TextButton.icon(
                                onPressed: state.loadMore,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Could not load more. Retry'),
                              ),
                            ),
                          )
                        else if (state.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          )
                        else if (state.hasMore)
                          SliverToBoxAdapter(
                            child: Center(
                              child: TextButton(
                                onPressed: state.loadMore,
                                child: const Text('Load more recipes'),
                              ),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
}
