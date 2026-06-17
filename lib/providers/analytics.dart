import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/analytics.dart';
import 'package:foodorderingadmin/models/order_item.dart';
import 'package:foodorderingadmin/models/user.dart';
import 'package:foodorderingadmin/services/pocketbase_service.dart';

const String dayOrderSummaryDocName = "DayOrderAnalytic";

class Analytics extends ChangeNotifier {
  final _pocketBase = PocketBaseService.client;

  DayOrderAnalytic _dayOrderAnalytic = DayOrderAnalytic();

  DayOrderSummary selectedOrderDay = DayOrderSummary();

  List<DayOrderSummary> get orderAnalytics =>
      [..._dayOrderAnalytic.dayOrderSummary];

  Future<void> fetchAnalytics(User loggedInUser) async {
    final records = await _pocketBase.collection('analytics_daily').getFullList(
          filter: "restaurant = '${loggedInUser.restaurantId}'",
          sort: '-date',
        );

    _dayOrderAnalytic = DayOrderAnalytic(
      dayOrderSummary: records
          .map((record) => DayOrderSummary.fromMap(record.data))
          .toList(),
    );

    if (_dayOrderAnalytic.dayOrderSummary.isNotEmpty) {
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

    if (orderDays.isEmpty) {
      _dayOrderAnalytic.dayOrderSummary.add(DayOrderSummary(
          orderDate: order.orderDate, total: order.total, orderCount: 1));
    } else {
      var orderDay = orderDays.toList()[0];
      orderDay.orderCount += 1;
      orderDay.total += order.total;
    }

    await _saveDayOrderAnalytic(loggedInUser.restaurantId, order.orderDate);

    notifyListeners();
  }

  Future<void> _saveDayOrderAnalytic(
      String restaurantId, DateTime orderDate) async {
    final orderDay = _dayOrderAnalytic.dayOrderSummary.firstWhere((element) =>
        element.orderDate.day == orderDate.day &&
        element.orderDate.month == orderDate.month &&
        element.orderDate.year == orderDate.year);

    final day = DateTime(orderDate.year, orderDate.month, orderDate.day)
        .toIso8601String();
    final records = await _pocketBase.collection('analytics_daily').getFullList(
          filter: "restaurant = '$restaurantId' && date = '$day'",
          batch: 1,
        );

    final body = {
      'restaurant': restaurantId,
      'date': day,
      'orderCount': orderDay.orderCount,
      'total': orderDay.total,
    };

    if (records.isEmpty) {
      await _pocketBase.collection('analytics_daily').create(body: body);
    } else {
      await _pocketBase
          .collection('analytics_daily')
          .update(records.first.id, body: body);
    }
  }
}
