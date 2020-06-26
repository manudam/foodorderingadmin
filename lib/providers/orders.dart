import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/database_collection_names.dart';
import '../models/models.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final _fireStore = Firestore.instance;

  List<OrderItem> get orders {
    return [..._orders.reversed.toList()];
  }

  Future<void> fetchOrders(User loggedinUser) async {
    _orders.clear();

    await for (var snapshot in _fireStore
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedinUser.restaurantId)
        .collection(DatabaseCollectionNames.orders)
        .snapshots()) {
      for (var order in snapshot.documents) {
        var orderId = order.documentID;

        var orderExists =
            _orders.where((element) => element.id == orderId).length > 0;

        if (!orderExists) {
          _orders.add(OrderItem.fromMap(order.documentID, order.data));
        }
      }
      notifyListeners();
    }
  }
}
