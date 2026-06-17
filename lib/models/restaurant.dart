import 'package:foodorderingadmin/models/address.dart';

class Restaurant {
  final String id;
  final String name;
  final String info;
  final Address address;
  final String stripeAccountId;
  final String titleFont;
  List<String> categories = [];

  Restaurant({
    this.id = '',
    this.name = '',
    this.info = '',
    Address? address,
    this.stripeAccountId = '',
    this.titleFont = '',
    List<String>? categories,
  })  : address = address ?? Address(),
        categories = categories ?? [];

  factory Restaurant.fromMap(String documentId, Map data) {
    return Restaurant(
        id: documentId,
        name: data['name'] ?? '',
        info: data['info'] ?? '',
        stripeAccountId: data['stripeAccountId'] ?? '',
        titleFont: data['titleFont'] ?? '',
        address:
            data['address'] != null ? Address.fromMap(data['address']) : null,
        categories: List<String>.from(data['categories'] ?? []));
  }
}
