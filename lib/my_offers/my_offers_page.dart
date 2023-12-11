import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page.dart';

class MyOffersPage extends StatelessWidget {
  MyOffersPage({super.key});

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  late DocumentSnapshot<Map<String, dynamic>> userData;

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

    userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();

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

              List totalOffersCurrentUserUnderNegotiation = snapshot.data
                  .toList()
                  .where((element) =>
                      element['negotiationValues'].length >= 1 as bool)
                  .toList();

              return SingleChildScrollView(
                child: Column(children: [
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
                          height: 150,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: createdByList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 16,
                            ),
                            itemBuilder: (BuildContext context, idx) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewOfferPage(
                                                    offerId: createdByList[idx]
                                                        ['offerId'],
                                                  )))
                                    },
                                    child: OfferCard(
                                      creator:
                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
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
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentUserAsOpponent.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 16,
                            ),
                            itemBuilder: (BuildContext context, idx) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewOfferPage(
                                                    offerId:
                                                        currentUserAsOpponent[
                                                            idx]['offerId'],
                                                  )))
                                    },
                                    child: OfferCard(
                                      creator:
                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                      opponent: currentUserAsOpponent[idx]
                                          ['opponent'],
                                      opponentValue: currentUserAsOpponent[idx]
                                              ['negotiationValues']
                                          .last['opponentValue']
                                          .toString(),
                                      creatorValue: currentUserAsOpponent[idx]
                                              ['negotiationValues']
                                          .last['creatorValue']
                                          .toString(),
                                      weightClass: currentUserAsOpponent[idx]
                                              ['negotiationValues']
                                          .last['weightClass'],
                                      fightDate: currentUserAsOpponent[idx]
                                              ['negotiationValues']
                                          .last['fightDate']
                                          .toString(),
                                      fighterStatus: currentUserAsOpponent[idx]
                                          ['fighterStatus'],
                                    ),
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
                            'Ongoing negotiations',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                totalOffersCurrentUserUnderNegotiation.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 16,
                            ),
                            itemBuilder: (BuildContext context, idx) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewOfferPage(
                                                    offerId:
                                                        totalOffersCurrentUserUnderNegotiation[
                                                            idx]['offerId'],
                                                  )))
                                    },
                                    child: OfferCard(
                                      creator:
                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                      opponent:
                                          totalOffersCurrentUserUnderNegotiation[
                                              idx]['opponent'],
                                      opponentValue:
                                          totalOffersCurrentUserUnderNegotiation[
                                                  idx]['negotiationValues']
                                              .last['opponentValue']
                                              .toString(),
                                      creatorValue:
                                          totalOffersCurrentUserUnderNegotiation[
                                                  idx]['negotiationValues']
                                              .last['creatorValue']
                                              .toString(),
                                      weightClass:
                                          totalOffersCurrentUserUnderNegotiation[
                                                  idx]['negotiationValues']
                                              .last['weightClass'],
                                      fightDate:
                                          totalOffersCurrentUserUnderNegotiation[
                                                  idx]['negotiationValues']
                                              .last['fightDate']
                                              .toString(),
                                      fighterStatus:
                                          totalOffersCurrentUserUnderNegotiation[
                                              idx]['fighterStatus'],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                  )
                ]),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
