import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/authentication/register_fan.dart';
import 'package:ftf/authentication/register_fighter.dart';
import 'package:ftf/create_offer_page/create_offer_fighter.dart';
import 'package:ftf/home_pages/fan_home_page.dart';
import 'package:ftf/home_pages/fighter_home_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

User? currentUser = FirebaseAuth.instance.currentUser;

Widget initialWidget = const Placeholder();

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
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColorDark: Colors.red,
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
            inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
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
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.white,
                selectionColor: Colors.white,
                selectionHandleColor: Colors.white),
            datePickerTheme: const DatePickerThemeData(
                backgroundColor: Color(lighterBlack))),
        routes: {
          'fighterHome': (context) => const FighterHomePage(),
          'fanHome': (context) => const FanHomePage(),
          'accountType': (context) => const AccountType(),
          'registerFighter': (context) => const RegisterFighter(),
          'registerFan': (context) => const RegisterFan(),
          'loginPage': (context) => const LoginPage(),
          'fighterImageUpload': (context) => const FighterImageUpload(),
          'createOfferFighter': (context) => const CreateOfferFighter()
        },
        localizationsDelegates: const [
          MonthYearPickerLocalizations.delegate,
        ],
        home: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser?.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData &&
                !snapshot.data!.exists &&
                currentUser == null) {
              return const LoginPage();
            }

            if (snapshot.connectionState == ConnectionState.done &&
                currentUser != null &&
                snapshot.data!.get('route') == 'fan') {
              return const FanHomePage();
            }

            if (snapshot.connectionState == ConnectionState.done &&
                currentUser != null &&
                snapshot.data!.get('route') == 'fighter') {
              return const FighterHomePage();
            }

            return SizedBox(
              child: Column(children: [
                LogoHeader(backRequired: false),
                const Center(child: CircularProgressIndicator())
              ]),
            );
          },
        ));
  }
}
