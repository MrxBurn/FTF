import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class FighterHomePage extends StatelessWidget {
  const FighterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(backRequired: false),
          const ButtonCard(
            path: 'assets/illustrations/create_offer.jpg',
            route: 'createOfferFighter',
          ),
          // BlackButton(
          //   text: 'Create offer',
          //   onPressed: () => Navigator.pushNamed(context, 'createOfferFighter'),
          // ),
          // BlackButton(
          //   text: 'Log out',
          //   onPressed: () => FirebaseAuth.instance
          //       .signOut()
          //       .then((value) => Navigator.pushNamed(context, 'loginPage')),
          // ),
          // BlackButton(
          //     text: 'Dashboard',
          //     onPressed: () => Navigator.pushNamed(context, 'dashboard')),
          // BlackButton(
          //     text: 'My offers',
          //     onPressed: () => Navigator.pushNamed(context, 'myOffers')),
          // BlackButton(
          //     text: 'Fighter discussions',
          //     onPressed: () => Navigator.pushNamed(context, 'fighterForum')),
          // BlackButton(
          //     text: 'Events',
          //     onPressed: () => Navigator.pushNamed(context, 'newsEvents')),
          // BlackButton(
          //     text: 'My account',
          //     onPressed: () => Navigator.pushNamed(context, 'myAccount')),
        ],
      ),
    );
  }
}
