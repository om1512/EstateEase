import 'package:estateease/firebase_options.dart';
import 'package:estateease/screens/auth/registration.dart';
import 'package:estateease/screens/start/splace_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  runApp(ProviderScope(
    child: MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: SplaceScreen(),
      builder: EasyLoading.init(),
    ),
  ));
}
