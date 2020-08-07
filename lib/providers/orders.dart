import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingadmin/models/payment_option.dart';

import '../helpers/database_collection_names.dart';
import '../models/models.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _liveOrders = [];
  List<OrderItem> _acceptedOrders = [];
  final _fireStore = Firestore.instance;

  StreamSubscription<QuerySnapshot> _liveOrdersListerer;
  StreamSubscription<QuerySnapshot> _acceptedOrdersListerer;

  List<OrderItem> get liveOrders {
    return [..._liveOrders.toList()];
  }

  List<OrderItem> get acceptedOrders {
    return [..._acceptedOrders.toList()];
  }

  Future<void> streamLiveOrders(User loggedinUser) async {
    _liveOrders.clear();

    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _liveOrdersListerer = _fireStore
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedinUser.restaurantId)
        .collection(DatabaseCollectionNames.orders)
        .where("orderDate", isGreaterThanOrEqualTo: today)
        .snapshots()
        .listen((orders) {
      for (var order in orders.documents) {
        var orderId = order.documentID;

        var orderExists =
            _liveOrders.where((element) => element.id == orderId).length > 0;

        if (!orderExists) {
          if (order.data['orderStatus'] !=
              EnumToString.parse(OrderStatus.AcceptedAndPaid)) {
            _liveOrders.add(OrderItem.fromMap(order.documentID, order.data));
          }
        } else {
          var existingOrder =
              _liveOrders.where((element) => element.id == orderId).toList()[0];

          if (order.data['orderStatus'] ==
              EnumToString.parse(OrderStatus.AcceptedAndPaid)) {
            _liveOrders.remove(existingOrder);
          } else {
            existingOrder = OrderItem.fromMap(order.documentID, order.data);
          }
        }
      }
      notifyListeners();
    });
  }

  void unstreamLiveOrders() {
    if (_liveOrdersListerer != null) {
      _liveOrdersListerer.cancel();
      _liveOrdersListerer = null;
    }
  }

  Future<void> streamAcceptedOrders(User loggedinUser) async {
    _acceptedOrders.clear();

    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _acceptedOrdersListerer = _fireStore
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedinUser.restaurantId)
        .collection(DatabaseCollectionNames.orders)
        .where("orderStatus",
            isEqualTo: EnumToString.parse(OrderStatus.AcceptedAndPaid))
        .where("acceptedDate", isGreaterThanOrEqualTo: today)
        .snapshots()
        .listen((orders) {
      for (var order in orders.documents) {
        var orderId = order.documentID;

        var orderExists =
            _acceptedOrders.where((element) => element.id == orderId).length >
                0;

        if (!orderExists) {
          _acceptedOrders.add(OrderItem.fromMap(order.documentID, order.data));
        }
      }
      notifyListeners();
    });
  }

  void unstreamAcceptedOrders() {
    if (_acceptedOrdersListerer != null) {
      _acceptedOrdersListerer.cancel();
      _acceptedOrdersListerer = null;
    }
  }

  Future<List<OrderItem>> fetchArchivedOrders(
      DateTime orderDate, User loggedinUser) async {
    var queryDate = DateTime(orderDate.year, orderDate.month, orderDate.day);
    List<OrderItem> archivedOrders = [];
    print(queryDate);

    var documents = await _fireStore
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedinUser.restaurantId)
        .collection(DatabaseCollectionNames.orders)
        .where("orderStatus",
            isEqualTo: EnumToString.parse(OrderStatus.AcceptedAndPaid))
        .where("acceptedDate", isGreaterThanOrEqualTo: queryDate)
        .where("acceptedDate", isLessThan: queryDate.add(Duration(days: 1)))
        .getDocuments();

    print(documents.documents.length);

    for (var order in documents.documents) {
      archivedOrders.add(OrderItem.fromMap(order.documentID, order.data));
    }

    return archivedOrders;
  }

  Future<void> acceptOrder(OrderItem order, User loggedInUser) async {
    print(order.id);
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
    print(updatedOrder.id);

    await _fireStore
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.orders)
        .document(updatedOrder.id)
        .updateData(updatedOrder.toJson());

    notifyListeners();
  }
}
