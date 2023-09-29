import 'dart:convert';

import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/screens/home/my_properties.dart';
import 'package:estateease/screens/home/property_types.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<ScreenHiddenDrawer> pages = [];
  bool? isLocationEnabled;
  String city = "";
  bool? isPermissionGranted;
  Location location = Location();
  double? lat;
  double? long;
  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    lat = locationData.latitude;
    long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    } else {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyAr1dn7Gm4qQzKjgqocTqTCya1g8CKp7ZY');
      final response = await http.get(url);
      final resData = json.decode(response.body);
      setState(() {
        city = resData['results'][0]['address_components'][2]["long_name"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Home',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Upload',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        const PropertyTypes(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'My Properties',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        const MyProperties(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: pages,
      backgroundColorMenu: kBlue.withOpacity(0.2),
      initPositionSelected: 0,
      backgroundColorAppBar: kBlue,
      disableAppBarDefault: false,
      tittleAppBar: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    city,
                    style: kRalewayMedium.copyWith(
                      color: kWhite,
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '•',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      slidePercent: 50,
    );
  }
}
