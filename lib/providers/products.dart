import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final _databaseReference = Firestore.instance;

  List<Product> get items {
    return [..._products];
  }

  Future<void> fetchProducts(String restaurantId) async {
    _products.clear();

    var documents = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(restaurantId)
        .collection(DatabaseCollectionNames.products)
        .getDocuments();

    for (var document in documents.documents) {
      print(document.data);
      _products.add(Product(
        name: document.data["name"],
        id: document.documentID,
        category: document.data["category"],
        price: document.data["price"],
        description: document.data["description"],
      ));
    }

    notifyListeners();
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.id == productId);
  }

  Future<void> addProduct(Product productToSave, User loggedInUser) async {
    var savedProduct = await _databaseReference
        .collection(DatabaseCollectionNames.restaurants)
        .document(loggedInUser.restaurantId)
        .collection(DatabaseCollectionNames.products)
        .add({
      'name': productToSave.name,
      'description': productToSave.description,
      'category': productToSave.category,
      'price': productToSave.price,
    });

    productToSave.id = savedProduct.documentID;

    _products.insert(
      0,
      productToSave,
    );

    notifyListeners();
  }

  Future<void> updateProduct(
      String id, Product newProduct, User loggedInUser) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await _databaseReference
          .collection(DatabaseCollectionNames.restaurants)
          .document(loggedInUser.restaurantId)
          .collection(DatabaseCollectionNames.products)
          .document(id)
          .updateData({
        'name': newProduct.name,
        'description': newProduct.description,
        'category': newProduct.category,
        'price': newProduct.price,
      });

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
