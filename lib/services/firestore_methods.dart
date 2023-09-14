import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:estateease/models/Users.dart' as MyUser;

class FireStoreMethods {
  late String downloadURL;
  Storage storage = Storage();
  Future<String?> addUser({
    required BuildContext context,
    required String userID,
    required String image,
    required String eMail,
    required String name,
  }) async {
    try {
      downloadURL = await storage.uploadSingleFile(context, userID, image);
      print(downloadURL);
      EasyLoading.show(status: "Uploading data");
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      MyUser.User u = MyUser.User(image: downloadURL, email: eMail, name: name);
      await users.doc(userID).set(u.toJson(), SetOptions(merge: true));
      EasyLoading.showSuccess("Uploaded");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
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
