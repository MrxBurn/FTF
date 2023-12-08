import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class MyOffersPage extends StatelessWidget {
  MyOffersPage({super.key});

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<List<dynamic>> getOffers() async {
    var createdByData = await FirebaseFirestore.instance
        .collection('fightOffers')
        .where('createdBy', isEqualTo: currentUser)
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    var opponentData = await FirebaseFirestore.instance
        .collection('fightOffers')
        .where('opponentId', isEqualTo: currentUser)
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    List combinedList = [];

    combinedList.addAll(createdByData);
    combinedList.addAll(opponentData);

    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getOffers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List createdByList = snapshot.data
                  .toList()
                  .where((element) => element['createdBy'] == currentUser)
                  .toList();

              List currentUserAsOpponent = snapshot.data
                  .toList()
                  .where((element) => element['opponentId'] == currentUser)
                  .toList();

              List totalOffersCurrentUser = snapshot.data.toList();

              return Column(children: [
                LogoHeader(backRequired: true),
                const Text(
                  'Offers overview',
                  style: headerStyle,
                ),
                Padding(
                  padding: paddingLRT,
                  child: SizedBox(
                    child: Column(children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Offers made',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: createdByList.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 24,
                          ),
                          itemBuilder: (BuildContext context, idx) {
                            return Column(
                              children: [
                                OfferCard(
                                  creator: 'costel',
                                  opponent: createdByList[idx]['opponent'],
                                  opponentValue: createdByList[idx]
                                          ['negotiationValues']
                                      .last['opponentValue']
                                      .toString(),
                                  creatorValue: createdByList[idx]
                                          ['negotiationValues']
                                      .last['creatorValue']
                                      .toString(),
                                  weightClass: createdByList[idx]
                                          ['negotiationValues']
                                      .last['weightClass'],
                                  fightDate: createdByList[idx]
                                          ['negotiationValues']
                                      .last['fightDate']
                                      .toString(),
                                  fighterStatus: createdByList[idx]
                                      ['fighterStatus'],
                                ),
                                const SizedBox(
                                  height: 16,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Offers received',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ongoing negotiations',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ]),
                  ),
                )
              ]);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
