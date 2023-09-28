import 'package:estateease/screens/home/upload_property.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:estateease/utils/showSnackBar.dart';

class PropertyTypes extends StatefulWidget {
  const PropertyTypes({super.key});

  @override
  State<PropertyTypes> createState() => _PropertyTypesState();
}

class _PropertyTypesState extends State<PropertyTypes> {
  int selected = 0;
  List<String> propertyTypes = [
    "Apartment",
    "House",
    "Villa",
    "Hotel",
    "Cottage",
    "Hostel",
    "PG",
    "Flat"
  ];
  Widget customRadio(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: (selected == index) ? kBlue : kGrey),
      ),
      child: Text(
        text,
        style: TextStyle(color: (selected == index) ? kBlue : kGrey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Property Type",
            style: kRalewayBold.copyWith(color: kBlue, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              customRadio("Apartment", 0),
              const SizedBox(
                width: 8,
              ),
              customRadio("House", 1)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              customRadio("Villa", 2),
              const SizedBox(
                width: 8,
              ),
              customRadio("Hotel", 3),
              const SizedBox(
                width: 8,
              ),
              customRadio("Cottage", 4),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 1,
            width: SizeConfig.screenWidth,
            child: Container(decoration: const BoxDecoration(color: kGrey)),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              customRadio("Pg", 6),
              const SizedBox(
                width: 8,
              ),
              customRadio("Flat for Bachelors", 7),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              customRadio("Hostel", 5),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  (selected >= 0 && selected <= 4)
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => UploadProperty(
                              propertyType: propertyTypes[selected],
                            ),
                          ),
                        )
                      : showSnackBar(context, "Dev In Progress");
                },
                icon: const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: kWhite,
                ),
                iconSize: SizeConfig.blockSizeHorizontal! * 15,
                style: IconButton.styleFrom(
                  backgroundColor: kBlue,
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
