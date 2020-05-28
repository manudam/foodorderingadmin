import 'package:flutter/material.dart';
import 'package:foodorderingadmin/widgets/app_drawer.dart';

class RestaurantScreen extends StatelessWidget {
  static const routeName = "/restaurant";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant'),
      ),
      drawer: AppDrawer(),
    );
  }
}
