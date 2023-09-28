import 'package:estateease/models/RentProperty.dart';
import 'package:flutter/material.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:estateease/screens/home/property_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = [
    "House",
    "Apartment",
    "Hotel",
    "Villa",
    "Cottage",
    // pg and hostels
  ];

  String uuid = Uuid().v4(); // Generate a random UUID
  int current = 0;



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<RentProperty> list = [];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: kRalewayRegular.copyWith(
                          color: kBlack,
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                        ),
                        controller: TextEditingController(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: kPadding16,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                              kPadding8,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/icon_search.svg',
                            ),
                          ),
                          hintText: 'Search address, or near you',
                          border: kInputBorder,
                          errorBorder: kInputBorder,
                          disabledBorder: kInputBorder,
                          focusedBorder: kInputBorder,
                          enabledBorder: kInputBorder,
                          hintStyle: kRalewayRegular.copyWith(
                            color: kGrey85,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                          filled: true,
                          fillColor: kWhiteF7,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                    Container(
                      height: 49,
                      width: 49,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius10),
                        gradient: kLinearGradientBlue,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/icon_filter.svg',
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              SizedBox(
                width: double.infinity,
                height: 34,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? kPadding20 : 12,
                          right:
                              index == categories.length - 1 ? kPadding20 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kPadding16,
                        ),
                        height: 34,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              offset: const Offset(0, 18),
                              blurRadius: 18,
                              color: current == index
                                  ? kBlue.withOpacity(0.1)
                                  : kBlue.withOpacity(0),
                            )
                          ],
                          gradient: current == index
                              ? kLinearGradientBlue
                              : kLinearGradientWhite,
                          borderRadius: BorderRadius.circular(
                            kBorderRadius10,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: kRalewayMedium.copyWith(
                              color: current == index ? kWhite : kGrey85,
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Near from you',
                      style: kRalewayMedium.copyWith(
                        color: kBlack,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                    Text(
                      'See more',
                      style: kRalewayRegular.copyWith(
                        color: kGrey85,
                        fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              SizedBox(
                height: 272,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetail(property: list[index]),
                            ),
                          )),
                      child: Container(
                        height: 272,
                        width: 222,
                        margin: EdgeInsets.only(
                          left: kPadding20,
                          right: index == list.length - 1 ? kPadding20 : 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            kBorderRadius20,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              offset: const Offset(0, 18),
                              blurRadius: 18,
                              color: kBlack.withOpacity(0.1),
                            )
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(list[index].thumbnail),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 136,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(kBorderRadius20),
                                    bottomRight:
                                        Radius.circular(kBorderRadius20),
                                  ),
                                  gradient: kLinearGradientBlack,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding16,
                                  vertical: kPadding20,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              kBorderRadius20,
                                            ),
                                            color: kBlack.withOpacity(
                                              0.24,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kPadding8,
                                            vertical: kPadding4,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/icon_pinpoint.svg',
                                              ),
                                              const SizedBox(
                                                width: kPadding4,
                                              ),
                                              Text(
                                                '1.8 km',
                                                style: kRalewayRegular.copyWith(
                                                  color: kWhite,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      2.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index].name,
                                          style: kRalewayMedium.copyWith(
                                            color: kWhite,
                                            fontSize: SizeConfig
                                                    .blockSizeHorizontal! *
                                                4,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical! *
                                                  0.5,
                                        ),
                                        Text(
                                          list[index].location.address,
                                          style: kRalewayRegular.copyWith(
                                            color: kWhite,
                                            fontSize: SizeConfig
                                                    .blockSizeHorizontal! *
                                                2.5,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best for you',
                      style: kRalewayMedium.copyWith(
                        color: kBlack,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                    Text(
                      'See more',
                      style: kRalewayRegular.copyWith(
                        color: kGrey85,
                        fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding20,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.only(
                        bottom: kPadding24,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
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
                          ))
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
