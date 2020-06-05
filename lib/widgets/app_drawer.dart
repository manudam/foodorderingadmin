import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/account/account.dart';
import '../screens/live_orders_screen.dart';
import '../screens/product_screen.dart';

class AppDrawer extends StatefulWidget {
  static String routeName = '/drawer';

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isInit = false;

  @override
  void didChangeDependencies() async {
    if (!_isInit) {
      await Provider.of<Auth>(context).fetchUserDetails();

      _isInit = true;
    }
    super.didChangeDependencies();
  }

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
            title: Text('Edit Menu'),
            leading: Icon(Icons.restaurant_menu),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductScreen.routeName);
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
