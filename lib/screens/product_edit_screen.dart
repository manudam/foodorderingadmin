import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/restaurants.dart';
import 'package:foodorderingadmin/providers/userpreferences.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import 'package:foodorderingadmin/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/menu.dart';
import '../models/models.dart';

class ProductEditScreen extends StatefulWidget {
  static String routeName = 'productedit';

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    name: '',
    price: 0,
    description: '',
    category: '',
    isVegan: false,
    isVegeterian: false,
  );

  var _initValues = {
    'name': '',
    'description': '',
    'price': '',
    'category': '',
    'isVegan': false,
    'isVegetarian': false,
  };
  var _isInit = true;
  var _loading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      final menuData = Provider.of<Menu>(context, listen: false);
      if (productId != null) {
        _editedProduct = menuData.findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'category': _editedProduct.category,
          'isVegan': _editedProduct.isVegan,
          'isVegeterian': _editedProduct.isVegeterian,
        };
      }

      if (_initValues['category'].toString().isEmpty)
        _initValues['category'] =
            Provider.of<UserPreferences>(context, listen: false)
                .selectedCategory;
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    try {
      setState(() {
        _loading = true;
      });
      final loggedInUser =
          Provider.of<Auth>(context, listen: false).loggedInUser;

//update tags
      _editedProduct.isVegan = _initValues['isVegan'];
      _editedProduct.isVegeterian = _initValues['isVegetarian'];

      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();

      if (_editedProduct.id != null) {
        Provider.of<Menu>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct, loggedInUser);
      } else {
        Provider.of<Menu>(context, listen: false)
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
    var categories =
        Provider.of<Restaurants>(context, listen: false).restaurant.categories;

    return Scaffold(
        appBar: BaseAppBar(
          title: _initValues["name"] != '' ? _initValues["name"] : "Add Item",
          backgroundColor: Colors.white,
          textColor: Colors.black,
          appBar: AppBar(),
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
                  DropdownButtonFormField(
                    isExpanded: false,
                    decoration: InputDecoration(labelText: 'Category'),
                    items: categories
                        ?.map((item) => DropdownMenuItem(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Text(item),
                              ),
                              value: item,
                            ))
                        ?.toList(),
                    value: _initValues['category'],
                    onSaved: (value) {
                      _editedProduct.category = value;
                    },
                    onChanged: (value) {
                      FocusScope.of(context).requestFocus(_nameFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please select a category.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['name'],
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct.name = value;
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
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct.description = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
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
                      _editedProduct.price = double.parse(value);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tags",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 120,
                    child: ListView(
                      children: [
                        CheckboxListTile(
                          value: _initValues["isVegeterian"] ?? false,
                          title: Text("V"),
                          onChanged: (value) {
                            setState(() {
                              _initValues["isVegeterian"] = value;
                            });
                          },
                        ),
                        CheckboxListTile(
                          value: _initValues["isVegan"] ?? false,
                          title: Text("VG"),
                          onChanged: (value) {
                            setState(() {
                              _initValues["isVegan"] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: kYellow,
                        onPressed: () {
                          _saveForm();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ]),
              ),
            ),
          ),
        ));
  }
}
