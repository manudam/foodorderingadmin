import 'package:flutter/foundation.dart';

import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
