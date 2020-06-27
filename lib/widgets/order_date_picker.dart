import 'package:flutter/material.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/menu.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:foodorderingadmin/widgets/order_date_item.dart';
import 'package:provider/provider.dart';

import 'category_item.dart';

class OrderDatePicker extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<OrderDatePicker> {
  @override
  Widget build(BuildContext context) {
    var dayOrderSummaries =
        Provider.of<Analytics>(context, listen: false).orderAnalytics;

    return Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.only(bottom: 10),
        height: 50,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dayOrderSummaries.length,
            itemBuilder: (ctx, i) {
              var dayOrderSummary = dayOrderSummaries[i];
              return OrderDateItem(dayOrderSummary);
            }));
  }
}
