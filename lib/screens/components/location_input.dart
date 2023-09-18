import 'dart:convert';

import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.setLatLong});
  final void Function(double lat, double long) setLatLong;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LocationInput();
  }
}

class _LocationInput extends State<LocationInput> {
  double? lat;
  double? long;
  var gettinglocation = false;
  var pd = "";
  var src = "select current location button";
  var maplocation =
      "https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyAr1dn7Gm4qQzKjgqocTqTCya1g8CKp7ZY";
  void loc() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      gettinglocation = true;
    });
    _locationData = await location.getLocation();
    setState(() {
      gettinglocation = false;
    });
    lat = _locationData.latitude;
    long = _locationData.longitude;
    maplocation =
        "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyAr1dn7Gm4qQzKjgqocTqTCya1g8CKp7ZY";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget cd = (lat != null && long != null)
        ? Image.network(
            maplocation,
            fit: BoxFit.cover,
          )
        : Text(pd);
    if (gettinglocation) {
      cd = CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: kGrey,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius10),
          ),
          alignment: Alignment.center,
          child: cd,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: kGrey,
                ),
                borderRadius: BorderRadius.circular(kBorderRadius10),
              ),
              child: TextButton.icon(
                onPressed: loc,
                icon: const Icon(
                  Icons.location_on,
                  color: kGrey,
                ),
                label: Text(
                  "Current Location",
                  style: kRalewayMedium.copyWith(
                      color: kBlue,
                      fontSize: SizeConfig.blockSizeHorizontal! * 3),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: kGrey,
                ),
                borderRadius: BorderRadius.circular(kBorderRadius10),
              ),
              child: TextButton.icon(
                onPressed: () => {},
                icon: const Icon(
                  Icons.map,
                  color: kGrey,
                ),
                label: Text(
                  "Location On Map",
                  style: kRalewayMedium.copyWith(
                      color: kBlue,
                      fontSize: SizeConfig.blockSizeHorizontal! * 3),
                ),
              ),
            ),
          ],
        ),
        Container(),
      ],
    );
  }
}
