class Address {
  final String addressLine1;
  final String addressLine2;
  final String town;
  final String county;
  final String postcode;

  Address(
      {this.addressLine1,
      this.addressLine2,
      this.town,
      this.county,
      this.postcode});

  factory Address.fromMap(Map data) {
    return Address(
      addressLine1: data['addressLine1'] ?? '',
      addressLine2: data['addressLine2'] ?? '',
      town: data['town'] ?? '',
      county: data['county'] ?? '',
      postcode: data['postcode'] ?? '',
    );
  }
}
