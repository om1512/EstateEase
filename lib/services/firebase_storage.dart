import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/models/RentProperty.dart';
import 'package:estateease/models/Users.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Storage extends StatelessWidget {
  Storage({super.key});

  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadSingleFile(
    String fileId,
    String filePath,
  ) async {
    File file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref();
    final Reference fileRef = storageRef.child("Property/${fileId}/Thumbnail");
    try {
      await fileRef.putFile(file);
      String url = await fileRef.getDownloadURL();
      print("URL $url");
      return url;
    } catch (e) {
      print('Error uploading image');
    }
    return "";
  }

  

  Future<List<String>> uploadFiles(
      String propertyId, List<XFile> imageFileList) async {
    final storageRef = FirebaseStorage.instance.ref();
    List<String> downloadUrl = [];
    for (int i = 0; i < imageFileList.length; i++) {
      final XFile imageFile = imageFileList[i];
      final String fileName = imageFileList
          .indexOf(imageFile)
          .toString(); // Unique name for each image
      final Reference fileRef =
          storageRef.child("Property/${propertyId}/$fileName");
      try {
        await fileRef.putFile(File(imageFile.path));
        String url = await fileRef.getDownloadURL();
        downloadUrl.add(url);
      } catch (e) {
        print('Error uploading image $i: $e');
      }
    }
    print("Download URl $downloadUrl");
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
