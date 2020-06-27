import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/models/analytics.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDateItem extends StatelessWidget {
  final DayOrderSummary dayOrderSummary;

  OrderDateItem(this.dayOrderSummary);

  @override
  Widget build(BuildContext context) {
    var analytics = Provider.of<Analytics>(context);
    var selected = analytics.selectedOrderDay.orderDate
            .compareTo(dayOrderSummary.orderDate) ==
        0;
    var textColor = selected ? Colors.white : Colors.black;

    return Row(
      children: [
        ChoiceChip(
          selected: selected,
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat("dd-MM-yyyy").format(dayOrderSummary.orderDate),
                style: TextStyle(color: textColor),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${dayOrderSummary.orderCount} orders",
                  style: TextStyle(color: textColor),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "£${dayOrderSummary.total.toStringAsFixed(2)}",
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
          selectedColor: kGreen,
          backgroundColor: Colors.white,
          onSelected: (bool selection) {
            analytics.selectDayOrder(dayOrderSummary);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
