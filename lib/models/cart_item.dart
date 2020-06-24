import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String title;
  int quantity;
  final double price;
  String notes;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    this.notes,
  });
}
