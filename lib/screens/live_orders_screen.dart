import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class LiveOrdersScreen extends StatefulWidget {
  static const routeName = "liveorders";

  @override
  _LiveOrdersScreenScreenState createState() => _LiveOrdersScreenScreenState();
}

class _LiveOrdersScreenScreenState extends State<LiveOrdersScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      var loggedInUser = Provider.of<Auth>(context).loggedInUser;
      Provider.of<Orders>(context).fetchOrders(loggedInUser);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => OrderItem(orders[i]),
      ),
    );
  }
}
