import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).liveOrders;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Container(
                alignment: Alignment.centerLeft,
                child: Badge(
                  badgeContent: Text(
                    orders.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Text('New Orders'),
                  position: BadgePosition.topRight(right: -25),
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LiveOrdersScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Accepted Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AcceptedOrdersScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Live Menu Edit'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LiveMenuEditScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Archived'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ArchiveOrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).signOut();
                Navigator.of(context)
                    .pushReplacementNamed(SigninScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
