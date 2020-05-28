import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class Menu with ChangeNotifier {
  List<Product> _products = [];
  final _databaseReference = Firestore.instance;
  final _productCollection = "Products";

  List<Product> get items {
    return [..._products];
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.productId == productId);
  }

  Future<void> addProduct(Product productToSave) async {
    var savedProduct =
        await _databaseReference.collection(_productCollection).add({
      'title': productToSave.name,
      'description': productToSave.description,
      'category': productToSave.category,
      'price': productToSave.price,
      'isFavorite': productToSave.isFavorite,
    });

    productToSave.productId = savedProduct.documentID;

    _products.insert(
      0,
      productToSave,
    );

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((prod) => prod.productId == id);
    if (prodIndex >= 0) {
      await _databaseReference
          .collection(_productCollection)
          .document(id)
          .updateData({
        'title': newProduct.name,
        'description': newProduct.description,
        'category': newProduct.category,
        'price': newProduct.price,
        'isFavorite': newProduct.isFavorite,
      });

      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex =
        _products.indexWhere((prod) => prod.productId == id);

    await _databaseReference
        .collection(_productCollection)
        .document(id)
        .delete();

    _products.removeAt(existingProductIndex);
    notifyListeners();
  }
}
