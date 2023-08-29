import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String image;
  String name;
  String phone;
  String email;

  // User om = User(...); //  // om.toJson();
  User({
    required this.image,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        image: json["image"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "phone": phone,
        "email": email,
      };
}
