import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/provider/currentLocationProvider.dart';
import 'package:estateease/provider/userPlaceProvider.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/distance_finder.dart';
import 'package:flutter/material.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:estateease/screens/home/property_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<String> categories = [
    "House",
    "Apartment",
    "Hotel",
    "Villa",
    "Cottage",
    // pg and hostels
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static int refreshNum = 10; // number that changes when refreshed
  Stream<int> counterStream =
      Stream<int>.periodic(const Duration(seconds: 1), (x) => refreshNum);

  ScrollController? _scrollController;

  String uuid = Uuid().v4(); // Generate a random UUID
  int current = 0;
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<RentProperty> list = [];
    String city = ref.watch(userPlace).city;
    var fPath = FieldPath(["absoluteAddress", "city"]);
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          backgroundColor: kBlue,
          key: _refreshIndicatorKey, // key if you want to add
          onRefresh: _handleRefresh,
          child: StreamBuilder<int>(
              stream: counterStream,
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kPadding24,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: kPadding20,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextField(
                      //           style: kRalewayRegular.copyWith(
                      //             color: kBlack,
                      //             fontSize: SizeConfig.blockSizeHorizontal! * 3,
                      //           ),
                      //           controller: TextEditingController(),
                      //           decoration: InputDecoration(
                      //             contentPadding: const EdgeInsets.symmetric(
                      //               horizontal: kPadding16,
                      //             ),
                      //             prefixIcon: Padding(
                      //               padding: const EdgeInsets.all(
                      //                 kPadding8,
                      //               ),
                      //               child: SvgPicture.asset(
                      //                 'assets/icons/icon_search.svg',
                      //               ),
                      //             ),
                      //             hintText: 'Search address, or near you',
                      //             border: kInputBorder,
                      //             errorBorder: kInputBorder,
                      //             disabledBorder: kInputBorder,
                      //             focusedBorder: kInputBorder,
                      //             enabledBorder: kInputBorder,
                      //             hintStyle: kRalewayRegular.copyWith(
                      //               color: kGrey85,
                      //               fontSize:
                      //                   SizeConfig.blockSizeHorizontal! * 3,
                      //             ),
                      //             filled: true,
                      //             fillColor: kWhiteF7,
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: SizeConfig.blockSizeHorizontal! * 4,
                      //       ),
                      //       Container(
                      //         height: 49,
                      //         width: 49,
                      //         padding: const EdgeInsets.all(12),
                      //         decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.circular(kBorderRadius10),
                      //           gradient: kLinearGradientBlue,
                      //         ),
                      //         child: SvgPicture.asset(
                      //           'assets/icons/icon_filter.svg',
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: kPadding24,
                      // ),
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
                                  right: index == categories.length - 1
                                      ? kPadding20
                                      : 0,
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
                                      color:
                                          current == index ? kWhite : kGrey85,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 3.5,
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
                              'Places in ${city}',
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
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Properties")
                              .doc("Everyone")
                              .collection(categories[current])
                              .where(fPath, isEqualTo: ref.read(userPlace).city)
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<GestureDetector> propertyWidgets = [];
                            if (snapshot.hasData) {
                              final properties =
                                  snapshot.data?.docs.reversed.toList();
                              for (var property in properties!) {
                                final propertyWidget = GestureDetector(
                                  onTap: (() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PropertyDetail(
                                            property: RentProperty.fromJson(
                                                property.data()
                                                    as Map<String, dynamic>),
                                          ),
                                        ),
                                      )),
                                  child: Container(
                                    height: 272,
                                    width: 222,
                                    margin: const EdgeInsets.only(
                                      left: kPadding20,
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
                                        image:
                                            NetworkImage(property["thumbnail"]),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: 136,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                    kBorderRadius20),
                                                bottomRight: Radius.circular(
                                                    kBorderRadius20),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          kBorderRadius20,
                                                        ),
                                                        color:
                                                            kBlack.withOpacity(
                                                          0.24,
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
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
                                                              "${distance(ref.read(currentLocation).latitude, ref.read(currentLocation).longitude, property['location']["latitude"], property['location']["longitude"])} KM",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .blockSizeHorizontal! *
                                                                          2.5,
                                                                  color:
                                                                      kWhite)),
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
                                                      property['name'],
                                                      style: kRalewayMedium
                                                          .copyWith(
                                                        color: kWhite,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal! *
                                                            4,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .blockSizeVertical! *
                                                          0.5,
                                                    ),
                                                    Text(
                                                      property[
                                                              'absoluteAddress']
                                                          ['streetAddress'],
                                                      style: kRalewayRegular
                                                          .copyWith(
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

                                propertyWidgets.add(propertyWidget);
                              }
                            }
                            return Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(right: kPadding20),
                                children: propertyWidgets,
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
                              'Top rated places',
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
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Properties")
                                .doc("Everyone")
                                .collection(categories[current])
                                .where(fPath,
                                    isNotEqualTo: ref.read(userPlace).city)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<GestureDetector> propertyWidgets = [];
                              if (snapshot.hasData) {
                                final properties =
                                    snapshot.data?.docs.reversed.toList();
                                for (var property in properties!) {
                                  final propertyWidget = GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PropertyDetail(
                                              property: RentProperty.fromJson(
                                                  property.data()
                                                      as Map<String, dynamic>)),
                                        ),
                                      );
                                    },
                                    child: Container(
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
                                                  BorderRadius.circular(
                                                      kBorderRadius10),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 18),
                                                  blurRadius: 18,
                                                  color:
                                                      kBlack.withOpacity(0.1),
                                                ),
                                              ],
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    property["thumbnail"]),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig
                                                    .blockSizeHorizontal! *
                                                4.5,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                property["name"],
                                                style: kRalewayMedium.copyWith(
                                                  color: kBlack,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      4,
                                                ),
                                              ),
                                              SizedBox(
                                                height: SizeConfig
                                                        .blockSizeVertical! *
                                                    0.5,
                                              ),
                                              Text(
                                                '${property["price"]} / ${property["per"]}',
                                                style: GoogleFonts.poppins(
                                                  color: kBlue,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      2.5,
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
                                                        width: SizeConfig
                                                                .blockSizeHorizontal! *
                                                            0.5,
                                                      ),
                                                      Text(
                                                        '${property["bedroom"]} Bedroom',
                                                        style: kRalewayMedium
                                                            .copyWith(
                                                          color: kGrey85,
                                                          fontSize: SizeConfig
                                                                  .blockSizeHorizontal! *
                                                              2.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal! *
                                                        1,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/icon_bathroom.svg'),
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal! *
                                                            0.5,
                                                      ),
                                                      Text(
                                                        '${property["bathroom"]} Bathroom',
                                                        style: kRalewayMedium
                                                            .copyWith(
                                                          color: kGrey85,
                                                          fontSize: SizeConfig
                                                                  .blockSizeHorizontal! *
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
                                    ),
                                  );
                                  propertyWidgets.add(propertyWidget);
                                }
                              }
                              return ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: propertyWidgets,
                              );
                            }),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
