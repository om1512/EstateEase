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
  List<UserReport> reports;

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
    required this.reports,
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
        reports: List<UserReport>.from(
            json["reports"].map((x) => UserReport.fromJson(x))),
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
        "reports": List<dynamic>.from(reports.map((x) => x)),
      };
}

class UserReport {
  String userId;
  String message;
  String type;

  UserReport({
    required this.userId,
    required this.message,
    required this.type,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) => UserReport(
        userId: json["userId"],
        message: json["message"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "message": message,
        "type": type,
      };
}
