import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_edit_screen.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class ProductScreen extends StatefulWidget {
  static String routeName = 'menuproduct';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isInit = false;

  @override
  void initState() {
    print("init called");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Provider.of<Products>(context).fetchProducts();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<Products>(context);
    final products = menuData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductEditScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, i) {
          var product = products[i];
          return Column(
            children: [
              ListTile(
                title: Text(product.name),
                subtitle: Text(
                  product.category,
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ProductEditScreen.routeName,
                              arguments: products[i].id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<Products>(context, listen: false)
                              .deleteProduct(products[i].id);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}
