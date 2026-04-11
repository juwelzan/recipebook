import 'package:flutter/material.dart';
import 'package:recipebook/features/main_screen/ui/main_screen.dart';

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Recipe Book',
      home: MainScreen(),
    );
  }
}
