// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/services/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:estateease/models/Users.dart' as MyUser;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FireStoreMethods {
  late String downloadURL;
  late String aadharDownloadUrl;
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
      downloadURL = await storage.uploadSingleFileForUser(
        "$userID/profilePicture",
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
          myProperties: [],
          favorite: []);
      await users.doc(userID).set(u.toJson(), SetOptions(merge: true));
      EasyLoading.showSuccess("Uploaded");

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

  Future<void> addPropertyToFavorite(RentProperty property) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String ownerUserId = property.userId;
      getUserData(ownerUserId).then((value) {
        List<MyUser.MyProperty> listOfOwnerProperty = value.myProperties;

        for (var p in listOfOwnerProperty) {
          print("Called");
          if (p.id == property.id) {
            FirebaseFirestore.instance.collection('Users').doc(userId).update(
              {
                'favorite': FieldValue.arrayUnion([p.toJson()])
              },
            );
            continue;
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  Future<List<RentProperty>> getFavoriteProperties() async {
    List<RentProperty> result = [];
    String userId = FirebaseAuth.instance.currentUser!.uid;
    MyUser.User user = await getUserData(userId);
    List<MyUser.MyProperty> favoriteProperties = user.favorite;
    for (var f in favoriteProperties) {
      RentProperty rentProperty =
          await getRentPropertyById(f.id, f.type, f.category);
      result.add(rentProperty);
    }
    return result;
  }

  Future<void> removePropertyFromFavorite(String propertyId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      MyUser.User user = await getUserData(userId);
      for (MyUser.MyProperty myProperty in user.favorite) {
        if (myProperty.id == propertyId) {
          FirebaseFirestore.instance.collection('Users').doc(userId).update(
            {
              'favorite': FieldValue.arrayRemove([myProperty.toJson()])
            },
          );
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<bool> isPropertyBookMarked(String propertyId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      MyUser.User userData = await getUserData(userId);
      List<MyUser.MyProperty> favoriteListOfUser = userData.favorite;
      for (var myProperty in favoriteListOfUser) {
        if (myProperty.id == propertyId) {
          return true;
        }
      }
    } catch (error) {
      print("ERROR : $error");
    }
    return false;
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

  Future<void> addReportOnProperty(
      RentProperty property, String message, String type) async {
    String userId = property.userId;
    UserReport report =
        UserReport(userId: userId, message: message, type: type);
    MyUser.User user = await getUserData(userId);
    for (MyUser.MyProperty myProperty in user.myProperties) {
      if (myProperty.id == property.id) {
        FirebaseFirestore.instance
            .collection('Properties')
            .doc(myProperty.type)
            .collection(myProperty.category)
            .doc(property.id)
            .update(
          {
            'reports': FieldValue.arrayUnion([report.toJson()])
          },
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> getPropertiesData() async {
    List<String> propertyTypes = [
      "House",
      "Apartment",
      "Hotel",
      "Villa",
      "Cottage",
    ];
    List<Map<String, dynamic>> ans = [
      {
        "type": "Hostel",
        "count": 100,
      },
      {
        "type": "PG",
        "count": 525,
      },
      {
        "type": "Flat",
        "count": 778,
      },
      {
        "type": "Apartment",
        "count": 778,
      },
      {
        "type": "Hotel",
        "count": 100,
      },
      {
        "type": "Villa",
        "count": 525,
      },
      {
        "type": "Cottage",
        "count": 778,
      },
    ];
    // for (String s in propertyTypes) {
    //   print("Type : " + s);
    //   final QuerySnapshot qSnap = await FirebaseFirestore.instance
    //       .collection("Properties")
    //       .doc("Everyone")
    //       .collection(s)
    //       .get();

    //   ans.add({
    //     "type": s,
    //     "count": qSnap.docs.length,
    //   });
    // }
    return ans;
  }

  Future<int> getNumberOfUsers() async {
    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection("Users").get();
    return qSnap.docs.length;
  }
}
