import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ftf/eula/eula_page.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

List<String> imagePaths = [
  'assets/illustrations/fight_offers_fan.jpg',
  'assets/illustrations/all_fighters.jpeg',
  'assets/illustrations/my_fighters.jpg',
  'assets/illustrations/events.png',
  'assets/illustrations/forum.png',
  'assets/illustrations/my_account.png',
];

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class FanHomePage extends StatefulWidget {
  const FanHomePage({super.key});

  @override
  State<FanHomePage> createState() => _FanHomePageState();
}

class _FanHomePageState extends State<FanHomePage> {
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Stream getUser() {
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
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map<String, dynamic>? data =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    if (data?['eula'] == true) {
                      return Padding(
                        padding: paddingLRT,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonCard(
                                  path: imagePaths[0],
                                  name: 'All Fights',
                                  route: 'fanFightsOverview',
                                ),
                                ButtonCard(
                                  path: imagePaths[1],
                                  route: 'fightersOverview',
                                  name: 'All fighters',
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
                                  route: 'myFighters',
                                  name: 'My Fighters',
                                ),
                                ButtonCard(
                                  path: imagePaths[3],
                                  route: 'newsEvents',
                                  name: 'Events',
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
                                  route: 'fanForum',
                                  name: 'Fan Forum',
                                ),
                                ButtonCard(
                                  path: imagePaths[5],
                                  route: 'myAccountFan',
                                  name: 'My account',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
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
                })
          ],
        ),
      ),
    );
  }
}
