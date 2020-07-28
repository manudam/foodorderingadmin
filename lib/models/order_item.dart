import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

import 'payment_details.dart';

import 'cart_item.dart';

class OrderItem {
  String id;
  final int orderNumber;
  final double total;
  final double subTotal;
  final double tip;
  final double fees;
  final List<CartItem> products;
  final DateTime orderDate;
  final PaymentDetails paymentDetails;
  final String notes;
  final String restaurantId;
  final String tableNumber;
  OrderStatus orderStatus;
  String acceptedBy;
  DateTime acceptedDate;
  String paymentAcceptedBy;
  DateTime paymentAcceptedDate;

  OrderItem(
      {this.id,
      @required this.orderNumber,
      @required this.total,
      @required this.subTotal,
      @required this.tip,
      @required this.fees,
      @required this.products,
      @required this.orderDate,
      @required this.paymentDetails,
      @required this.restaurantId,
      @required this.orderStatus,
      this.tableNumber,
      this.notes,
      this.acceptedBy,
      this.acceptedDate,
      this.paymentAcceptedBy,
      this.paymentAcceptedDate});

  factory OrderItem.fromMap(String documentId, Map data) {
    return OrderItem(
        id: documentId,
        orderNumber: data['orderNumber'] ?? 0,
        total: data['total'] != null
            ? double.parse(data['total'].toString())
            : 0.00,
        subTotal: data['subTotal'] != null
            ? double.parse(data['subTotal'].toString())
            : 0.00,
        tip: data['tip'] != null ? double.parse(data['tip'].toString()) : 0.00,
        fees:
            data['fees'] != null ? double.parse(data['fees'].toString()) : 0.00,
        orderDate:
            data['orderDate'] != null ? data['orderDate'].toDate() : null,
        orderStatus: data['orderStatus'] != null
            ? EnumToString.fromString(OrderStatus.values, data['orderStatus'])
            : null,
        tableNumber: data['tableNumber'] ?? '',
        notes: data['notes'] ?? '',
        restaurantId: data['restaurantId'] ?? '',
        acceptedBy: data['acceptedBy'] ?? '',
        acceptedDate:
            data['acceptedDate'] != null ? data['acceptedDate'].toDate() : null,
        paymentAcceptedBy: data['paymentAcceptedBy'] ?? '',
        paymentAcceptedDate: data['paymentAcceptedDate'] != null
            ? data['paymentAcceptedDate'].toDate()
            : null,
        products: (data['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  productId: item['id'],
                  price: data['price'] != null
                      ? double.parse(data['price'].toString())
                      : 0.00,
                  quantity: item['quantity'],
                  title: item['title'],
                  notes: item['notes'],
                  category: item['category']),
            )
            .toList(),
        paymentDetails: data["paymentDetails"] != null
            ? PaymentDetails.fromMap(data["paymentDetails"])
            : null);
  }

  Map<String, dynamic> toJson() => {
        "total": total,
        "subTotal": subTotal,
        "tip": tip,
        "fees": fees,
        "orderDate": orderDate,
        "notes": notes,
        "restaurantId": restaurantId,
        "tableNumber": tableNumber,
        "orderStatus": orderStatus.toString(),
        "acceptedBy": acceptedBy,
        "acceptedDate": acceptedDate,
        "paymentAcceptedBy": paymentAcceptedBy,
        "paymentAcceptedDate": paymentAcceptedDate,
        'products': products
            .map((cp) => {
                  'id': cp.productId,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'notes': cp.notes,
                  'category': cp.category,
                })
            .toList(),
        'paymentDetails': paymentDetails.toJson()
      };

  bool get orderLate =>
      DateTime.now().difference(orderDate).inMinutes > 5 ? true : false;

  Map<String, int> categoryItemCount() {
    var categoryList = this.products.map((e) => e.category).toList();
    var categoryItemCount = Map<String, int>();

    categoryList.forEach((element) {
      if (!categoryItemCount.containsKey(element)) {
        categoryItemCount[element] = 1;
      } else {
        categoryItemCount[element] += 1;
      }
    });

    print(categoryItemCount);

    return categoryItemCount;
  }
}

enum OrderStatus {
  AwaitingConfirmation,
  Accepted,
  PaymentAccepted,
  AcceptedAndPaid
}
