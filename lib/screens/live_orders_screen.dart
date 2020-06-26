import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import '../providers/orders.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/live_order_item.dart';

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
      Provider.of<Orders>(context).streamLiveOrders(loggedInUser);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   Provider.of<Orders>(context, listen: false).unstreamLiveOrders();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).liveOrders;

    return Scaffold(
      appBar: BaseAppBar(
        title: "Orders (${orders.length})",
        backgroundColor: kGreyBackground,
        textColor: Colors.white,
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: kGreyBackground,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: orders.length,
          itemBuilder: (ctx, i) => LiveOrderItem(orders[i]),
        ),
      ),
    );
  }
}
