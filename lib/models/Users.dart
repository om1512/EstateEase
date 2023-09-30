import 'dart:convert';

import 'package:flutter/material.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String image;
  String name;
  String email;
  String phone;
  List<MyProperty> myProperties;
  User(
      {required this.image,
      required this.name,
      required this.email,
      required this.phone,
      required this.myProperties});

  factory User.fromJson(Map<String, dynamic> json) => User(
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        myProperties: List<MyProperty>.from(
            json["myProperties"].map((x) => MyProperty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "myProperties": List<dynamic>.from(myProperties.map((x) => x.toJson())),
      };
}

class CurrentLocation {
  CurrentLocation({required this.latitude, required this.longitude});
  double latitude;
  double longitude;
}

class MyProperty {
  String type;
  String category;
  String id;

  MyProperty({
    required this.type,
    required this.category,
    required this.id,
  });

  factory MyProperty.fromJson(Map<String, dynamic> json) => MyProperty(
        type: json["type"],
        category: json["category"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "category": category,
        "id": id,
      };
}
