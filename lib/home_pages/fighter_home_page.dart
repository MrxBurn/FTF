import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ftf/eula/eula_page.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';
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
    'assets/illustrations/all_fighters.jpeg',
    'assets/illustrations/offer_code.webp',
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> result = FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser)
        .snapshots();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.requestPermission();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            StreamBuilder(
                stream: getUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map<String, dynamic>? data =
                        snapshot.data?.data() as Map<String, dynamic>?;

                    if (data?['eula'] == true) {
                      return Padding(
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
                                  path: imagePaths[7],
                                  name: 'Enter offer code',
                                  route: 'enterOfferCodePage',
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
                                  path: imagePaths[6],
                                  name: 'All athletes',
                                  route: 'fightersOverview',
                                  navigate: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FightersOverview(
                                          isFighterRoute: true,
                                        ),
                                      )),
                                ),
                                ButtonCard(
                                  path: imagePaths[2],
                                  route: 'dashboard',
                                  name: 'Dashboard',
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
                                  path: imagePaths[1],
                                  route: 'myOffers',
                                  name: 'My offers',
                                ),
                                ButtonCard(
                                  path: imagePaths[3],
                                  route: 'fighterForum',
                                  name: 'Forum',
                                ),
                              ],
                            ),
                            SizedBox(
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
                            const SizedBox(
                              height: 16,
                            )
                          ],
                        ),
                      );
                    } else {
                      return EULAPage(
                        user: data,
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
