import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';

class LocationHelper {
  static String generateLocationPreviewImage({
    required double lat,
    required double lng,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyAr1dn7Gm4qQzKjgqocTqTCya1g8CKp7ZY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url as Uri);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }

  static Future<String> getCity(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyAr1dn7Gm4qQzKjgqocTqTCya1g8CKp7ZY');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    return resData['results'][0]['address_components'][2]["long_name"];
  }
}
