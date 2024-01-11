import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class FighterHomePage extends StatefulWidget {
  const FighterHomePage({super.key});

  @override
  State<FighterHomePage> createState() => _FighterHomePageState();
}

class _FighterHomePageState extends State<FighterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(backRequired: false),
          BlackButton(
            text: 'Create offer',
            onPressed: () => Navigator.pushNamed(context, 'createOfferFighter'),
          ),
          BlackButton(
            text: 'Log out',
            onPressed: () => FirebaseAuth.instance
                .signOut()
                .then((value) => Navigator.pushNamed(context, 'loginPage')),
          ),
          BlackButton(
              text: 'Dashboard',
              onPressed: () => Navigator.pushNamed(context, 'dashboard')),
          BlackButton(
              text: 'My offers',
              onPressed: () => Navigator.pushNamed(context, 'myOffers')),
          BlackButton(
              text: 'Fighter discussions',
              onPressed: () => Navigator.pushNamed(context, 'fighterForum')),
          BlackButton(
              text: 'News & Events',
              onPressed: () => Navigator.pushNamed(context, 'newsEvents')),
        ],
      ),
    );
  }
}
