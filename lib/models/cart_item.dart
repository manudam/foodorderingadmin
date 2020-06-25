import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String title;
  int quantity;
  final double price;
  String notes;
  String category;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.category,
    this.notes,
  });
}
