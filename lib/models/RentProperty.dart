import 'package:estateease/models/PropertyLocation.dart';
import 'package:estateease/models/Users.dart' as User;

class RentProperty {
  String name;
  String description;
  String address;
  String bedroom;
  String bathroom;
  String balcony;
  String price;
  String per;
  String thumbnail;
  List<String> images;
  PropertyLocation location;
  User.User user;

  RentProperty({
    required this.name,
    required this.description,
    required this.address,
    required this.bedroom,
    required this.bathroom,
    required this.balcony,
    required this.price,
    required this.per,
    required this.thumbnail,
    required this.images,
    required this.location,
    required this.user,
  });

  factory RentProperty.fromJson(Map<String, dynamic> json) => RentProperty(
        name: json["name"],
        description: json["description"],
        address: json["address"],
        bedroom: json["bedroom"],
        bathroom: json["bathroom"],
        balcony: json["balcony"],
        price: json["price"],
        per: json["per"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
        location: PropertyLocation.fromJson(json["location"]),
        user: User.User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "address": address,
        "bedroom": bedroom,
        "bathroom": bathroom,
        "balcony": balcony,
        "price": price,
        "per": per,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images.map((x) => x)),
        "location": location.toJson(),
        "user": user.toJson(),
      };
}
