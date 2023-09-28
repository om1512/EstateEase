import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Storage extends StatelessWidget {
  Storage({super.key});

  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String url = "";
  Future<String> uploadSingleFile(
    BuildContext context,
    String fileId,
    String filePath,
  ) async {
    File file = File(filePath);

    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final storageRef = FirebaseStorage.instance.ref();

      final uploadTask =
          storageRef.child('Users/$fileId').putFile(file, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            EasyLoading.show(status: "Uploading Image");
            break;
          case TaskState.paused:
            EasyLoading.showError("Something Went Wrong");
            break;
          case TaskState.canceled:
            EasyLoading.showError("Failed");
            break;
          case TaskState.error:
            EasyLoading.showError("Failed");
            break;
          case TaskState.success:
            var dowurl =
                await storageRef.child('Users/$fileId').getDownloadURL();
            url = dowurl.toString();
            EasyLoading.showSuccess("Image Uploaded");
            print(url);

            FirebaseFirestore.instance
                .collection('Users')
                .doc(auth.currentUser!.uid)
                .update({'image': url});

            break;
        }
      });
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }

    return url;
  }

  Future<String> uploadSingleFileOfProperty(
      BuildContext context,
      String fileId,
      String filePath,
      String propertyId,
      String use,
      String propertyType,
      String category) async {
    File file = File(filePath);

    try {
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final storageRef = FirebaseStorage.instance.ref();
      if (use == "multipleImage") {
        final uploadTask = storageRef
            .child('Property/${propertyId}/$fileId')
            .putFile(file, metadata);
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              break;
            case TaskState.paused:
              EasyLoading.showError("Something Went Wrong");
              break;
            case TaskState.canceled:
              EasyLoading.showError("Failed");
              break;
            case TaskState.error:
              EasyLoading.showError("Failed");
              break;
            case TaskState.success:
              var dowUrl = await storageRef
                  .child('Property/${propertyId}/$fileId')
                  .getDownloadURL();
              FirebaseFirestore.instance
                  .collection('Properties')
                  .doc(category)
                  .collection(propertyType)
                  .doc(propertyId)
                  .update({
                "images": FieldValue.arrayUnion([dowUrl])
              });

              break;
          }
        });
      } else if (use == "singleImage") {
        final uploadTask = storageRef
            .child('Property/${propertyId}/Thumbnail')
            .putFile(file, metadata);
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              break;
            case TaskState.paused:
              EasyLoading.showError("Something Went Wrong");
              break;
            case TaskState.canceled:
              EasyLoading.showError("Failed");
              break;
            case TaskState.error:
              EasyLoading.showError("Failed");
              break;
            case TaskState.success:
              var dowUrl = await storageRef
                  .child('Property/${propertyId}/Thumbnail')
                  .getDownloadURL();
              FirebaseFirestore.instance
                  .collection('Properties')
                  .doc(category)
                  .collection(propertyType)
                  .doc(propertyId)
                  .update({"thumbnail": dowUrl});

              break;
          }
        });
      }
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }

    return url;
  }

  Future<List<String>> uploadFiles(BuildContext context, List<XFile> _images,
      String propertyId, String propertyType, String category) async {
    print("this function is Called");
    EasyLoading.showSuccess("Image Uploaded");
    var imageUrls = await Future.wait(_images.map((_image) =>
        uploadSingleFileOfProperty(context, _images.indexOf(_image).toString(),
            _image.path, propertyId, "multipleImage", propertyType, category)));
    print("After Uploading Final Result $imageUrls");

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
