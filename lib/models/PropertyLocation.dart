class PropertyLocation {
    String streetAddress;
    String city;
    String state;
    String postalZip;
    String country;
    String latitude;
    String longitude;

    PropertyLocation({
        required this.streetAddress,
        required this.city,
        required this.state,
        required this.postalZip,
        required this.country,
        required this.latitude,
        required this.longitude,
    });

    factory PropertyLocation.fromJson(Map<String, dynamic> json) => PropertyLocation(
        streetAddress: json["streetAddress"],
        city: json["city"],
        state: json["state"],
        postalZip: json["postal_zip"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "streetAddress": streetAddress,
        "city": city,
        "state": state,
        "postal_zip": postalZip,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
    };
}