import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estateease/services/firebase_storage.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:estateease/models/Users.dart' as MyUser;

class Registration extends StatefulWidget {
  const Registration({
    super.key,
    required this.isEmail,
  });
  final bool isEmail;
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final db = FirebaseFirestore.instance.collection("Users/");
  String selectedImagePath = '';

  final Storage storage = Storage();
  final FireStoreMethods fireStoreMethods = FireStoreMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool otpVisibility = false;
  User? user;
  TextEditingController otpController = TextEditingController();

  String verificationID = "";

  String? eMail;
  String? phone;

  bool isPhoneVerified = false;

  Widget suffixIcon = const Icon(
    Icons.sim_card_alert,
    color: Colors.red,
  );

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void changeSuffix(bool status, String text) {
    if (status == true) {
      setState(() {
        suffixIcon = SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                suffixIcon = SizedBox(
                  height: 25,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        setState(() {
                          otpVisibility = false;
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                );
                loginWithPhone(text);
              },
              child: const Text(
                "GET OTP",
                style: TextStyle(fontSize: 10),
              ),
            ));
      });
    } else {
      setState(() {
        suffixIcon = const Icon(
          Icons.sim_card_alert,
          color: Colors.red,
        );
        otpVisibility = false;
      });
    }
  }

  String downloadURL = "";
  @override
  Widget build(BuildContext context) {
    user = auth.currentUser;

    Color myColor = Theme.of(context).colorScheme.background;
    eMail = user!.email;
    if (user!.phoneNumber != null) {
      phone = user!.phoneNumber;
      phone = phone!.substring(3);
      isPhoneVerified = true;
    }
    emailController.text = eMail!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 100, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 30),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(255, 56, 68, 90),
                                width: 2)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: (selectedImagePath.isNotEmpty)
                            ? GestureDetector(
                                onTap: selectImage,
                                child: Image.file(
                                  File(
                                    selectedImagePath,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(Icons.add),
                                iconSize: 30,
                              ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 35, bottom: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/triangular.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "EstateEase",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: myColor,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: myColor),
                            decoration: InputDecoration(
                              label: Text("Name"),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 176, 175, 175)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 87, 87, 87)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 176, 175, 175)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: myColor,
                              readOnly: widget.isEmail,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: myColor),
                              decoration: InputDecoration(
                                label: Text("Email"),
                                suffixIcon: const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color:
                                            Color.fromARGB(255, 176, 175, 175)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: TextFormField(
                              initialValue: phone,
                              readOnly: isPhoneVerified ? true : otpVisibility,
                              keyboardType: TextInputType.phone,
                              cursorColor: myColor,
                              maxLength: 10,
                              onChanged: (text) {
                                (text.length == 10)
                                    ? changeSuffix(true, text)
                                    : changeSuffix(false, text);
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: myColor),
                              decoration: InputDecoration(
                                label: Text("Phone"),
                                suffix: isPhoneVerified
                                    ? const Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      )
                                    : suffixIcon,
                                prefixText: "+91",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: const Color.fromARGB(
                                            255, 176, 175, 175)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 87, 87, 87)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 176, 175, 175)),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: otpVisibility,
                            child: Pinput(
                              enabled: otpVisibility,
                              controller: otpController,
                              length: 6,
                              defaultPinTheme: PinTheme(
                                height: 50,
                                width: 50,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: myColor),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 176, 175, 175),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          isPhoneVerified
                              ? SizedBox(
                                  width: double.maxFinite,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 31, 46, 60),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      saveData();
                                    },
                                    child: Text(
                                      "Continue",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 17),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.maxFinite,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 31, 46, 60),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      verifyOTP();
                                    },
                                    child: Text(
                                      "Verify",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 17),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void loginWithPhone(String phone) async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91${phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          setState(() {
            isPhoneVerified = true;
            otpVisibility = false;
          });
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBar(context, e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBar(context, "OTP Sent Successfully");

        setState(() {
          otpVisibility = true;
          verificationID = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await user!.linkWithCredential(credential).then(
      (user) {
        setState(() {
          isPhoneVerified = true;
          otpVisibility = false;
        });
      },
    );
  }

  Future selectImage() {
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
                            selectedImagePath = await selectImageFromGallery();
                            if (selectedImagePath != '') {
                              Navigator.pop(context);
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
                            selectedImagePath = await selectImageFromCamera();
                            if (selectedImagePath != '') {
                              Navigator.pop(context);
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

//
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  void saveData() async {
    if (isPhoneVerified) {
      downloadURL =
          await storage.uploadSingleFile(context, user!.uid, selectedImagePath);
      if (downloadURL.isNotEmpty &&
          nameController.text.isNotEmpty &&
          eMail != null &&
          phone != null) {
        MyUser.User u = MyUser.User(
            image: downloadURL,
            email: eMail!,
            phone: phone!,
            name: nameController.text);
        await fireStoreMethods.addUser(
          context: context,
          userID: user!.uid,
          user: u.toJson(),
        );
      } else {
        showSnackBar(context, "Please fill all the details");
      }
    } else {
      showSnackBar(context, "Please Verify Your Phone");
    }
  }
}
