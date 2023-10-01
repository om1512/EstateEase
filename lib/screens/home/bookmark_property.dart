import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/screens/home/property_detail.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({super.key});

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  List<RentProperty> list = [];
  @override
  Widget build(BuildContext context) {
    fireStoreMethods.getFavoriteProperties().then((value) {
      setState(() {
        list = value;
      });
    });

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetail(property: list[index]),
                  ),
                );
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    color: kGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(kBorderRadius10)),
                padding: EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(
                  bottom: kPadding24,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius10),
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
                          style: GoogleFonts.poppins(
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
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ReadMoreText(
                          list[index].description,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          delimiter: '...',
                          trimCollapsedText: 'Show More',
                          trimExpandedText: 'Show Less',
                          style: kRalewayRegular.copyWith(
                            color: kGrey85,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                          moreStyle: kRalewayRegular.copyWith(
                            color: kBlue,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                          lessStyle: kRalewayRegular.copyWith(
                            color: kBlue,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
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
                                  width: SizeConfig.blockSizeHorizontal! * 0.5,
                                ),
                                Text(
                                  '${list[index].bedroom} Bedroom',
                                  style: kRalewayMedium.copyWith(
                                    color: kGrey85,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal! * 2.5,
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
                                  width: SizeConfig.blockSizeHorizontal! * 0.5,
                                ),
                                Text(
                                  '${list[index].bathroom} Bathroom',
                                  style: kRalewayMedium.copyWith(
                                    color: kGrey85,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal! * 2.5,
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
          },
        ),
      ),
    );
  }
}
