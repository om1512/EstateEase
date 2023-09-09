import 'package:estateease/firebase_options.dart';
import 'package:estateease/screens/authentication.dart';
import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/screens/home_screen.dart';
import 'package:estateease/screens/registration.dart';
import 'package:estateease/screens/splace_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  final colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    background: Color.fromARGB(255, 16, 30, 43),
    seedColor: Color.fromARGB(255, 16, 30, 43),
  );

  final theme = ThemeData().copyWith(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.ralewayDotsTextTheme().copyWith(
      titleSmall: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.raleway(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const Home(),
      builder: EasyLoading.init(),
    ),
  );
}
