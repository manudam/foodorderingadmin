import 'package:flutter/material.dart';
import 'package:foodorderingadmin/screens/menu_edit_screen.dart';

import 'package:provider/provider.dart';

import '../providers/menu.dart';
import '../widgets/app_drawer.dart';

class MenuScreen extends StatelessWidget {
  static String routeName = 'menu';

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<Menu>(context);
    final products = menuData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MenuEditScreen.routeName, arguments: 0);
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
                  product.price.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
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
