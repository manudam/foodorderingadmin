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

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.disabled = false,
    this.isVegan = false,
    this.isVegeterian = false,
    this.isDairyFree = false,
    this.isGlutenFree = false,
    this.isNutFree = false,
    DateTime? createdDate,
    this.createdBy = '',
  }) : createdDate = createdDate ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory Product.fromMap(Map data) {
    return Product(
      id: data['id'] ?? Uuid().v1(),
      name: data['name'] ?? '',
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
      createdDate: _asDateTime(data['createdDate']),
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

DateTime? _asDateTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  try {
    return value.toDate();
  } catch (_) {
    return null;
  }
}
