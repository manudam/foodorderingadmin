import 'package:flutter/material.dart';
import 'package:foodorderingadmin/screens/account/account.dart';
import 'package:foodorderingadmin/screens/orders_screen.dart';
import 'package:foodorderingadmin/screens/product_screen.dart';
import 'package:foodorderingadmin/screens/restaurant_screen.dart';

class AppDrawer extends StatefulWidget {
  static String routeName = '/drawer';

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
            title: Text('Restaurant'),
            leading: Icon(Icons.restaurant),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RestaurantScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Menu'),
            leading: Icon(Icons.restaurant_menu),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.speaker_notes),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Account'),
            leading: Icon(Icons.account_box),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AccountScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
