import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

class Menu with ChangeNotifier {
  final _databaseReference = Firestore.instance;

  List<Product> _products = [];
  List<String> _categories = [];
  String selectedCategory = '';

  List<Product> get items {
    return [..._products];
  }

  List<String> get categories {
    return [..._categories];
  }

  Future<void> fetchMenu(String restaurantId) async {
    _products.clear();

    var documents = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(restaurantId)
        .collection(DatabaseCollectionNames.products)
        .getDocuments();

    for (var document in documents.documents) {
      print(document.data);
      _products.add(Product.fromMap(document.documentID, document.data));
    }

    populateCategories();

    notifyListeners();
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String category) {
    return items.where((element) => element.category == category).toList();
  }

  void populateCategories() {
    _categories.clear();
    _categories = items.map((e) => e.category).toSet().toList();
    if (_categories.length > 0) {
      selectedCategory = _categories[0];
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(Product productToSave, User loggedInUser) async {
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
