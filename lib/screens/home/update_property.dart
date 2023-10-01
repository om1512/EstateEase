import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/models/Users.dart';
import 'package:estateease/models/place.dart';
import 'package:estateease/screens/components/image_input.dart';
import 'package:estateease/screens/components/location_input.dart';
import 'package:estateease/screens/components/multiple_image_input.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/services/firebase_storage.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/services/location_config.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateProperty extends StatefulWidget {
  const UpdateProperty(
      {super.key, required this.property, required this.myProperty});
  final RentProperty property;
  final MyProperty myProperty;
  @override
  State<UpdateProperty> createState() => _UpdatePropertyState();
}

class _UpdatePropertyState extends State<UpdateProperty> {
  bool isImageUpdated = false;
  bool isThumbnailUpdated = false;
  bool isLocationSelected = false;
  Storage storage = Storage();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController bedroom = TextEditingController();
  TextEditingController bathroom = TextEditingController();
  TextEditingController rentAmount = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postalZip = TextEditingController();
  TextEditingController country = TextEditingController();
  String _selectedImage = '';
  List<XFile> imageList = [];
  double? lat;
  double? long;
  String per = "month";
  PlaceLocation? _selectedLocation;
  AbsoluteAddress? absoluteAddress;

  @override
  Widget build(BuildContext context) {
    RentProperty property = widget.property;
    name.text = property.name;
    description.text = property.description;
    bedroom.text = property.bedroom;
    bathroom.text = property.bathroom;
    rentAmount.text = property.price;
    per = property.per;
    _selectedImage = property.thumbnail;
    int selectedImages = property.images.length;
    String _locationPerview = LocationHelper.generateLocationPreviewImage(
        lat: property.location.latitude, lng: property.location.longitude);

    if (!isLocationSelected) {
      streetAddress.text = property.absoluteAddress.streetAddress;
      city.text = property.absoluteAddress.city;
      state.text = property.absoluteAddress.state;
      postalZip.text = property.absoluteAddress.postalZip;
      country.text = property.absoluteAddress.country;
    }

    TextStyle lableStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: const Color.fromARGB(255, 176, 175, 175));

    BorderSide regular =
        const BorderSide(color: Color.fromARGB(255, 176, 175, 175));
    BorderSide focus = const BorderSide(color: Color.fromARGB(255, 87, 87, 87));
    BorderSide enable =
        const BorderSide(color: Color.fromARGB(255, 176, 175, 175));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Update Property",
                      style: kRalewayMedium.copyWith(
                          color: kBlue,
                          fontSize: SizeConfig.blockSizeHorizontal! * 6),
                    ),
                    Spacer(),
                    Text(
                      "Type: ${widget.myProperty.category}",
                      style: kRalewayMedium.copyWith(
                          color: kBlue,
                          fontSize: SizeConfig.blockSizeHorizontal! * 4),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("Property Name"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  cursorColor: kBlue,
                  maxLines: 3,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("Property Description"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: bedroom,
                        keyboardType: TextInputType.number,
                        cursorColor: kBlue,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: kBlue),
                        decoration: InputDecoration(
                          label: Text("Bedrooms"),
                          labelStyle: lableStyle,
                          helperStyle: kRalewayRegular.copyWith(
                              color: kGreyB7,
                              fontSize: SizeConfig.blockSizeHorizontal! * 3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: regular,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: focus,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: enable,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: bathroom,
                        keyboardType: TextInputType.number,
                        cursorColor: kBlue,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: kBlue),
                        decoration: InputDecoration(
                          label: Text("Bathrooms"),
                          labelStyle: lableStyle,
                          helperStyle: kRalewayRegular.copyWith(
                              color: kGreyB7,
                              fontSize: SizeConfig.blockSizeHorizontal! * 3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: regular,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: focus,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: enable,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: rentAmount,
                        keyboardType: TextInputType.number,
                        cursorColor: kBlue,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: kBlue),
                        decoration: InputDecoration(
                          label: Text("Rent Amount"),
                          labelStyle: lableStyle,
                          helperStyle: kRalewayRegular.copyWith(
                              color: kGreyB7,
                              fontSize: SizeConfig.blockSizeHorizontal! * 3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: regular,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: focus,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: enable,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 176, 175, 175)),
                            borderRadius: BorderRadius.circular(8)),
                        child: DropdownButtonFormField(
                          value: per,
                          onChanged: (String? value) {
                            setState(() {
                              per = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem<String>(
                              value: "month",
                              child: Text("Month"),
                            ),
                            DropdownMenuItem<String>(
                              value: "year",
                              child: Text("Year"),
                            ),
                          ],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            border: InputBorder.none,
                          ),
                          style: kRalewayBold.copyWith(color: kGreyB7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: kGrey,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_selectedImage),
                    ),
                    borderRadius: BorderRadius.circular(kBorderRadius10),
                  ),
                  height: 250,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                MultipleImageSelector(
                  setImageList: (imageList, isImageUpdated) {
                    this.imageList = imageList;
                    this.isImageUpdated = isImageUpdated!;
                  },
                  imageAdded: selectedImages,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  thickness: 1,
                  color: kGrey,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Property Address Details',
                      style: kRalewayMedium.copyWith(color: kBlue),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                LocationInput(
                  onSelectLocation: (location, address, status) {
                    _selectedLocation = location;
                    absoluteAddress = address;
                    setState(() {
                      streetAddress.text = absoluteAddress!.streetAddress;
                      city.text = absoluteAddress!.city;
                      state.text = absoluteAddress!.state;
                      country.text = absoluteAddress!.country;
                      postalZip.text = absoluteAddress!.postalZip;
                      isLocationSelected = status!;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: streetAddress,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("Street Address"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: city,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("City"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: state,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("State"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: postalZip,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("Postal Zip"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: country,
                  keyboardType: TextInputType.name,
                  cursorColor: kBlue,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: kBlue),
                  decoration: InputDecoration(
                    label: Text("Country"),
                    labelStyle: lableStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: focus,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: enable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 46, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _saveData,
                    child: Text(
                      "Submit Details",
                      style: kRalewayMedium.copyWith(
                          color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print("Rare Data $isImageUpdated $isThumbnailUpdated");
    if (name.text.isNotEmpty &&
        description.text.isNotEmpty &&
        bedroom.text.isNotEmpty &&
        bathroom.text.isNotEmpty &&
        rentAmount.text.isNotEmpty &&
        (_selectedImage != '' || widget.property.thumbnail.isNotEmpty) &&
        (widget.property.images.isNotEmpty || imageList.isNotEmpty) &&
        streetAddress.text.isNotEmpty &&
        city.text.isNotEmpty &&
        state.text.isNotEmpty &&
        postalZip.text.isNotEmpty &&
        country.text.isNotEmpty) {
      showSnackBar(context, "Every thing is Filled");
      EasyLoading.show();
      absoluteAddress = AbsoluteAddress(
          streetAddress: streetAddress.text,
          city: city.text,
          state: state.text,
          postalZip: postalZip.text,
          country: country.text);
      RentProperty property = RentProperty(
        id: widget.property.id,
        name: name.text,
        description: description.text,
        bedroom: bedroom.text,
        bathroom: bathroom.text,
        balcony: "1",
        price: rentAmount.text,
        per: per,
        thumbnail: widget.property.thumbnail,
        images: widget.property.images,
        location: widget.property.location,
        absoluteAddress: absoluteAddress!,
        userId: userId,
        reports: [],
      );

      if (isLocationSelected) {
        property.location = _selectedLocation!;
        property.absoluteAddress = absoluteAddress!;
      }
      FireStoreMethods().updateProperty(property, widget.myProperty);
      EasyLoading.dismiss();
      _dialogBuilder(context);
    } else {
      showSnackBar(context, "Please Fill All The Details");
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Property Uploaded '),
          content: const Text(
            'We will verify your property soon stay tuned. if we find any illegal stuff then we will take strick action',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Okay',
                style: kRalewayMedium.copyWith(color: kBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const MainScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
