import 'package:estateease/components/chart.dart';
import 'package:estateease/provider/currentLocationProvider.dart';
import 'package:estateease/provider/userPlaceProvider.dart';
import 'package:estateease/screens/components/location_picker.dart';
import 'package:estateease/screens/home/bookmark_property.dart';
import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/screens/home/my_properties.dart';
import 'package:estateease/screens/home/property_types.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:location/location.dart';

double lat = 0;
double lng = 0;
Future<void> _getCurrentLocation() async {
  Location location = Location();

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

  lat = locationData.latitude!;
  lng = locationData.longitude!;
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<ScreenHiddenDrawer> pages = [];

  String? country;
  String? state;
  String? city;
  @override
  void initState() {
    super.initState();

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
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Bookmarked',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        const BookMarkScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Data Analytics',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        Chart(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    country = ref.watch(userPlace).country;
    city = ref.watch(userPlace).city;
    state = ref.watch(userPlace).state;
    _getCurrentLocation().then((value) {
      ref.read(currentLocation).latitude = lat;
      ref.read(currentLocation).longitude = lng;
    });
    SizeConfig().init(context);
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
                  (country != null && city != null && state != null)
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return LocationPicker(
                                  onSelectLocation: () {
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    state!,
                                    style: kRalewayRegular.copyWith(
                                        color: kGrey,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal! *
                                                4),
                                  ),
                                  Text(city!)
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(Icons.location_on)
                            ],
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return LocationPicker(
                                  onSelectLocation: () {
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          },
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
