class User {
  String uid;
  String email;
  String name;
  String restaurantId;

  User({this.uid, this.email, this.name, this.restaurantId});

  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "restaurantId": restaurantId,
      };
}
