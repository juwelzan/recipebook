import 'package:flutter/material.dart';
import 'package:recipebook/features/home_screen/widgets/categories_widgets.dart';
import 'package:recipebook/features/home_screen/widgets/custom_appbar.dart';
import 'package:recipebook/features/home_screen/widgets/header_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: HeaderDelegate(),
            floating: true,
            pinned: true,
          ),
          const CategoriesWidgets(),
        ],
      ),
    );
  }
}
