import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:foodorderingadmin/widgets/archived_order_item.dart';
import 'package:provider/provider.dart';

class ArchivedOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectedOrderDay = Provider.of<Analytics>(context).selectedOrderDay;
    var loggedInUser = Provider.of<Auth>(context).loggedInUser;
    var orderData = Provider.of<Orders>(context, listen: false);

    return FutureBuilder(
        future: orderData.fetchArchivedOrders(
            selectedOrderDay.orderDate, loggedInUser),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var orders = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orders.length,
              itemBuilder: (ctx, i) => ArchivedOrderItem(orders[i]),
            );
          }
          return Container();
        });
  }
}
