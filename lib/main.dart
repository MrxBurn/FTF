import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/authentication/register_fan.dart';
import 'package:ftf/authentication/register_fighter.dart';
import 'package:ftf/home_pages/fan_home_page.dart';
import 'package:ftf/home_pages/fighter_home_page.dart';
import 'package:ftf/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

User? currentUser = FirebaseAuth.instance.currentUser;

Widget initialWidget = const Placeholder();

//TODO: Differentiate between Fighter and Fan

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Widget> checkIfUserLoggedIn() async {
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('fanUsers')
          .doc(currentUser?.uid)
          .get()
          .then((value) => {
                if (value.exists)
                  {initialWidget = const FanHomePage()}
                else
                  {initialWidget = const FighterHomePage()}
              });
    } else {
      initialWidget = const LoginPage();
    }

    return initialWidget;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
              ),
              labelLarge: TextStyle(
                color: Colors.white,
              ),
            ),
            fontFamily: 'Roboto',
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  overlayColor:
                      MaterialStatePropertyAll(Colors.red.withOpacity(0.2)),
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(lighterBlack)),
                  foregroundColor:
                      const MaterialStatePropertyAll(Colors.white)),
            ),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: Colors.white)),
        routes: {
          '/fighterHome': (context) => const FighterHomePage(),
          '/fanHome': (context) => const FanHomePage(),
          'accountType': (context) => const AccountType(),
          'registerFighter': (context) => const RegisterFighter(),
          'registerFan': (context) => const RegisterFan(),
          'loginPage': (context) => const LoginPage(),
          // 'homePageFigher':(context) => const FighterHomePage();
          'fighterImageUpload': (context) => const FighterImageUpload()
        },
        home: initialWidget);
  }
}
