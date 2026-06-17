import 'package:enum_to_string/enum_to_string.dart';

import 'payment_details.dart';
import 'payment_option.dart';

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
  DateTime? acceptedDate;
  String paymentAcceptedBy;
  DateTime? paymentAcceptedDate;

  OrderItem({
    this.id = '',
    required this.orderNumber,
    required this.total,
    required this.subTotal,
    required this.tip,
    required this.fees,
    required this.products,
    required this.orderDate,
    required this.paymentDetails,
    required this.restaurantId,
    required this.orderStatus,
    this.tableNumber = '',
    this.notes = '',
    this.acceptedBy = '',
    this.acceptedDate,
    this.paymentAcceptedBy = '',
    this.paymentAcceptedDate,
  });

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
        orderDate: _asDateTime(data['orderDate']),
        orderStatus: _orderStatusFromString(data['orderStatus']),
        tableNumber: data['tableNumber'] ?? '',
        notes: data['notes'] ?? '',
        restaurantId: data['restaurantId'] ?? '',
        acceptedBy: data['acceptedBy'] ?? '',
        acceptedDate: _asDateTime(data['acceptedDate']),
        paymentAcceptedBy: data['paymentAcceptedBy'] ?? '',
        paymentAcceptedDate: _asDateTime(data['paymentAcceptedDate']),
        products: ((data['products'] as List<dynamic>?) ?? [])
            .map(
              (item) => CartItem(
                  productId: item['id'] ?? '',
                  price: item['price'] != null
                      ? double.parse(item['price'].toString())
                      : 0.00,
                  quantity: (item['quantity'] as num?)?.toInt() ?? 0,
                  title: item['title'] ?? '',
                  notes: item['notes'] ?? '',
                  category: item['category'] ?? ''),
            )
            .toList(),
        paymentDetails: data["paymentDetails"] != null
            ? PaymentDetails.fromMap(data["paymentDetails"])
            : PaymentDetails(
                paymentOption: PaymentOption.None,
                name: '',
                email: '',
              ));
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
        "orderStatus": _orderStatusToStorage(orderStatus),
        "acceptedBy": acceptedBy,
        "acceptedDate": acceptedDate?.toIso8601String(),
        "paymentAcceptedBy": paymentAcceptedBy,
        "paymentAcceptedDate": paymentAcceptedDate?.toIso8601String(),
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
    var categoryList = products.map((e) => e.category).toList();
    var categoryItemCount = <String, int>{};

    for (var element in categoryList) {
      if (!categoryItemCount.containsKey(element)) {
        categoryItemCount[element] = 1;
      } else {
        categoryItemCount[element] = (categoryItemCount[element] ?? 0) + 1;
      }
    }

    return categoryItemCount;
  }
}

enum OrderStatus {
  AwaitingConfirmation,
  Accepted,
  PaymentAccepted,
  AcceptedAndPaid
}

DateTime _asDateTime(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  try {
    return value.toDate();
  } catch (_) {
    return DateTime.now();
  }
}

OrderStatus _orderStatusFromString(dynamic value) {
  final raw = value?.toString() ?? '';
  return EnumToString.fromString(OrderStatus.values, raw) ??
      EnumToString.fromString(
        OrderStatus.values,
        raw
            .replaceAll('awaitingConfirmation', 'AwaitingConfirmation')
            .replaceAll('paymentAccepted', 'PaymentAccepted')
            .replaceAll('acceptedAndPaid', 'AcceptedAndPaid')
            .replaceAll('accepted', 'Accepted'),
      ) ??
      OrderStatus.AwaitingConfirmation;
}

String _orderStatusToStorage(OrderStatus status) {
  switch (status) {
    case OrderStatus.AwaitingConfirmation:
      return 'awaitingConfirmation';
    case OrderStatus.Accepted:
      return 'accepted';
    case OrderStatus.PaymentAccepted:
      return 'paymentAccepted';
    case OrderStatus.AcceptedAndPaid:
      return 'acceptedAndPaid';
  }
}
