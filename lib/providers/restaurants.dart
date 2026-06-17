import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/models.dart';
import 'package:foodorderingadmin/services/pocketbase_service.dart';

class Restaurants with ChangeNotifier {
  final _pocketBase = PocketBaseService.client;
  Restaurant restaurant = Restaurant();
  String selectedCategory = '';

  List<String> get categories => restaurant.categories;

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    final record =
        await _pocketBase.collection('restaurants').getOne(restaurantId);

    restaurant = Restaurant.fromMap(record.id, record.data);

    if (categories.isNotEmpty) {
      selectedCategory = categories[0];
    }

    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
