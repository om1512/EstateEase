import 'package:estateease/models/SearchPlace.dart';
import 'package:estateease/provider/userPlaceProvider.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationPicker extends ConsumerStatefulWidget {
  const LocationPicker({super.key, required this.onSelectLocation});
  final void Function() onSelectLocation;
  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  List<String> country = <String>['India', 'USA', 'Canada', 'China'];
  List<String> state = <String>['Gujarat', 'Maharashtra', 'MP', 'Delhi'];
  List<String> city = <String>['Surat', 'Nadiad', 'Jamnagar', 'Rajkot'];

  @override
  Widget build(BuildContext context) {
    String countryValue = ref.watch(userPlace).country;
    String cityValue = ref.watch(userPlace).city;
    String stateValue = ref.watch(userPlace).state;
    return Center(
      child: Container(
        height: 300,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kBorderRadius10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Your Place",
              style: kRalewayMedium.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 5),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: kGrey,
                          ),
                          borderRadius: BorderRadius.circular(kBorderRadius10)),
                      child: DropdownButton<String>(
                        value: countryValue,
                        elevation: 16,
                        style: const TextStyle(color: kBlue),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          ref.read(userPlace).country = value!;
                          setState(() {});
                        },
                        items: country
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kRalewayMedium.copyWith(color: kBlue),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: kGrey,
                          ),
                          borderRadius: BorderRadius.circular(kBorderRadius10)),
                      child: DropdownButton<String>(
                        value: stateValue,
                        elevation: 16,
                        style: const TextStyle(color: kBlue),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          ref.read(userPlace).state = value!;
                          setState(() {});
                        },
                        items:
                            state.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kRalewayMedium.copyWith(color: kBlue),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: kGrey,
                          ),
                          borderRadius: BorderRadius.circular(kBorderRadius10)),
                      child: DropdownButton<String>(
                        hint: Text("City"),
                        value: cityValue,
                        elevation: 16,
                        style: const TextStyle(color: kBlue),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          ref.read(userPlace).city = value!;
                          setState(() {});
                        },
                        items:
                            city.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kRalewayMedium.copyWith(color: kBlue),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: kGrey,
                            ),
                            borderRadius:
                                BorderRadius.circular(kBorderRadius10)),
                        child: TextButton(
                            onPressed: () {
                              widget.onSelectLocation();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Submit",
                              style: kRalewayMedium.copyWith(color: kBlue),
                            ))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
