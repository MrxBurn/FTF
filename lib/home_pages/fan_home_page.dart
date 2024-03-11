import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_cards.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

List<String> imagePaths = [
  'assets/illustrations/fight_offers_fan.jpg',
  'assets/illustrations/all_fighters.jpg',
  'assets/illustrations/my_fighters.jpg',
  'assets/illustrations/events.png',
  'assets/illustrations/forum.png',
  'assets/illustrations/my_account.png',
];

class FanHomePage extends StatelessWidget {
  const FanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            Padding(
              padding: paddingLRT,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonCard(
                        path: imagePaths[0],
                        name: 'Fights Overview',
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
