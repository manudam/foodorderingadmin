import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

const String standardMenuDocName = "StandardMenu";

class Menu with ChangeNotifier {
  final _databaseReference = Firestore.instance;

  List<Product> _products = [];

  List<Product> get items {
    return [..._products];
  }

  Future<void> fetchMenu(String restaurantId) async {
    _products.clear();

    var document = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(restaurantId)
        .collection(DatabaseCollectionNames.menu)
        .document(standardMenuDocName)
        .get();

    print(document.data);

    var products = (document.data['products'] as List<dynamic>)
        .map((item) => Product.fromMap(item))
        .toList();

    _products.addAll(products);

    _products.sort((a, b) => a.createdDate != null && b.createdDate != null
        ? a.createdDate.compareTo(b.createdDate)
        : 0);

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
    await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.menu)
        .document(standardMenuDocName)
        .setData({"products": _products.map((pr) => pr.toJson()).toList()},
            merge: true);
  }
}
