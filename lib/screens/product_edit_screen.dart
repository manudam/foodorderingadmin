import 'package:flutter/material.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/products.dart';
import '../models/models.dart';

class ProductEditScreen extends StatefulWidget {
  static String routeName = 'productedit';

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _allegensFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    name: '',
    price: 0,
    description: '',
    category: '',
  );

  var _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'category': '',
    'allegens': '',
    'notes': '',
  };
  var _isInit = true;
  var _loading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'category': _editedProduct.category,
          'allegens': _editedProduct.allegens,
          'notes': _editedProduct.notes,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _categoryFocusNode.dispose();
    _allegensFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    try {
      setState(() {
        _loading = true;
      });
      final loggedInUser =
          Provider.of<Auth>(context, listen: false).loggedInUser;

      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();
      if (_editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct, loggedInUser);
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, loggedInUser);
      }
      Navigator.of(context).pop();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: LoadingScreen(
          inAsyncCall: _loading,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(children: [
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          name: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          allegens: _editedProduct.allegens,
                          notes: _editedProduct.notes,
                          category: _editedProduct.category,
                          id: _editedProduct.id);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          name: _editedProduct.name,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          allegens: _editedProduct.allegens,
                          notes: _editedProduct.notes,
                          category: _editedProduct.category,
                          id: _editedProduct.id);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_allegensFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        name: _editedProduct.name,
                        price: _editedProduct.price,
                        description: value,
                        allegens: _editedProduct.allegens,
                        notes: _editedProduct.notes,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['allegens'],
                    decoration: InputDecoration(labelText: 'Allegens'),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _allegensFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_notesFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        name: _editedProduct.name,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        allegens: value,
                        notes: _editedProduct.notes,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['notes'],
                    decoration: InputDecoration(labelText: 'Notes'),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _notesFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_categoryFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        name: _editedProduct.name,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        allegens: _editedProduct.allegens,
                        notes: value,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['category'],
                    decoration: InputDecoration(labelText: 'Category'),
                    textInputAction: TextInputAction.done,
                    focusNode: _categoryFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a category.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        name: _editedProduct.name,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        allegens: _editedProduct.allegens,
                        notes: _editedProduct.notes,
                        category: value,
                        id: _editedProduct.id,
                      );
                    },
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
