import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/models/Users.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({super.key, required this.userReport});
  final UserReport userReport;
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  User? user;

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
                color: color, fontSize: SizeConfig.blockSizeHorizontal! * 2.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fireStoreMethods.getUserData(userReport.userId).then((value) {
      user = value;
    });
    return Container(
      height: 70,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: kGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(kBorderRadius10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    user!.image,
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
                      user!.name,
                      style: kRalewayMedium.copyWith(
                        color: kBlack,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                labels(
                    userReport.type,
                    (userReport.type.toLowerCase() == "positive")
                        ? Colors.green
                        : Colors.red),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            userReport.message
            ,
            style: kRalewayMedium.copyWith(
              
            ),),
        ],
      ),
    );
  }
}
