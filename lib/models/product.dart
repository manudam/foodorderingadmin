import 'package:flutter/material.dart';

class Product {
  String id;
  final String name;
  final String description;
  final String allegens;
  final String notes;
  final double price;
  final String category;

  Product(
      {@required this.id,
      @required this.name,
      this.description,
      this.allegens,
      this.notes,
      @required this.price,
      @required this.category});

  factory Product.fromMap(String documentId, Map data) {
    return Product(
      id: documentId,
      name: data['name'],
      description: data['description'] ?? '',
      allegens: data['allegens'] ?? '',
      notes: data['notes'] ?? '',
      price: data['price'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "allegens": allegens,
        "notes": notes,
        "price": price,
        "category": category,
      };
}
