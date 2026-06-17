import 'package:flutter/foundation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:foodorderingadmin/models/payment_option.dart';
import 'package:foodorderingadmin/services/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/models.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _liveOrders = [];
  List<OrderItem> _acceptedOrders = [];
  final _pocketBase = PocketBaseService.client;

  UnsubscribeFunc? _liveOrdersUnsubscribe;
  UnsubscribeFunc? _acceptedOrdersUnsubscribe;

  List<OrderItem> get liveOrders {
    return [..._liveOrders];
  }

  List<OrderItem> get acceptedOrders {
    return [..._acceptedOrders];
  }

  Future<void> streamLiveOrders(User loggedinUser) async {
    _liveOrders.clear();

    var pageLoadDate = DateTime.now();
    await _refreshLiveOrders(loggedinUser);

    _liveOrdersUnsubscribe =
        await _pocketBase.collection('orders').subscribe('*', (event) async {
      if (event.record == null) {
        return;
      }

      await _refreshLiveOrders(loggedinUser);
      final record = event.record;
      if (record == null) {
        return;
      }
      final changedOrder = OrderItem.fromMap(
        record.id,
        record.data,
      );
      if (event.action == 'create' &&
          changedOrder.orderDate.isAfter(pageLoadDate)) {
        FlutterRingtonePlayer().playNotification();
      }
    }, filter: "restaurant = '${loggedinUser.restaurantId}'");
  }

  Future<void> _refreshLiveOrders(User loggedinUser) async {
    final today = _startOfDay(DateTime.now()).toIso8601String();
    final records = await _pocketBase.collection('orders').getFullList(
          filter:
              "restaurant = '${loggedinUser.restaurantId}' && orderDate >= '$today'",
          sort: '-orderDate',
        );

    _liveOrders = records
        .map((record) => OrderItem.fromMap(record.id, record.data))
        .where((order) => order.orderStatus != OrderStatus.AcceptedAndPaid)
        .toList();

    notifyListeners();
  }

  void unstreamLiveOrders() {
    _liveOrdersUnsubscribe?.call();
    _liveOrdersUnsubscribe = null;
  }

  Future<void> streamAcceptedOrders(User loggedinUser) async {
    _acceptedOrders.clear();
    await _refreshAcceptedOrders(loggedinUser);

    _acceptedOrdersUnsubscribe =
        await _pocketBase.collection('orders').subscribe('*', (event) async {
      await _refreshAcceptedOrders(loggedinUser);
    }, filter: "restaurant = '${loggedinUser.restaurantId}'");
  }

  Future<void> _refreshAcceptedOrders(User loggedinUser) async {
    var today = _startOfDay(DateTime.now()).toIso8601String();

    var records = await _pocketBase.collection('orders').getFullList(
          filter:
              "restaurant = '${loggedinUser.restaurantId}' && orderStatus = 'acceptedAndPaid' && acceptedDate >= '$today'",
          sort: '-acceptedDate',
        );

    _acceptedOrders = records
        .map((record) => OrderItem.fromMap(record.id, record.data))
        .toList();
    notifyListeners();
  }

  void unstreamAcceptedOrders() {
    _acceptedOrdersUnsubscribe?.call();
    _acceptedOrdersUnsubscribe = null;
  }

  Future<List<OrderItem>> fetchArchivedOrders(
      DateTime orderDate, User loggedinUser) async {
    var queryDate = _startOfDay(orderDate);
    var nextDate = queryDate.add(Duration(days: 1));

    var records = await _pocketBase.collection('orders').getFullList(
          filter:
              "restaurant = '${loggedinUser.restaurantId}' && orderStatus = 'acceptedAndPaid' && acceptedDate >= '${queryDate.toIso8601String()}' && acceptedDate < '${nextDate.toIso8601String()}'",
          sort: '-acceptedDate',
        );

    return records
        .map((record) => OrderItem.fromMap(record.id, record.data))
        .toList();
  }

  Future<void> acceptOrder(OrderItem order, User loggedInUser) async {
    if (order.paymentDetails.paymentOption == PaymentOption.Card ||
        order.orderStatus == OrderStatus.PaymentAccepted) {
      order.orderStatus = OrderStatus.AcceptedAndPaid;
    } else {
      order.orderStatus = OrderStatus.Accepted;
    }

    order.acceptedDate = DateTime.now();
    order.acceptedBy = loggedInUser.name;

    await updateOrder(order, loggedInUser);
  }

  Future<void> acceptPaymentOrder(OrderItem order, User loggedInUser) async {
    if (order.orderStatus == OrderStatus.Accepted) {
      order.orderStatus = OrderStatus.AcceptedAndPaid;
    } else {
      order.orderStatus = OrderStatus.PaymentAccepted;
    }

    order.paymentAcceptedDate = DateTime.now();
    order.paymentAcceptedBy = loggedInUser.name;

    await updateOrder(order, loggedInUser);
  }

  Future<void> updateOrder(OrderItem updatedOrder, User loggedInUser) async {
    await _pocketBase
        .collection('orders')
        .update(updatedOrder.id, body: updatedOrder.toJson());

    notifyListeners();
  }
}

DateTime _startOfDay(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}
