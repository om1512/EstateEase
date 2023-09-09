import 'package:estateease/screens/auth/registration.dart';
import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/utils/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  User? user;
  //Email SignUp
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setEmailVerification(context);
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Registration(
            isEmail: true,
          ),
        ),
      );
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
        EasyLoading.dismiss();
      }
      if (_auth.currentUser!.phoneNumber != null) {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        EasyLoading.dismiss();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Registration(
              isEmail: true,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        await signUpWithEmail(
            email: email, password: password, context: context);
      }
      showSnackBar(context, e.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    EasyLoading.dismiss();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        EasyLoading.dismiss();
        if (userCredential.additionalUserInfo!.isNewUser ||
            userCredential.user!.phoneNumber == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Registration(
                isEmail: true,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      showSnackBar(context, e.message!);
    }
  }
}
