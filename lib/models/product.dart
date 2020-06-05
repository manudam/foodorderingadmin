import 'package:flutter/material.dart';

class Product {
  String id;
  final String name;
  final String description;
  final double price;
  final String category;

  Product({
    @required this.id,
    @required this.name,
    this.description,
    @required this.price,
    @required this.category,
  });
}
