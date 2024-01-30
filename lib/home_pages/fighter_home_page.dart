import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FighterHomePage extends StatelessWidget {
  const FighterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            Padding(
              padding: paddingLRT,
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCard(
                        name: 'Create offer',
                        path: 'assets/illustrations/create_offer.jpg',
                        route: 'createOfferFighter',
                      ),
                      ButtonCard(
                        path: 'assets/illustrations/my_offers.jpg',
                        route: 'myOffers',
                        name: 'My offers',
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
                        path: 'assets/illustrations/dashboard.png',
                        route: 'dashboard',
                        name: 'Dashboard',
                      ),
                      ButtonCard(
                        path: 'assets/illustrations/forum.jpeg',
                        route: 'fighterForum',
                        name: 'Fighter forum',
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
                        path: 'assets/illustrations/events.png',
                        route: 'newsEvents',
                        name: 'Events',
                      ),
                      ButtonCard(
                        path: 'assets/illustrations/my_account.jpg',
                        route: 'myAccount',
                        name: 'My account',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
