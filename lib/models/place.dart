import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) => PlaceLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
}

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();
}

class AbsoluteAddress {
  String streetAddress;
  String city;
  String state;
  String postalZip;
  String country;

  AbsoluteAddress({
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalZip,
    required this.country,
  });

  factory AbsoluteAddress.fromJson(Map<String, dynamic> json) =>
      AbsoluteAddress(
        streetAddress: json["streetAddress"],
        city: json["city"],
        state: json["state"],
        postalZip: json["postalZip"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "streetAddress": streetAddress,
        "city": city,
        "state": state,
        "postalZip": postalZip,
        "country": country,
      };
}
