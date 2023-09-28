import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/screens/home/property_types.dart';
import 'package:estateease/screens/home/upload_property.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<ScreenHiddenDrawer> pages = [];

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
        HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Upload',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        PropertyTypes(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Manage',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        UploadProperty(),
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
                    'Surat',
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
