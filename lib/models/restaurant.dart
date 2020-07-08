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
    this.id,
    this.name,
    this.info,
    this.address,
    this.stripeAccountId,
    this.titleFont,
    this.categories,
  });

  factory Restaurant.fromMap(String documentId, Map data) {
    print(data['categories']);

    return Restaurant(
        id: documentId,
        name: data['name'] ?? '',
        info: data['info'] ?? '',
        stripeAccountId: data['stripeAccountId'] ?? '',
        titleFont: data['titleFont'] ?? '',
        address:
            data['address'] != null ? Address.fromMap(data['address']) : null,
        categories: List.from(data['categories']));
  }
}
