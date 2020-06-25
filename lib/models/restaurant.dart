class Restaurant {
  String id;
  String name;
  String info;
  List<String> categories = [];

  Restaurant({this.id, this.name, this.info, this.categories});

  factory Restaurant.fromMap(String documentId, Map data) {
    print(data['categories']);

    return Restaurant(
        id: documentId,
        name: data['name'] ?? '',
        info: data['info'] ?? '',
        categories: List.from(data['categories']));
  }

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
