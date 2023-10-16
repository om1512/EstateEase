import 'package:flutter/material.dart';

class ChartBar extends StatefulWidget {
  const ChartBar({super.key, required this.fill, required this.title});

  final double fill;
  final String title;

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: FractionallySizedBox(
          heightFactor: widget.fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: const Color.fromARGB(255, 7, 39, 94),
            ),
          ),
        ),
      ),
    );
  }
}
