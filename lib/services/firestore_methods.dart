// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/services/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:estateease/models/Users.dart' as MyUser;
import 'package:image_picker/image_picker.dart';

class FireStoreMethods {
  late String downloadURL;
  Storage storage = Storage();
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  Future<String?> addUser({
    required BuildContext context,
    required String userID,
    required String image,
    required String eMail,
    required String name,
    required String phone,
  }) async {
    try {
      downloadURL = await storage.uploadSingleFile(
        userID,
        image,
      );
      EasyLoading.show(status: "Uploading data");
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      MyUser.User u = MyUser.User(
          image: downloadURL,
          email: eMail,
          name: name,
          phone: phone,
          myProperties: []);
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

  Future<void> addProperty(BuildContext context, String uid,
      RentProperty property, List<XFile> imageList, String propertyType) async {
    try {
      // to store data in property collection
      CollectionReference user =
          FirebaseFirestore.instance.collection('Properties/');
      await user.doc("Everyone").collection(propertyType).doc(property.id).set(
            property.toJson(),
          );

      // to store property reference in their owner id
      MyUser.MyProperty myProperty = MyUser.MyProperty(
          type: "Everyone", category: propertyType, id: property.id);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(property.userId)
          .update(
        {
          'myProperties': FieldValue.arrayUnion([myProperty.toJson()])
        },
      );
    } catch (error) {
      // for error handling
      print("error" + error.toString());
    }
  }

  Future<void> updateProperty(
      RentProperty property, MyUser.MyProperty myProperty) async {
    print("rare object");
    try {
      CollectionReference user =
          FirebaseFirestore.instance.collection('Properties/');
      await user
          .doc(myProperty.type)
          .collection(myProperty.category)
          .doc(property.id)
          .set(
            property.toJson(),
          );
    } catch (error) {
      print("ERROR $error");
    }
  }

  Future<MyUser.User> getUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return MyUser.User.fromJson(userDocument.data() as Map<String, dynamic>);
  }

  Future<void> deleteProperty(RentProperty property,
      MyUser.MyProperty myProperty, String userId) async {
    await FirebaseFirestore.instance
        .collection("Properties")
        .doc(myProperty.type)
        .collection(myProperty.category)
        .doc(property.id)
        .delete();

    MyUser.User user = await getUserData(userId);
    for (MyUser.MyProperty myProperty in user.myProperties) {
      if (myProperty.id == property.id) {
        FirebaseFirestore.instance.collection('Users').doc(userId).update(
          {
            'myProperties': FieldValue.arrayRemove([myProperty.toJson()])
          },
        );
      }
    }
    FirebaseStorage.instance.ref("Property/").child(property.id).delete();
    print("Property deleted");
  }

  

  Future<RentProperty> getRentPropertyById(
      String id, String type, String category) async {
    DocumentSnapshot<Map<String, dynamic>> data = await _fireStoreDataBase
        .collection("Properties")
        .doc(type)
        .collection(category)
        .doc(id)
        .get();
    return RentProperty.fromJson(data.data() as Map<String, dynamic>);
  }


  

  Future<List<dynamic>> getUserProperty(String userId) async {
    MyUser.User userData = await getUserData(userId);
    List<MyUser.MyProperty> propertyData = userData.myProperties;
    List<RentProperty> userProperty = [];
    for (var property in propertyData) {
      RentProperty p = await getRentPropertyById(
          property.id, property.type, property.category);
      userProperty.add(p);
    }
    List<dynamic> result = [];
    result.add(userProperty);
    result.add(propertyData);
    return result;
  }
}
