import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/database_collection_names.dart';
import 'package:foodorderingadmin/models/analytics.dart';
import 'package:foodorderingadmin/models/order_item.dart';
import 'package:foodorderingadmin/models/user.dart';

const String dayOrderSummaryDocName = "DayOrderAnalytic";

class Analytics extends ChangeNotifier {
  final _databaseReference = Firestore.instance;

  DayOrderAnalytic _dayOrderAnalytic;

  DayOrderSummary selectedOrderDay;

  List<DayOrderSummary> get orderAnalytics =>
      [..._dayOrderAnalytic.dayOrderSummary];

  Future<void> fetchAnalytics(User loggedInUser) async {
    var document = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.analytics)
        .document(dayOrderSummaryDocName)
        .get();

    if (document.exists) {
      _dayOrderAnalytic = DayOrderAnalytic.fromMap(document.data);
    }

    if (_dayOrderAnalytic == null) {
      _dayOrderAnalytic = DayOrderAnalytic(dayOrderSummary: []);

      await _saveDayOrderAnalytic(loggedInUser.restaurantId);
    }

    _dayOrderAnalytic.dayOrderSummary
        .sort((a, b) => b.orderDate.compareTo(a.orderDate));

    if (_dayOrderAnalytic.dayOrderSummary.length > 0) {
      selectedOrderDay = _dayOrderAnalytic.dayOrderSummary[0];
    }

    notifyListeners();
  }

  void selectDayOrder(DayOrderSummary dayOrder) {
    selectedOrderDay = dayOrder;
    notifyListeners();
  }

  Future<void> updateDayOrderAnalytic(
      OrderItem order, User loggedInUser) async {
    var orderDays = _dayOrderAnalytic.dayOrderSummary.where((element) =>
        element.orderDate.day == order.orderDate.day &&
        element.orderDate.month == order.orderDate.month &&
        element.orderDate.year == order.orderDate.year);

    if (orderDays.length == 0) {
      _dayOrderAnalytic.dayOrderSummary.add(DayOrderSummary(
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
    if (_dayOrderAnalytic.dayOrderSummary.length == 0) {
      await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(restaurantId)
          .collection(DatabaseCollectionNames.analytics)
          .document(dayOrderSummaryDocName)
          .setData(_dayOrderAnalytic.toJson());
    } else {
      await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(restaurantId)
          .collection(DatabaseCollectionNames.analytics)
          .document(dayOrderSummaryDocName)
          .updateData(_dayOrderAnalytic.toJson());
    }
  }
}
