import 'package:flutter/material.dart';

class AddMyRecipeScreen extends StatefulWidget {
  const AddMyRecipeScreen({super.key});

  @override
  State<AddMyRecipeScreen> createState() => _AddMyRecipeScreenState();
}

class _AddMyRecipeScreenState extends State<AddMyRecipeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Placeholder();
  }
}
