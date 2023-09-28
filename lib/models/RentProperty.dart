import 'package:estateease/models/Users.dart' as User;
import 'package:estateease/models/place.dart';

class RentProperty {
  String id;
  String name;
  String description;

  String bedroom;
  String bathroom;
  String balcony;
  String price;
  String per;
  String thumbnail;
  List<String> images;
  PlaceLocation location;
  AbsoluteAddress absoluteAddress;
  String userId;

  RentProperty({
    required this.id,
    required this.name,
    required this.description,
    required this.bedroom,
    required this.bathroom,
    required this.balcony,
    required this.price,
    required this.per,
    required this.thumbnail,
    required this.images,
    required this.location,
    required this.absoluteAddress,
    required this.userId,
  });

  factory RentProperty.fromJson(Map<String, dynamic> json) => RentProperty(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        bedroom: json["bedroom"],
        bathroom: json["bathroom"],
        balcony: json["balcony"],
        price: json["price"],
        per: json["per"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
        location: PlaceLocation.fromJson(json["location"]),
        absoluteAddress: AbsoluteAddress.fromJson(json["absoluteAddress"]),
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "bedroom": bedroom,
        "bathroom": bathroom,
        "balcony": balcony,
        "price": price,
        "per": per,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images.map((x) => x)),
        "location": location.toJson(),
        "absoluteAddress": absoluteAddress.toJson(),
        "userId": userId,
      };
}
