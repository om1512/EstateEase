import 'dart:io';

import 'package:estateease/utils/showSnackBar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// ignore: must_be_immutable
class Storage extends StatelessWidget {
  Storage({super.key});

  final FirebaseStorage storage = FirebaseStorage.instance;

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
            EasyLoading.show(status: "Uploading");
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
            EasyLoading.showSuccess("Uploaded");
            break;
        }
      });
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
