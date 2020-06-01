class User {
  String uid;
  String email;
  String name;
  bool isAdmin;

  User({this.uid, this.email, this.name, this.isAdmin});

  factory User.fromMap(Map data) {
    return User(
      uid: data['uid'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      isAdmin: data['isAdmin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "name": name, 'isAdmin': isAdmin};
}
