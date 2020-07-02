import 'package:flutter/material.dart';

class UserPreferences with ChangeNotifier {
  String selectedCategory = '';

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
