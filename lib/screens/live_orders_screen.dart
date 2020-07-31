import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:provider/provider.dart';

import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/widgets/custom_app_bar.dart';
import 'package:timer_builder/timer_builder.dart';
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
      Provider.of<Analytics>(context, listen: false)
          .fetchAnalytics(loggedInUser);

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).liveOrders;

    return Scaffold(
      appBar: BaseAppBar(
        title: "New Orders (${orders.length})",
        backgroundColor: kGreyBackground,
        textColor: Colors.white,
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: TimerBuilder.periodic(
        Duration(minutes: 1),
        builder: (context) => Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          color: kGreyBackground,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders.length,
                itemBuilder: (ctx, i) => LiveOrderItem(orders[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
