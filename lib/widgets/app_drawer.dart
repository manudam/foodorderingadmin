import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('New Orders'),
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
            ListTile(
              title: Text('Log out'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
