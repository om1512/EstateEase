import 'package:estateease/firebase_options.dart';
import 'package:estateease/screens/home/home_content.dart';
import 'package:estateease/screens/start/main_screen.dart';
import 'package:estateease/screens/start/splace_screen.dart';
import 'package:estateease/utils/app_styles.dart';
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
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
      builder: EasyLoading.init(),
    ),
  );
}
