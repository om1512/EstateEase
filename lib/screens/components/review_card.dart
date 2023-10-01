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
          )
        ],
      ),
    );
  }
}
