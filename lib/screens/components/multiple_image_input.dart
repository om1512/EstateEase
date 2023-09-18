import 'dart:io';

import 'package:estateease/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultipleImageSelector extends StatefulWidget {
  const MultipleImageSelector({super.key, required this.setImageList});
  final void Function(List<XFile> imageList) setImageList;
  @override
  State<MultipleImageSelector> createState() => _MultipleImageSelectorState();
}

class _MultipleImageSelectorState extends State<MultipleImageSelector> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  void selectImages() async {
    imageFileList = await imagePicker.pickMultiImage();
    widget.setImageList(imageFileList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // display image selected from gallery
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
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
              onPressed: selectImages,
              icon: const Icon(
                Icons.camera,
                color: kGrey,
              ),
              label: Text(
                imageFileList.isEmpty
                    ? 'Add Property Picture'
                    : "${imageFileList.length} Images are selected",
                style: kRalewayMedium.copyWith(color: kBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
