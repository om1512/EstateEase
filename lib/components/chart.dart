import 'dart:math';

import 'package:estateease/components/chart_bar.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Map<String, dynamic>> propertiesData = [];

  FireStoreMethods fireStoreMethods = FireStoreMethods();

  List<Widget> list = [];

  List<Widget> piList = [];

  List<Widget> card = [];

  int maxTotalExpense = 0;
  String maxName = "";
  int user = 0;
  @override
  Widget build(BuildContext context) {
    fireStoreMethods.getPropertiesData().then((value) {
      propertiesData = value;
      piList = [];
      list = [];
      for (var data in propertiesData) {
        if (data["count"] > maxTotalExpense) {
          maxTotalExpense = data["count"];
          maxName = data["type"];
        }
      }
      for (var e in propertiesData) {
        piList.add(ChartBar(
          fill: e["count"] == 0 ? 0 : e["count"] / maxTotalExpense,
          title: e["type"],
        ));

        list.add(Padding(
          padding: EdgeInsets.only(right: (e["type"] == "Cottage") ? 0 : 25),
          child: Text(
            e["type"],
            style: kRalewayMedium.copyWith(fontSize: 9),
          ),
        ));
      }
    });
    fireStoreMethods.getNumberOfUsers().then(
          (value) => user = value,
        );
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: piList,
                  ),
                ),
                Row(
                  children: list,
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            margin: const EdgeInsets.all(16),
            height: 60,
            decoration: BoxDecoration(
              color: kGrey,
            ),
            child: Row(
              children: [Text("Users"), Spacer(), Text(user.toString())],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            margin: const EdgeInsets.all(16),
            height: 60,
            decoration: BoxDecoration(
              color: kGrey,
            ),
            child: Row(
              children: [
                Text("Leading Property : ${maxName}"),
                Spacer(),
                Text(maxTotalExpense.toString())
              ],
            ),
          ),
          IconButton.outlined(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
    );
  }
}
