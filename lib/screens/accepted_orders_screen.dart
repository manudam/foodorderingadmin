import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodorderingadmin/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import '../providers/orders.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/accepted_order_item.dart';

class AcceptedOrdersScreen extends StatefulWidget {
  static const routeName = "acceptedorders";

  @override
  _AcceptedOrdersScreenScreenState createState() =>
      _AcceptedOrdersScreenScreenState();
}

class _AcceptedOrdersScreenScreenState extends State<AcceptedOrdersScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      var loggedInUser = Provider.of<Auth>(context).loggedInUser;
      Provider.of<Orders>(context).streamAcceptedOrders(loggedInUser);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   Provider.of<Orders>(context, listen: false).unstreamAcceptedOrders();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).acceptedOrders;

    return Scaffold(
      appBar: BaseAppBar(
        title: "Orders Accepted",
        backgroundColor: kLightGreyBackground,
        textColor: Colors.black,
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        color: kLightGreyBackground,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: orders.length,
          itemBuilder: (ctx, i) => AcceptedOrderItem(orders[i]),
        ),
      ),
    );
  }
}
