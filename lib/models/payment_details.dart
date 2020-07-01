class PaymentDetails {
  String status;
  String paymentIntentId;
  String cardHolderName;
  String receiptEmail;
  String confirmationMethod;

  PaymentDetails(
      {this.status,
      this.paymentIntentId,
      this.cardHolderName,
      this.receiptEmail,
      this.confirmationMethod});

  factory PaymentDetails.fromMap(Map data) {
    return PaymentDetails(
      status: data['status'],
      paymentIntentId: data['paymentIntentId'] ?? '',
      cardHolderName: data['cardHolderName'] ?? '',
      receiptEmail: data['receiptEmail'] ?? '',
      confirmationMethod: data['confirmationMethod'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'paymentIntentId': paymentIntentId,
        'cardHolderName': cardHolderName,
        'receiptEmail': receiptEmail,
        'confirmationMethod': confirmationMethod,
      };
}
