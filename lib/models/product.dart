import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  DateTime createdDate;
  String createdBy;

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
      this.isNutFree = false,
      this.createdDate,
      this.createdBy});

  factory Product.fromMap(Map data) {
    return Product(
      id: data['id'] != null ? data['id'] : Uuid().v1(),
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
      createdDate:
          data['createdDate'] != null ? data['createdDate'].toDate() : null,
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "category": category,
        "disabled": disabled,
        "isVegan": isVegan,
        "isVegeterian": isVegeterian,
        "isDairyFree": isDairyFree,
        "isGlutenFree": isGlutenFree,
        "isNutFree": isNutFree,
        "createdDate": createdDate,
        "createdBy": createdBy
      };
}
