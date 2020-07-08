import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

class Menu with ChangeNotifier {
  final _databaseReference = Firestore.instance;

  List<Product> _products = [];

  List<Product> get items {
    return [..._products];
  }

  Future<void> fetchMenu(String restaurantId) async {
    _products.clear();

    var documents = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(restaurantId)
        .collection(DatabaseCollectionNames.products)
        .orderBy("createdDate")
        .getDocuments();

    for (var document in documents.documents) {
      print(document.data);
      _products.add(Product.fromMap(document.documentID, document.data));
    }

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

    var savedProduct = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.products)
        .add(productToSave.toJson());

    productToSave.id = savedProduct.documentID;

    _products.insert(
      0,
      productToSave,
    );

    notifyListeners();
  }

  Future<void> updateProduct(
      String id, Product updatedProduct, User loggedInUser) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(loggedInUser.restaurantId)
          .collection(DatabaseCollectionNames.products)
          .document(id)
          .updateData(updatedProduct.toJson());

      _products[prodIndex] = updatedProduct;

      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id, User loggedInUser) async {
    final existingProductIndex = _products.indexWhere((prod) => prod.id == id);

    await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.products)
        .document(id)
        .delete();

    _products.removeAt(existingProductIndex);
    notifyListeners();
  }
}
