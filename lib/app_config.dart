import 'package:flutter/material.dart';
import 'package:recipebook/features/main_screen/ui/main_screen.dart';

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Book',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF52734D)),
        scaffoldBackgroundColor: const Color(0xFFFAFAF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAF7),
          foregroundColor: Color(0xFF1E2A22),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E2A22),
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: Color(0xFF314237)),
          shape: Border(bottom: BorderSide(color: Color(0xFFE9ECE5))),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
