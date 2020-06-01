import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/user.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final _databaseReference = Firestore.instance;
  final _collection = "Products";
  Future<User> _userDetails;

  Products(this._userDetails);

  List<Product> get items {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    _products.clear();

    var products =
        await _databaseReference.collection(_collection).getDocuments();

    if (products.documents.isNotEmpty) {
      for (var product in products.documents) {
        _products.add(Product(
            id: product.documentID,
            name: product.data['name'],
            description: product.data['description'],
            isFavorite: product.data['isFavorite'],
            price: product.data['price'],
            category: product.data['category']));
      }
    }

    notifyListeners();
  }

  Product findById(String productId) {
    return items.firstWhere((element) => element.id == productId);
  }

  Future<void> addProduct(Product productToSave) async {
    var savedProduct = await _databaseReference.collection(_collection).add({
      'name': productToSave.name,
      'description': productToSave.description,
      'category': productToSave.category,
      'price': productToSave.price,
      'isFavorite': productToSave.isFavorite,
      'userId': await _userDetails.then((value) => value.uid),
    });

    productToSave.id = savedProduct.documentID;

    _products.insert(
      0,
      productToSave,
    );

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await _databaseReference.collection(_collection).document(id).updateData({
        'name': newProduct.name,
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
    final existingProductIndex = _products.indexWhere((prod) => prod.id == id);

    await _databaseReference.collection(_collection).document(id).delete();

    _products.removeAt(existingProductIndex);
    notifyListeners();
  }
}
