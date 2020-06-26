import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/order_item.dart';

class TransactionDetails extends StatelessWidget {
  final OrderItem orderItem;

  TransactionDetails(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: [
          Text("Name given: ${orderItem.paymentDetails.cardHolderName}"),
          Text("Email: ${orderItem.paymentDetails.receiptEmail}"),
          Text("Order ID: ${orderItem.id}"),
          Text(
              "Stripe transaction ID: ${orderItem.paymentDetails.paymentMethodId}"),
          Text("Sub Total: £${orderItem.subTotal.toStringAsFixed(2)}"),
          Text("Tip: £${orderItem.tip.toStringAsFixed(2)}"),
          Text("Total paid: £${orderItem.total.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}
