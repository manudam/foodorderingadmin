class PaymentDetails {
  String status;
  String paymentMethodId;
  String paymentIntentId;
  String cardHolderName;
  String receiptEmail;
  String confirmationMethod;

  PaymentDetails(
      {this.status,
      this.paymentIntentId,
      this.paymentMethodId,
      this.cardHolderName,
      this.receiptEmail,
      this.confirmationMethod});

  factory PaymentDetails.fromMap(Map data) {
    return PaymentDetails(
      status: data['status'],
      paymentMethodId: data['paymentMethodId'] ?? '',
      paymentIntentId: data['paymentIntentId'] ?? '',
      cardHolderName: data['cardHolderName'] ?? '',
      receiptEmail: data['receiptEmail'] ?? '',
      confirmationMethod: data['confirmationMethod'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'paymentMethodId': paymentMethodId,
        'paymentIntentId': paymentIntentId,
        'cardHolderName': cardHolderName,
        'receiptEmail': receiptEmail,
        'confirmationMethod': confirmationMethod,
      };
}
