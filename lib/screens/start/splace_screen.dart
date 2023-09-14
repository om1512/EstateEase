import 'dart:async';

import 'package:estateease/screens/auth/login.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/utils/app_styles.dart';
import 'package:estateease/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {
  @override
  void initState() {
    super.initState();
    isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 244, 1),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/triangular.png',
                width: 130,
                height: 130,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'EstateEase',
                style: kRalewayMedium.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                    color: kBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void isLogin(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        });
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Authentication(),
            ),
          );
        });
      }
    });
  }
}
