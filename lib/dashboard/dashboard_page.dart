import 'package:flutter/material.dart';
import 'package:ftf/dashboard/dashboard_components/dream_opponents.dart';
import 'package:ftf/dashboard/dashboard_components/number_followers.dart';
import 'package:ftf/dashboard/dashboard_components/offers_engagement.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

String imgPlaceholder =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/310px-Placeholder_view_vector.svg.png';

List opponentList = [
  {
    "image": imgPlaceholder,
    'name': 'Alex Todea',
    'category': 'Heavyweight, Boxer'
  },
  {
    "image": imgPlaceholder,
    'name': 'George Stokes',
    'category': 'Bantamweight, MMA'
  },
  {
    "image": imgPlaceholder,
    'name': 'Mark Robson',
    'category': 'Lightweight, Boxer'
  }
];

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        LogoHeader(backRequired: true),
        const Text(
          'Engagement Dashboard',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberFollowers(
              numberFollowers: '16',
            ),
            OffersEngagement(
              likes: '300',
              dislikes: '50',
            )
          ],
        ),
        DreamOpponents(
          opponentsList: opponentList,
        )
      ]),
    );
  }
}
