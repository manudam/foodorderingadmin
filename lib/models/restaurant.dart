import 'package:foodorderingadmin/models/opening_hour.dart';

class Restaurant {
  String id;
  String name;
  String cuisine;
  bool online;
  List<OpeningHour> openingHours;

  Restaurant(
      {this.id, this.name, this.cuisine, this.online, this.openingHours});

  factory Restaurant.fromMap(String documentId, Map data) {
    return Restaurant(
        id: documentId,
        name: data['name'] ?? '',
        cuisine: data['cuisine'] ?? '',
        online: data['online'] ?? true,
        openingHours: (data['openingHours'] as List<dynamic>)
            .map(
              (item) => OpeningHour.fromMap(item),
            )
            .toList());
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "cuisine": cuisine,
        "online": online,
        'openingHours': openingHours.map((oh) => oh.toJson()).toList()
      };
}
