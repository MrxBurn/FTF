import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class FighterHomePage extends StatefulWidget {
  const FighterHomePage({super.key});

  @override
  State<FighterHomePage> createState() => _FighterHomePageState();
}

class _FighterHomePageState extends State<FighterHomePage> {
  bool isLoading = false;

  List<String> imagePaths = [
    'assets/illustrations/create_offer.png',
    'assets/illustrations/my_offers.png',
    'assets/illustrations/dashboard.png',
    'assets/illustrations/forum.png',
    'assets/illustrations/events.png',
    'assets/illustrations/my_account.png',
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.requestPermission();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCard(
                        path: imagePaths[0],
                        name: 'Create offer',
                        route: 'createOfferFighter',
                      ),
                      ButtonCard(
                        path: imagePaths[1],
                        route: 'myOffers',
                        name: 'My offers',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCard(
                        path: imagePaths[2],
                        route: 'dashboard',
                        name: 'Dashboard',
                      ),
                      ButtonCard(
                        path: imagePaths[3],
                        route: 'fighterForum',
                        name: 'Fighter forum',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCard(
                        path: imagePaths[4],
                        route: 'newsEvents',
                        name: 'Events',
                      ),
                      ButtonCard(
                        path: imagePaths[5],
                        route: 'myAccountFighter',
                        name: 'My account',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BlackButton(
                      width: 150,
                      height: 40,
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FightersOverview(
                                    isFighterRoute: true,
                                  ))),
                      text: 'All fighters')
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
