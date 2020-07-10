import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/payment_option.dart';

class PaymentDetails {
  PaymentOption paymentOption;
  String status;
  String paymentIntentId;
  String name;
  String email;
  String confirmationMethod;

  PaymentDetails({
    @required this.paymentOption,
    this.status,
    this.paymentIntentId,
    @required this.name,
    @required this.email,
    this.confirmationMethod,
  });

  factory PaymentDetails.fromMap(Map data) {
    return PaymentDetails(
      paymentOption: data['paymentOption'] != null
          ? EnumToString.fromString(PaymentOption.values, data['paymentOption'])
          : null,
      status: data['status'],
      paymentIntentId: data['paymentIntentId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      confirmationMethod: data['confirmationMethod'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'paymentOption': paymentOption.toString(),
        'status': status,
        'paymentIntentId': paymentIntentId,
        'name': name,
        'email': email,
        'confirmationMethod': confirmationMethod,
      };
}
