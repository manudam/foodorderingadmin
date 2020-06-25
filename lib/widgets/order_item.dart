import 'package:flutter/material.dart';
import 'package:foodorderingadmin/helpers/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/order_item.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Future<void> _showMyDialog() async {
    var categoryItemCount = widget.order.categoryItemCount();
    List<Widget> items = [];

    categoryItemCount.forEach((key, value) {
      items.add(Text("$value $key"));
    });

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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
              color: widget.order.orderLate ? Colors.red : Colors.yellow,
              onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Table ${widget.order.tableNumber}",
            style: kWhiteTitle,
          ),
          Text(
            timeago.format(widget.order.dateTime),
            style: widget.order.orderLate ? kRedSubTitle : kWhiteSubTitle,
          ),
          SizedBox(
            height: 15,
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("<${widget.order.products.length} items>"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height:
                        (50 + (widget.order.products.length * 20)).toDouble(),
                    child: ListView.builder(
                        itemCount: widget.order.products.length,
                        itemBuilder: (ctx, i) {
                          var product = widget.order.products[i];
                          return Row(
                            children: [
                              Text(
                                "${product.quantity.toString()} ${product.title}",
                                style: kMediumText,
                              ),
                              Text(
                                product.notes != null || product.notes != ''
                                    ? "(${product.notes})"
                                    : "",
                                style: kGreySubTitle,
                              )
                            ],
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      child: Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      ),
                      color:
                          widget.order.orderLate ? Colors.red : Colors.yellow,
                      onPressed: () {
                        _showMyDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
