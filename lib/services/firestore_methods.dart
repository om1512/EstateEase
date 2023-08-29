import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/screens/home/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FireStoreMethods {
  Future<String?> addUser({
    required BuildContext context,
    required String userID,
    required Map<String, dynamic> user,
  }) async {
    try {
      EasyLoading.show(status: "Uploading");
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(userID).set(user, SetOptions(merge: true));
      EasyLoading.showSuccess("Uploaded");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return 'success';
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      return 'Error adding user $e'; 
    }
  }

  Future<String?> getUser(String userID) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      final snapshot = await users.doc(userID).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }
}
