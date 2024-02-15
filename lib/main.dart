import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/authentication/register_fan.dart';
import 'package:ftf/authentication/register_fighter.dart';
import 'package:ftf/create_offer_page/create_offer_fighter.dart';
import 'package:ftf/create_offer_page/dynamic_link_summary.dart';
import 'package:ftf/dashboard/dashboard_page.dart';
import 'package:ftf/fan_fights_overview/fights_overview_page.dart';
import 'package:ftf/fighter_forum/fighter_forum.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';
import 'package:ftf/home_pages/fan_home_page.dart';
import 'package:ftf/home_pages/fighter_home_page.dart';
import 'package:ftf/my_account/my_account.dart';
import 'package:ftf/my_fighters_overview/my_followed_fighters.dart';
import 'package:ftf/my_offers/my_offers_page.dart';
import 'package:ftf/news_and_events/news_and_events_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';
import 'package:month_year_picker/month_year_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

User? currentUser = FirebaseAuth.instance.currentUser;

Widget initialWidget = const Placeholder();

Uri? deepLink;

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initDynamicLink();
  }

  Future<void> initDynamicLink() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (Platform.isIOS) {
      FirebaseDynamicLinks.instance.onLink.listen(
        (pendingDynamicLinkData) {
          setState(() {
            deepLink = pendingDynamicLinkData.link;
          });
        },
      );
    }

    setState(() {
      deepLink = initialLink?.link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.black,
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
                foregroundColor: const MaterialStatePropertyAll(Colors.white)),
          ),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: Colors.white,
              selectionHandleColor: Colors.white),
        ),
        routes: {
          'fighterHome': (context) => const FighterHomePage(),
          'fanHome': (context) => const FanHomePage(),
          'accountType': (context) => AccountType(),
          'registerFighter': (context) => RegisterFighter(),
          'registerFan': (context) => const RegisterFan(),
          'loginPage': (context) => LoginPage(),
          'fighterImageUpload': (context) => FighterImageUpload(),
          'createOfferFighter': (context) => const CreateOfferFighter(),
          'dynamicLinkSummary': (context) => const DynamicLinkSummary(),
          'viewOffer': (context) => ViewOfferPage(),
          'dashboard': (context) => const DashboardPage(),
          'myOffers': (context) => MyOffersPage(),
          'fighterForum': (context) => const FighterForum(),
          'newsEvents': (context) => const NewsAndEventsPage(),
          'myAccount': (context) => const MyAccount(),
          'fanFightsOverview': (context) => const FanFightsOverview(),
          'fightersOverview': (context) => const FightersOverview(),
          'myFighters': (context) => const MyFollowedFighters()
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
              return LoginPage(
                offerId: deepLink?.queryParameters['offerId'],
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data!.get('route') == 'fighter' &&
                deepLink != null &&
                deepLink.toString().contains('offerId') &&
                currentUser != null) {
              return ViewOfferPage(
                offerId: deepLink?.queryParameters['offerId'],
              );
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
