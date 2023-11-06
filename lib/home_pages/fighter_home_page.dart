import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/view_offer_page/view_offer_page.dart';

class FighterHomePage extends StatefulWidget {
  const FighterHomePage({super.key});

  @override
  State<FighterHomePage> createState() => _FighterHomePageState();
}

class _FighterHomePageState extends State<FighterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
            //TODO: remove hard coded value
            text: 'View offer',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewOfferPage(
                      offerId: '0ulJbZEbDZrB0RdVgEzV',
                    ))))
      ]),
    );
  }
}
