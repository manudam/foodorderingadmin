import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String description;
  double price;
  String category;
  bool disabled;
  bool isVegan;
  bool isVegeterian;
  bool isDairyFree;
  bool isGlutenFree;
  bool isNutFree;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.category,
      this.disabled = false,
      this.isVegan = false,
      this.isVegeterian = false,
      this.isDairyFree = false,
      this.isGlutenFree = false,
      this.isNutFree = false});

  factory Product.fromMap(String documentId, Map data) {
    return Product(
      id: documentId,
      name: data['name'],
      description: data['description'] ?? '',
      price:
          data['price'] != null ? double.parse(data['price'].toString()) : 0.00,
      category: data['category'] ?? '',
      disabled: data['disabled'] ?? false,
      isVegan: data['isVegan'] ?? false,
      isVegeterian: data['isVegeterian'] ?? false,
      isDairyFree: data['isDairyFree'] ?? false,
      isGlutenFree: data['isGlutenFree'] ?? false,
      isNutFree: data['isNutFree'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "category": category,
        "disabled": disabled,
        "isVegan": isVegan,
        "isVegeterian": isVegeterian,
        "isDairyFree": isDairyFree,
        "isGlutenFree": isGlutenFree,
        "isNutFree": isNutFree
      };
}
