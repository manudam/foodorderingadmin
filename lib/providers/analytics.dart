import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/database_collection_names.dart';
import 'package:foodorderingadmin/models/analytics.dart';
import 'package:foodorderingadmin/models/order_item.dart';
import 'package:foodorderingadmin/models/user.dart';

class Analytics extends ChangeNotifier {
  final _databaseReference = Firestore.instance;

  DayOrderAnalytic dayOrderAnalytic;

  Future<void> fetchAnalytics(User loggedInUser) async {
    var documents = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.analytics)
        .where("name", isEqualTo: "DayOrderAnalytic")
        .getDocuments();

    for (var document in documents.documents) {
      dayOrderAnalytic =
          DayOrderAnalytic.fromMap(document.documentID, document.data);
    }

    if (dayOrderAnalytic == null) {
      dayOrderAnalytic =
          DayOrderAnalytic(name: "DayOrderAnalytic", dayOrderSummary: []);

      await _saveDayOrderAnalytic(loggedInUser.restaurantId);
    }

    notifyListeners();
  }

  Future<void> updateDayOrderAnalytic(
      OrderItem order, User loggedInUser) async {
    var orderDays = dayOrderAnalytic.dayOrderSummary.where((element) =>
        element.orderDate.day == order.orderDate.day &&
        element.orderDate.month == order.orderDate.month &&
        element.orderDate.year == order.orderDate.year);

    if (orderDays.length == 0) {
      dayOrderAnalytic.dayOrderSummary.add(DayOrderSummary(
          orderDate: order.orderDate, total: order.total, orderCount: 1));
    } else {
      var orderDay = orderDays.toList()[0];
      orderDay.orderCount += 1;
      orderDay.total += order.total;
    }

    await _saveDayOrderAnalytic(loggedInUser.restaurantId);

    notifyListeners();
  }

  Future<void> _saveDayOrderAnalytic(String restaurantId) async {
    if (dayOrderAnalytic.id == null) {
      var savedAnalytic = await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(restaurantId)
          .collection(DatabaseCollectionNames.analytics)
          .add(dayOrderAnalytic.toJson());

      dayOrderAnalytic.id = savedAnalytic.documentID;
    } else {
      await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(restaurantId)
          .collection(DatabaseCollectionNames.analytics)
          .document(dayOrderAnalytic.id)
          .updateData(dayOrderAnalytic.toJson());
    }
  }
}
