import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:provider/provider.dart';
import 'package:foodorderingadmin/models/product.dart';

class MenuEditScreen extends StatefulWidget {
  static String routeName = 'menuedit';

  @override
  _MenuEditScreenState createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  void saveForm() {}

  @override
  Widget build(BuildContext context) {
    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    final _categoryFocusNode = FocusNode();
    final _form = GlobalKey<FormState>();

    final _categories = {"Drinks", "Pizza"};
    var _selectedCategory;

    var _editedProduct = Product(
      productId: null,
      name: '',
      price: 0,
      description: '',
      category: '',
    );

    var _initValues = {
      'name': '',
      'description': '',
      'price': '',
      'imageUrl': '',
    };
    var _isInit = true;
    var _isLoading = false;

    @override
    void didChangeDependencies() {
      if (_isInit) {
        final productId = ModalRoute.of(context).settings.arguments as String;
        if (productId != null) {
          _editedProduct =
              Provider.of<Menu>(context, listen: false).findById(productId);
          _initValues = {
            'name': _editedProduct.name,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            'imageUrl': '',
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
      super.dispose();
    }

    Future<void> _saveForm() async {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.productId != null) {
        await Provider.of<Menu>(context, listen: false)
            .updateProduct(_editedProduct.productId, _editedProduct);
      } else {
        try {
          await Provider.of<Menu>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }

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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16),
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
                            category: _editedProduct.category,
                            productId: _editedProduct.productId,
                            isFavorite: _editedProduct.isFavorite);
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
                            category: _editedProduct.category,
                            productId: _editedProduct.productId,
                            isFavorite: _editedProduct.isFavorite);
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
                        FocusScope.of(context).requestFocus(_categoryFocusNode);
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
                          category: _editedProduct.category,
                          productId: _editedProduct.productId,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    DropdownButtonFormField(
                        value: _initValues['category'],
                        decoration: InputDecoration(labelText: 'Category'),
                        focusNode: _categoryFocusNode,
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          _selectedCategory = newValue;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            name: _editedProduct.name,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            category: _selectedCategory,
                            productId: _editedProduct.productId,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        })
                  ]),
                ),
              ));
  }
}
