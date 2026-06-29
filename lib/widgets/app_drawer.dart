import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

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
              leading: Icon(Icons.dashboard_outlined),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(DashboardScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt_long_outlined),
              title: Container(
                alignment: Alignment.centerLeft,
                child: badges.Badge(
                  badgeContent: Text(
                    orders.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Text('New Orders'),
                  position: badges.BadgePosition.topEnd(top: -12, end: -25),
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LiveOrdersScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline),
              title: Text('Accepted Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AcceptedOrdersScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_note),
              title: Text('Live Menu Edit'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LiveMenuEditScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive_outlined),
              title: Text('Archived'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ArchiveOrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
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
