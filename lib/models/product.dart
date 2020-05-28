import 'package:flutter/material.dart';

class Product {
  String productId;
  final String name;
  final String description;
  final double price;
  final String category;
  bool isFavorite;

  Product({
    @required this.productId,
    @required this.name,
    this.description,
    @required this.price,
    @required this.category,
    this.isFavorite,
  });
}
