import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/widgets/transaction_details.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart' as ord;

class AcceptedOrderItem extends StatefulWidget {
  final ord.OrderItem order;

  AcceptedOrderItem(this.order);

  @override
  _AcceptedOrderItemState createState() => _AcceptedOrderItemState();
}

class _AcceptedOrderItemState extends State<AcceptedOrderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Table ${widget.order.tableNumber}",
            style: kBlackTitle,
          ),
          Text(
              'Accepted: ${DateFormat("dd/MM/yyyy HH:mm").format(widget.order.acceptedDate.toLocal())}'),
          SizedBox(
            height: 15,
          ),
          Material(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Order created: ${DateFormat("dd/MM/yyyy HH:mm").format(widget.order.orderDate.toLocal())}"),
                  TransactionDetails(widget.order),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height:
                        (100 + (widget.order.products.length * 10)).toDouble(),
                    child: ListView.builder(
                        itemCount: widget.order.products.length,
                        itemBuilder: (ctx, i) {
                          var product = widget.order.products[i];
                          return Padding(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Text(
                                  "${product.quantity.toString()} ${product.title}",
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
