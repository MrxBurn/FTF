import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class FanHomePage extends StatefulWidget {
  const FanHomePage({super.key});

  @override
  State<FanHomePage> createState() => _FanHomePageState();
}

class _FanHomePageState extends State<FanHomePage> {
  bool isLoading = false;

  List<String> imagePaths = [
    'assets/illustrations/create_offer.png',
    'assets/illustrations/my_offers.png',
    'assets/illustrations/dashboard.png',
    'assets/illustrations/forum.png',
    'assets/illustrations/events.png',
    'assets/illustrations/my_account.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            BlackButton(
                onPressed: () =>
                    Navigator.pushNamed(context, 'fanFightsOverview'),
                text: 'Fights overview'),
            BlackButton(
                onPressed: () => FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushNamed(context, 'loginPage')),
                text: 'Logout'),
            BlackButton(
                onPressed: () =>
                    Navigator.pushNamed(context, 'fightersOverview'),
                text: 'Fighters overview'),
            BlackButton(
                onPressed: () =>
                    Navigator.pushNamed(context, 'fightersOverview'),
                text: 'Your Fighters'),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
