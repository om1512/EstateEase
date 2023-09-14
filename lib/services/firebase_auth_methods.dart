import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/services/firestore_methods.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  final FireStoreMethods fireStoreMethods = FireStoreMethods();
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseAuthMethods(this._auth);
  User? user;
  //Email SignUp
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String image,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => print(value));
      await setEmailVerification(context);

      await fireStoreMethods.addUser(
        context: context,
        userID: auth.currentUser!.uid,
        image: image,
        name: name,
        eMail: email,
      );
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }
  }

  //Email Verification
  Future<void> setEmailVerification(BuildContext context) async {
    EasyLoading.show();
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email Verification Sent !');
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }
  }

  //Email Login
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await setEmailVerification(context);
      }
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == "channel-error")
        showSnackBar(context, "Please Fill Correct Data");
      else
        showSnackBar(context, e.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    EasyLoading.dismiss();
    print("line done");
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("line done");
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("line done 2");
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print("Line done 3");
      if (userCredential.user != null) {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }
  }
}
