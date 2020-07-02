import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:foodorderingadmin/providers/analytics.dart';
import 'package:foodorderingadmin/providers/auth.dart';
import 'package:foodorderingadmin/providers/orders.dart';
import 'package:foodorderingadmin/widgets/transaction_details.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/order_item.dart' as ord;

class LiveOrderItem extends StatefulWidget {
  final ord.OrderItem order;

  LiveOrderItem(this.order);

  @override
  _LiveOrderItemState createState() => _LiveOrderItemState();
}

class _LiveOrderItemState extends State<LiveOrderItem> {
  Future<void> _showMyDialog() async {
    var categoryItemCount = widget.order.categoryItemCount();
    List<Widget> items = [];

    categoryItemCount.forEach((key, value) {
      items.add(Text("$value $key"));
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Accept table ${widget.order.tableNumber}'s order of ${widget.order.products.length} items?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: items,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              color: widget.order.orderLate ? Colors.red : kYellow,
              onPressed: () async {
                final loggedInUser =
                    Provider.of<Auth>(context, listen: false).loggedInUser;
                await Provider.of<Orders>(context, listen: false)
                    .acceptOrder(widget.order, loggedInUser);
                await Provider.of<Analytics>(context, listen: false)
                    .updateDayOrderAnalytic(widget.order, loggedInUser);
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text('Not Yet', style: TextStyle(color: Colors.white)),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTransactionDetails() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TransactionDetails(widget.order),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String category = "";

    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Table ${widget.order.tableNumber}",
            style: kWhiteTitle,
          ),
          Text(
            timeago.format(widget.order.orderDate),
            style: widget.order.orderLate ? kRedSubTitle : kWhiteSubTitle,
          ),
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
                  Text("<${widget.order.products.length} items>"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height:
                        (50 + (widget.order.products.length * 30)).toDouble(),
                    child: ListView.builder(
                        itemCount: widget.order.products.length,
                        itemBuilder: (ctx, i) {
                          bool newCategory = false;
                          var product = widget.order.products[i];
                          if (product.category != category) {
                            newCategory = true;
                            category = product.category;
                          }
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: newCategory ? 20 : 0),
                            child: Row(
                              children: [
                                Text(
                                  "${product.quantity.toString()} ${product.title}",
                                ),
                                Text(
                                  product.notes.isNotEmpty
                                      ? "(${product.notes})"
                                      : "",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  if (widget.order.notes != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        widget.order.notes,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      child: Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: widget.order.orderLate ? Colors.red : kYellow,
                      onPressed: () {
                        _showMyDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            padding: EdgeInsets.all(7.5),
            child: Text(
              "more details",
              style: kGreenNormalText,
            ),
            onPressed: () {
              _showTransactionDetails();
            },
          )
        ],
      ),
    );
  }
}
