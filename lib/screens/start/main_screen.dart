import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
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
            name: 'Profile',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        HomePage(),
      )
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
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Location',
                    style: kRalewayRegular.copyWith(
                      color: kGrey83,
                      fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
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
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 0.3,
              ),
              Text(
                'Surat',
                style: kRalewayMedium.copyWith(
                  color: kWhite,
                  fontSize: SizeConfig.blockSizeHorizontal! * 6,
                ),
              ),
            ],
          ),
        ),
      ),
      slidePercent: 50,
    );
  }
}
