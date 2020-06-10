import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:provider/provider.dart';

import '../screens/account/account.dart';
import '../screens/live_orders_screen.dart';
import '../screens/product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Food Ordering Admin'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text('Administration'),
            leading: Icon(Icons.dashboard),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AdminScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Live Orders'),
            leading: Icon(Icons.speaker_notes),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(LiveOrdersScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Edit Menu'),
            leading: Icon(Icons.restaurant_menu),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
