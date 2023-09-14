import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';

class UploadProperty extends StatefulWidget {
  const UploadProperty({super.key});

  @override
  State<UploadProperty> createState() => _UploadPropertyState();
}

class _UploadPropertyState extends State<UploadProperty> {
  @override
  Widget build(BuildContext context) {
    TextStyle lableStyle = Theme.of(context)
        .textTheme
        .titleSmall!
        .copyWith(color: Color.fromARGB(255, 176, 175, 175));

    BorderSide regular = BorderSide(color: Color.fromARGB(255, 176, 175, 175));
    BorderSide focus = BorderSide(color: Color.fromARGB(255, 87, 87, 87));
    BorderSide enable = BorderSide(color: Color.fromARGB(255, 176, 175, 175));

    String per = "month";
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Property",
              style: kRalewayMedium.copyWith(
                  color: kBlue, fontSize: SizeConfig.blockSizeHorizontal! * 5),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
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
            TextFormField(
              keyboardType: TextInputType.multiline,
              cursorColor: kBlue,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: kBlue),
              decoration: InputDecoration(
                label: Text("Address"),
                labelStyle: lableStyle,
                helperText:
                    "Provide Absolute Correct Address For Better Response",
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextFormField(
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
                SizedBox(
                  width: 17,
                ),
                Flexible(
                  child: TextFormField(
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
                SizedBox(
                  width: 17,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 176, 175, 175)),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonFormField(
                      value: per,
                      onChanged: (String? value) {
                        setState(() {
                          per = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: "month",
                          child: Text("Month"),
                        ),
                        DropdownMenuItem<String>(
                          value: "year",
                          child: Text("Year"),
                        ),
                      ],
                      decoration: InputDecoration(
                        icon: Icon(Icons.arrow_drop_down_rounded),
                        border: InputBorder.none,
                      ),
                      style: kRalewayBold.copyWith(color: kGreyB7),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
