import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipebook/features/main_screen/ui/main_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Recipe Book',
      home: MainScreen(),
    );
  }
}

late BuildContext contexts;

extension S on num {
  double get w => this * (MediaQuery.of(contexts).size.width / 375);
  double get h => this * (MediaQuery.of(contexts).size.height / 667);
}

//https://picsum.photos/400/300
