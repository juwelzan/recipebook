import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipebook/app_config.dart';
import 'package:recipebook/shared/provider/shared_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedProvider()..getRecipes()),
      ],
      child: const AppConfig(),
    );
  }
}

late BuildContext contexts;

extension S on num {
  double get w => this * (MediaQuery.of(contexts).size.width / 375);
  double get h => this * (MediaQuery.of(contexts).size.height / 667);
}

//https://picsum.photos/400/300
