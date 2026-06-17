import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/models.dart';
import 'package:foodorderingadmin/services/pocketbase_service.dart';
import 'package:uuid/uuid.dart';

const String standardMenuDocName = "StandardMenu";

class Menu with ChangeNotifier {
  final _pocketBase = PocketBaseService.client;

  final List<Product> _products = [];
  String? _menuRecordId;

  List<Product> get items {
    return [..._products];
  }

  Future<void> fetchMenu(String restaurantId) async {
    _products.clear();

    var records = await _pocketBase.collection('menus').getFullList(
          filter: "restaurant = '$restaurantId' && key = 'standard'",
          batch: 1,
        );

    if (records.isNotEmpty) {
      _menuRecordId = records.first.id;
      var products = ((records.first.data['products'] as List<dynamic>?) ?? [])
          .map((item) => Product.fromMap(item))
          .toList();

      _products.addAll(products);
    }

    _products.sort((a, b) => a.createdDate.compareTo(b.createdDate));

    notifyListeners();
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String category) {
    return items.where((element) => element.category == category).toList();
  }

  Future<void> addProduct(Product productToSave, User loggedInUser) async {
    productToSave.createdBy = loggedInUser.name;
    productToSave.createdDate = DateTime.now();
    productToSave.id = Uuid().v1();

    _products.add(productToSave);

    await saveProducts(loggedInUser);

    notifyListeners();
  }

  Future<void> updateProduct(
      String id, Product updatedProduct, User loggedInUser) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      _products[prodIndex] = updatedProduct;

      await saveProducts(loggedInUser);

      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id, User loggedInUser) async {
    final existingProductIndex = _products.indexWhere((prod) => prod.id == id);

    _products.removeAt(existingProductIndex);

    await saveProducts(loggedInUser);

    notifyListeners();
  }

  Future<void> saveProducts(User loggedInUser) async {
    final body = {
      "restaurant": loggedInUser.restaurantId,
      "key": "standard",
      "products": _products.map((pr) => pr.toJson()).toList(),
    };

    if (_menuRecordId == null) {
      final record = await _pocketBase.collection('menus').create(body: body);
      _menuRecordId = record.id;
    } else {
      await _pocketBase.collection('menus').update(_menuRecordId!, body: body);
    }
  }
}
