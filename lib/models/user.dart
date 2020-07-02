class User {
  String uid;
  String email;
  String name;
  String restaurantId;

  User({this.uid, this.email, this.name, this.restaurantId});

  factory User.fromMap(String documentId, Map data) {
    return User(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "restaurantId": restaurantId,
      };
}
