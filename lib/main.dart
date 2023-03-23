import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:le_debut_check_in/firebase_options.dart';
import 'package:le_debut_check_in/screens/home.dart';
import 'package:le_debut_check_in/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Debut Check In',
      theme: MyDarkThemeStyle.myDarkMode,
      home: const Home(),
    );
  }
}