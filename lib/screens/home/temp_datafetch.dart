import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TempDataFetch extends StatefulWidget {
  const TempDataFetch({super.key});

  @override
  State<TempDataFetch> createState() => _TempDataFetchState();
}

class _TempDataFetchState extends State<TempDataFetch> {
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Text("Nothing is working"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Properties")
              .doc("Everyone")
              .collection("Apartment")
              .snapshots(),
          builder: (context, snapshot) {
            List<Row> propertyWidgets = [];
            if (snapshot.hasData) {
              final properties = snapshot.data?.docs.reversed.toList();
              for (var property in properties!) {
                print("Looping");
                final propertyWidget = Row(
                  children: [
                    Text(property['name']),
                    Text("  Balcony : ${property['balcony']}")
                  ],
                );
                propertyWidgets.add(propertyWidget);
              }
            }
            return Expanded(
              child: ListView(
                children: propertyWidgets,
              ),
            );
          },
        )
      ],
    ));
  }
}
