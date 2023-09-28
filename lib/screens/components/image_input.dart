import 'dart:io';

import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onTakeImage});
  final void Function(String image) onTakeImage;
  @override
  State<StatefulWidget> createState() {
    return _ImageInputstate();
  }
}

class _ImageInputstate extends State<ImageInput> {
  String _selectedImage = '';

  selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _selectedImage = await selectImageFromGallery();
                            if (_selectedImage != '') {
                              Navigator.pop(context);
                              widget.onTakeImage(_selectedImage!);
                              setState(() {});
                            } else {
                              showSnackBar(context, "No Image Selected!");
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.photo_size_select_actual,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Gallery',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            _selectedImage = await selectImageFromCamera();
                            if (_selectedImage != '') {
                              Navigator.pop(context);
                              widget.onTakeImage(_selectedImage!);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("No Image Captured !"),
                              ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Camera',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('No Thumbnail Is Selected',
        style: kRalewayMedium.copyWith(color: kGrey));
    if (_selectedImage != "") {
      setState(() {
        content = Image.file(
          File(
            _selectedImage,
          ),
          fit: BoxFit.cover,
          width: double.infinity,
        );
      });
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: kGrey,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius10),
          ),
          width: double.infinity,
          child: TextButton.icon(
            onPressed: selectImage,
            icon: const Icon(
              Icons.camera,
              color: kGrey,
            ),
            label: Text(
              'Add Thumbnail Picture',
              style: kRalewayMedium.copyWith(color: kGrey),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: kGrey,
            ),
            borderRadius: BorderRadius.circular(kBorderRadius10),
          ),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: content,
        ),
      ],
    );
  }
}
