import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

class Restaurants with ChangeNotifier {
  final _databaseReference = Firestore.instance;
  Restaurant restaurant;

  Future<void> fetchUserRestaurant(User loggedinUser) async {
    var restaurantDoc = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedinUser.restaurantId)
        .get();

    restaurant =
        Restaurant.fromMap(loggedinUser.restaurantId, restaurantDoc.data);

    notifyListeners();
  }
}
