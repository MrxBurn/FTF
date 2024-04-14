import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/dashboard/dashboard_components/dream_opponents.dart';
import 'package:ftf/dashboard/dashboard_components/most_disliked_offers.dart';
import 'package:ftf/dashboard/dashboard_components/most_liked_offers.dart';
import 'package:ftf/dashboard/dashboard_components/number_followers.dart';
import 'package:ftf/dashboard/dashboard_components/offers_engagement.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  List<dynamic> dreamOpponentsList = [];
  int followersNumber = 0;

  int totalLikes = 0;
  int totalDislikes = 0;

  List<Map<String, dynamic>> mostLikedOffers = [];
  List<Map<String, dynamic>> mostDislikedOffers = [];

  Future<List<dynamic>> getDreamOpponents() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('dreamOpponents')
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    return result
        .toList()
        .reversed
        .where((element) => element['fanIds'].length >= 3)
        .toList();
  }

  Future<int> getFollowers() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    return result?['followers'].toList().length;
  }

  Future<void> getTotalLikes() async {
    var result = await FirebaseFirestore.instance
        .collection('fightOffers')
        .where(Filter.or(Filter('createdBy', isEqualTo: currentUser),
            Filter('opponentId', isEqualTo: currentUser)))
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    for (var element in result) {
      totalLikes += element['likeCount'] as int;
      totalDislikes += element['dislikeCount'] as int;
    }
  }

  Future<List<Map<String, dynamic>>> getMostLikedOffers() async {
    List<Map<String, dynamic>> result = await FirebaseFirestore.instance
        .collection('fightOffers')
        .where(Filter.or(Filter('createdBy', isEqualTo: currentUser),
            Filter('opponentId', isEqualTo: currentUser)))
        .where('likeCount', isNotEqualTo: 0)
        .orderBy('likeCount', descending: true)
        .orderBy('offerExpiryDate', descending: true)
        .limit(3)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList())
        .catchError((e) {
      return e;
    });

    return result;
  }

  Future<List<Map<String, dynamic>>> getMostDislikedOffers() async {
    List<Map<String, dynamic>> result = await FirebaseFirestore.instance
        .collection('fightOffers')
        .where(Filter.or(Filter('createdBy', isEqualTo: currentUser),
            Filter('opponentId', isEqualTo: currentUser)))
        .where('dislikeCount', isNotEqualTo: 0)
        .orderBy('dislikeCount', descending: true)
        .orderBy('offerExpiryDate', descending: true)
        .limit(3)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList())
        .catchError((e) {
      return e;
    });

    return result;
  }

  late Future _future;
  Future<void> future() async {
    await getTotalLikes();
    dreamOpponentsList = await getDreamOpponents();
    followersNumber = await getFollowers();
    mostLikedOffers = await getMostLikedOffers();
    mostDislikedOffers = await getMostDislikedOffers();
  }

  @override
  void initState() {
    super.initState();
    _future = future();
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
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumberFollowers(
                            numberFollowers: followersNumber.toString(),
                          ),
                          OffersEngagement(
                            likes: totalLikes.toString(),
                            dislikes: totalDislikes.toString(),
                          )
                        ],
                      ),
                      DreamOpponents(
                        opponentsList: dreamOpponentsList,
                      ),
                      MostLikedOffers(
                        likedOfferList: mostLikedOffers,
                      ),
                      MostDislikedOffers(dislikedOfferList: mostDislikedOffers),
                      const SizedBox(
                        height: 12,
                      ),
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
