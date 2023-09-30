import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/screens/home/update_property.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estateease/models/Users.dart' as MyUser;

class MyProperties extends StatefulWidget {
  const MyProperties({super.key});

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  var userId = FirebaseAuth.instance.currentUser!.uid;
  List<RentProperty> list = [];
  List<MyUser.MyProperty> property = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    fireStoreMethods.getUserProperty(userId).then((value) {
      setState(() {
        list = value[0];
        property = value[1];

      });
    });

    Widget labels(String text, Color color) {
      return Container(
        height: 30,
        decoration: BoxDecoration(
            border: Border.all(
              color: color,
            ),
            color: color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(kBorderRadius20)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: kRalewayBold.copyWith(
                  color: color,
                  fontSize: SizeConfig.blockSizeHorizontal! * 2.5),
            ),
          ),
        ),
      );
    }

    void _openAddUpdateOverlay(
        RentProperty property, MyUser.MyProperty myProperty) {
      showModalBottomSheet(
        backgroundColor: kWhite,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) =>
            UpdateProperty(property: property, myProperty: myProperty),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kPadding20, vertical: kPadding20),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(kBorderRadius10),
                          topRight: Radius.circular(kBorderRadius10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadius10),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 0,
                                offset: const Offset(0, 18),
                                blurRadius: 18,
                                color: kBlack.withOpacity(0.1),
                              ),
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(list[index].thumbnail),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal! * 4.5,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[index].name,
                                style: kRalewayMedium.copyWith(
                                  color: kBlack,
                                  fontSize: SizeConfig.blockSizeHorizontal! * 4,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 0.5,
                              ),
                              Text(
                                '${list[index].price} / ${list[index].per}',
                                style: GoogleFonts.poppins(
                                  color: kBlue,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 2.5,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 0.5,
                              ),
                              Text(
                                list[index].description,
                                style: kRalewayMedium.copyWith(
                                  color: kBlue,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 2.5,
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/icon_bedroom.svg'),
                                      SizedBox(
                                        width: SizeConfig.blockSizeHorizontal! *
                                            0.5,
                                      ),
                                      Text(
                                        '${list[index].bedroom} Bedroom',
                                        style: kRalewayMedium.copyWith(
                                          color: kGrey85,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  2.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: SizeConfig.blockSizeHorizontal! * 1,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/icon_bathroom.svg'),
                                      SizedBox(
                                        width: SizeConfig.blockSizeHorizontal! *
                                            0.5,
                                      ),
                                      Text(
                                        '${list[index].bathroom} Bathroom',
                                        style: kRalewayMedium.copyWith(
                                          color: kGrey85,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  2.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: kBlue.withOpacity(1),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(kBorderRadius10),
                        bottomRight: Radius.circular(kBorderRadius10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        labels(property[index].type,
                            const Color.fromRGBO(116, 185, 33, 1)),
                        const SizedBox(
                          width: 5,
                        ),
                        labels(property[index].category,
                            const Color.fromRGBO(162, 238, 239, 1)),
                        const Spacer(),
                        SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () {
                                _openAddUpdateOverlay(
                                    list[index], property[index]);
                              },
                              child: Text(
                                "EDIT",
                                style: kRalewayBold.copyWith(color: kWhite),
                              ),
                            )),
                        IconButton(
                          onPressed: () {
                            FireStoreMethods().deleteProperty(
                                list[index], property[index], userId);
                            setState(() {});
                            showSnackBar(context, "Property Deleted");
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
