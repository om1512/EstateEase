import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/provider/currentLocationProvider.dart';
import 'package:estateease/screens/components/map_for_route.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/services/location_config.dart';
import 'package:flutter/material.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetail extends ConsumerStatefulWidget {
  const PropertyDetail({Key? key, required this.property}) : super(key: key);
  final RentProperty property;
  @override
  ConsumerState<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends ConsumerState<PropertyDetail> {
  final FireStoreMethods fireStoreMethods = FireStoreMethods();
  String image = "";
  String name = "";
  String phone = "";
  String mapImageLink = "";
  bool propertyBookmarked = false;

  @override
  void initState() {
    super.initState();
    fireStoreMethods.getUserData(widget.property.userId).then(
      (value) {
        setState(() {
          image = value.image;
          name = value.name;
          phone = value.phone;
        });
      },
    );
    fireStoreMethods.isPropertyBookMarked(widget.property.id).then((value) {
      setState(() {
        propertyBookmarked = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    mapImageLink = LocationHelper.generateLocationPreviewImage(
        lat: widget.property.location.latitude,
        lng: widget.property.location.longitude);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(color: kWhite),
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding8,
        ),
        height: 60,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: kPadding20,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Price',
                      style: kRalewayRegular.copyWith(
                        color: kGrey85,
                        fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 0.5,
                    ),
                    Text(
                      '${widget.property.price} / ${widget.property.per}',
                      style: kRalewayMedium.copyWith(
                        color: kBlack,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('Rent Now Tapped');
                },
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      kBorderRadius10,
                    ),
                    gradient: kLinearGradientBlue,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kPadding24,
                  ),
                  child: Center(
                    child: Text(
                      'Rent Now',
                      style: kRalewaySemibold.copyWith(
                        color: kWhite,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              left: kPadding20, right: kPadding20, top: kPadding8, bottom: 50),
          child: Column(
            children: [
              Container(
                height: 319,
                width: double.infinity,
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
                    image: NetworkImage(
                      widget.property.thumbnail,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(kBorderRadius20),
                            bottomRight: Radius.circular(kBorderRadius20),
                          ),
                          gradient: kLinearGradientBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: kBlack.withOpacity(0.24),
                                  child: SvgPicture.asset(
                                    'assets/icons/icon_arrow_back.svg',
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: kBlack.withOpacity(0.24),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.bookmark,
                                    size: 17,
                                    color:
                                        (propertyBookmarked) ? kBlue : kWhite,
                                  ),
                                  onPressed: () {
                                    if (!propertyBookmarked) {
                                      fireStoreMethods.addPropertyToFavorite(
                                          widget.property);
                                      setState(() {
                                        propertyBookmarked =
                                            !propertyBookmarked;
                                      });
                                    } else {
                                      fireStoreMethods
                                          .removePropertyFromFavorite(
                                              widget.property.id);
                                      setState(() {
                                        propertyBookmarked =
                                            !propertyBookmarked;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.property.name,
                                style: kRalewaySemibold.copyWith(
                                  color: kWhite,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 4.5,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 0.5,
                              ),
                              Text(
                                widget.property.location.address,
                                style: kRalewayRegular.copyWith(
                                  color: kWhite,
                                  fontSize: SizeConfig.blockSizeHorizontal! * 3,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 1.5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        width:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        decoration: BoxDecoration(
                                          color: kWhite.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            kBorderRadius5,
                                          ),
                                        ),
                                        padding:
                                            const EdgeInsets.all(kPadding4),
                                        child: SvgPicture.asset(
                                          'assets/icons/icon_bedroom_white.svg',
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeHorizontal! *
                                            2.5,
                                      ),
                                      Text(
                                        '${widget.property.bedroom} Bedroom',
                                        style: kRalewayRegular.copyWith(
                                          color: kWhite,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        SizeConfig.blockSizeHorizontal! * 7.5,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        width:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        decoration: BoxDecoration(
                                          color: kWhite.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            kBorderRadius5,
                                          ),
                                        ),
                                        padding:
                                            const EdgeInsets.all(kPadding4),
                                        child: SvgPicture.asset(
                                          'assets/icons/icon_bathroom_white.svg',
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeHorizontal! *
                                            2.5,
                                      ),
                                      Text(
                                        '${widget.property.bathroom} Bathroom',
                                        style: kRalewayRegular.copyWith(
                                          color: kWhite,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  2.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                children: [
                  Text(
                    'Description',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              ReadMoreText(
                widget.property.description,
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
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/3177/3177440.png",
                        ),
                        backgroundColor: kBlue,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: kRalewayMedium.copyWith(
                              color: kBlack,
                              fontSize: SizeConfig.blockSizeHorizontal! * 4,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 0.2,
                          ),
                          Text(
                            'Owner',
                            style: kRalewayMedium.copyWith(
                              color: kGrey85,
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          launch("tel:+91$phone");
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius5),
                            color: kBlue.withOpacity(0.5),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/icon_phone.svg',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorderRadius5),
                          color: kBlue.withOpacity(0.5),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/icon_message.svg',
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                children: [
                  Text(
                    'Gallery',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: kPadding16,
                  childAspectRatio: 1,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: CarouselSlider.builder(
                                  itemCount: widget.property.images.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Image(
                                      image: NetworkImage(
                                          widget.property.images[index]),
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                    );
                                  },
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.9,
                                    aspectRatio: 1.0,
                                    initialPage: 0,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius10),
                        color: kBlue,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (index < widget.property.images.length)
                              ? NetworkImage(
                                  widget.property.images[index],
                                )
                              : NetworkImage(
                                  "https://www.svgrepo.com/show/508699/landscape-placeholder.svg",
                                ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              index == 4 - 1 ? kBlack.withOpacity(0.3) : null,
                          borderRadius: BorderRadius.circular(kBorderRadius10),
                        ),
                        child: Center(
                          child: (index < widget.property.images.length)
                              ? index == 4 - 1
                                  ? Text(
                                      '+${widget.property.images.length - 3}',
                                      style: kRalewayMedium.copyWith(
                                        color: kWhite,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal! * 5,
                                      ),
                                    )
                                  : null
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: kPadding24,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MapForRoute(
                        startLat: ref.read(currentLocation).latitude,
                        startLng: ref.read(currentLocation).longitude,
                        endLat: widget.property.location.latitude,
                        endLng: widget.property.location.longitude,
                      );
                    },
                  ));
                },
                child: Container(
                  height: 161,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(mapImageLink),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                children: [
                  Text(
                    'Reviews',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 28,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius5),
                      color: kBlue.withOpacity(0.5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.add,
                          color: kWhite,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Add Review",
                          style: kRalewayMedium.copyWith(color: kWhite),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Container(
                child: (widget.property.reports.isEmpty)
                    ? Container(
                        height: 80,
                        width: SizeConfig.screenHeight,
                        decoration: BoxDecoration(
                            border: Border.all(color: kGrey),
                            borderRadius:
                                BorderRadius.circular(kBorderRadius10)),
                        child: Center(
                            child: Text(
                          "No Reviews",
                          style: kRalewayMedium,
                        )),
                      )
                    : null,
              ),
              const SizedBox(
                height: kPadding32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
