import 'package:flutter/material.dart';
import 'package:foodorderingadmin/screens/menu_screen.dart';
import 'package:foodorderingadmin/screens/orders_screen.dart';
import 'package:foodorderingadmin/screens/restaurant_screen.dart';

class AppDrawer extends StatelessWidget {
  static String routeName = '/drawer';

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
              Navigator.of(context).pushReplacementNamed(MenuScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.speaker_notes),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
