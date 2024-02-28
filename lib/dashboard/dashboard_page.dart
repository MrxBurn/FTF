import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/dashboard/dashboard_components/dream_opponents.dart';
import 'package:ftf/dashboard/dashboard_components/most_disliked_offers.dart';
import 'package:ftf/dashboard/dashboard_components/most_liked_offers.dart';
import 'package:ftf/dashboard/dashboard_components/number_followers.dart';
import 'package:ftf/dashboard/dashboard_components/offers_engagement.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/utils/general.dart';

List opponentList = [
  {
    "image": imgPlaceholder,
    'name': 'Alex Todea',
    'fighterType': 'Heavyweight, Boxer'
  },
  {
    "image": imgPlaceholder,
    'name': 'George Stokes',
    'fighterType': 'Bantamweight, MMA'
  },
  {
    "image": imgPlaceholder,
    'name': 'Mark Robson',
    'fighterType': 'Lightweight, Boxer'
  }
];

List likedOffersList = [
  {
    'creator': 'Alex Todea',
    'creatorValue': '65',
    'opponent': 'George Stokes',
    'opponentValue': '35',
  },
  {
    'creator': 'Alex Todea',
    'creatorValue': '20',
    'opponent': 'Michael Nillson',
    'opponentValue': '80',
  },
  {
    'creator': 'Alex Todea',
    'creatorValue': '30',
    'opponent': 'Karl Grey',
    'opponentValue': '70',
  },
];

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  List<dynamic> dreamOpponentsList = [];
  int followersNumber = 0;

  Future<void> getDreamOpponents() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('dreamOpponents')
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    var filteredResult = result
        .toList()
        .reversed
        .where((element) => element['fanIds'].length >= 3);

    dreamOpponentsList += filteredResult.toList();
  }

  Future<void> getFollowers() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    followersNumber = result?['followers'].toList().length;
  }

  Future<void> future() async {
    await getDreamOpponents();
    await getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          LogoHeader(backRequired: true),
          const Text(
            'Engagement Dashboard',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 16,
          ),
          FutureBuilder(
              future: future(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(dreamOpponentsList);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumberFollowers(
                            numberFollowers: followersNumber.toString(),
                          ),
                          OffersEngagement(
                            likes: '300',
                            dislikes: '50',
                          )
                        ],
                      ),
                      DreamOpponents(
                        opponentsList: dreamOpponentsList,
                      ),
                      MostLikedOffers(
                        likedOfferList: likedOffersList,
                      ),
                      MostDislikedOffers(dislikedOfferList: likedOffersList)
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ]),
      ),
    );
  }
}
