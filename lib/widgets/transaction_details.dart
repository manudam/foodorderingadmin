import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/order_item.dart';
import 'package:foodorderingadmin/models/payment_option.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetails extends StatelessWidget {
  final OrderItem orderItem;

  TransactionDetails(this.orderItem);

  void _launchURL(String paymentIntentId) async {
    //String url = 'https://dashboard.stripe.com/test/payments/$paymentIntentId';
    String url = 'https://dashboard.stripe.com/payments/$paymentIntentId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: [
          Text("Name given: ${orderItem.paymentDetails.name}"),
          Text("Email: ${orderItem.paymentDetails.email}"),
          Text("Order number: ${orderItem.orderNumber.toString()}"),
          if (orderItem.paymentDetails.paymentOption == PaymentOption.Card)
            Wrap(children: [
              Text("Stripe transaction ID: "),
              GestureDetector(
                onTap: () =>
                    _launchURL(orderItem.paymentDetails.paymentIntentId),
                child: Text(orderItem.paymentDetails.paymentIntentId,
                    style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ]),
          Text(
              "Payment Method: ${EnumToString.parse(orderItem.paymentDetails.paymentOption)}"),
          Text("Sub Total: £${orderItem.subTotal.toStringAsFixed(2)}"),
          Text("Small order fee: £${orderItem.fees.toStringAsFixed(2)}"),
          Text("Tip: £${orderItem.tip.toStringAsFixed(2)}"),
          if (orderItem.paymentDetails.paymentOption == PaymentOption.Card ||
              orderItem.paymentAcceptedBy.isNotEmpty)
            Text("Total paid: £${orderItem.total.toStringAsFixed(2)}"),
          if (orderItem.paymentDetails.paymentOption != PaymentOption.Card &&
              orderItem.paymentAcceptedBy.isEmpty)
            Text("Total to pay: £${orderItem.total.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}
