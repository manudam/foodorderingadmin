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
  final DateTime orderDate;
  final PaymentDetails paymentDetails;
  final String notes;
  final String restaurantId;
  final String tableNumber;
  OrderStatus orderStatus;
  String acceptedBy;
  DateTime acceptedDate;

  OrderItem(
      {this.id,
      @required this.total,
      @required this.subTotal,
      @required this.tip,
      @required this.products,
      @required this.orderDate,
      @required this.paymentDetails,
      @required this.restaurantId,
      @required this.orderStatus,
      this.tableNumber,
      this.notes,
      this.acceptedBy,
      this.acceptedDate});

  factory OrderItem.fromMap(String documentId, Map data) {
    return OrderItem(
        id: documentId,
        total: data['total'],
        subTotal: data['subTotal'],
        tip: data['tip'],
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
        products: (data['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  productId: item['id'],
                  price: item['price'],
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
        "orderDate": orderDate,
        "notes": notes,
        "restaurantId": restaurantId,
        "tableNumber": tableNumber,
        "orderStatus": orderStatus.toString(),
        "acceptedBy": acceptedBy,
        "acceptedDate": acceptedDate,
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

enum OrderStatus { AwaitingConfirmation, Accepted }
