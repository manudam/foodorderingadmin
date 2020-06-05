class Restaurant {
  String id;
  String name;
  String cuisine;

  Restaurant({this.id, this.name, this.cuisine});

  factory Restaurant.fromMap(String documentId, Map data) {
    return Restaurant(
      id: documentId,
      name: data['name'] ?? '',
      cuisine: data['cuisine'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "cuisine": cuisine,
      };
}
