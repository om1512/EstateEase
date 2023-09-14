import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String image;
  String name;
  String email;
  String? phone;

  User(
      {required this.image,
      required this.name,
      required this.email,
      this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
      image: json["image"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"]);

  Map<String, dynamic> toJson() =>
      {"image": image, "name": name, "email": email, "phone": phone};
}
