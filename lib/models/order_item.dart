import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'payment_details.dart';

import 'cart_item.dart';

class OrderItem {
  String id;
  final double total;
  final double subTotal;
  final double tip;
  final List<CartItem> products;
  final DateTime dateTime;
  final PaymentDetails paymentDetails;
  final String notes;
  final String restaurantId;
  final OrderStatus orderStatus;
  final String tableNumber;

  OrderItem(
      {this.id,
      @required this.total,
      @required this.subTotal,
      @required this.tip,
      @required this.products,
      @required this.dateTime,
      @required this.paymentDetails,
      @required this.restaurantId,
      @required this.orderStatus,
      this.tableNumber,
      this.notes});

  factory OrderItem.fromMap(String documentId, Map data) {
    return OrderItem(
        id: documentId,
        total: data['total'],
        subTotal: data['subTotal'],
        tip: data['tip'],
        dateTime: DateTime.parse(data['dateTime']),
        orderStatus: EnumToString.fromString(
            OrderStatus.values, data['orderStatus'] ?? ''),
        tableNumber: data['tableNumber'] ?? '',
        notes: data['notes'] ?? '',
        restaurantId: data['restaurantId'] ?? '',
        products: (data['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  productId: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                  notes: item['notes']),
            )
            .toList(),
        paymentDetails: PaymentDetails.fromMap(data["paymentDetails"]));
  }

  Map<String, dynamic> toJson() => {
        "total": total,
        "subTotal": subTotal,
        "tip": tip,
        "dateTime": dateTime.toIso8601String(),
        "notes": notes,
        "restaurantId": restaurantId,
        "orderStatus": orderStatus.toString(),
        "tableNumber": tableNumber,
        'products': products
            .map((cp) => {
                  'id': cp.productId,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'notes': cp.notes,
                })
            .toList(),
        'paymentDetails': paymentDetails.toJson()
      };
}

enum OrderStatus { AwaitingConfirmation, Completed }
