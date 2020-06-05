import 'package:flutter/material.dart';
import 'package:foodorderingadmin/widgets/app_drawer.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = "admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      drawer: AppDrawer(),
    );
  }
}
