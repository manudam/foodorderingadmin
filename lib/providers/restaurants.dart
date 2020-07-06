import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

class Restaurants with ChangeNotifier {
  final _databaseReference = Firestore.instance;
  Restaurant restaurant;
  String selectedCategory;

  List<String> get categories =>
      restaurant != null ? restaurant.categories : [];

  Future<void> fetchRestaurantDetails(String restaurantId) async {
    var restaurantDoc = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(restaurantId)
        .get();

    restaurant = Restaurant.fromMap(restaurantId, restaurantDoc.data);

    if (categories.length > 0) {
      selectedCategory = categories[0];
    }

    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
