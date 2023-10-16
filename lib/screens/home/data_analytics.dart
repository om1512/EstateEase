import 'package:estateease/components/chart.dart';
import 'package:flutter/material.dart';

class DataAnalytics extends StatefulWidget {
  const DataAnalytics({super.key});

  @override
  State<DataAnalytics> createState() => _DataAnalyticsState();
}

class _DataAnalyticsState extends State<DataAnalytics> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        Chart(),
      ]),
    );
  }
}
