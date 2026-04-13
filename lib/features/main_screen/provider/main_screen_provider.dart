import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void onTap(int index) async {
    selectedIndex = index;
    notifyListeners();
  }
}
