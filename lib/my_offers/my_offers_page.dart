// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';

class MyOffersPage extends StatelessWidget {
  MyOffersPage({super.key});

  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

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

    List reportedFighters = await FirebaseFirestore.instance
        .collection('reportUsers')
        .get()
        .then((data) =>
            data.docs.map((report) => report.data()['reportedUser']).toList());

    combinedList.addAll(createdByData);
    combinedList.addAll(opponentData);

    return combinedList
        .where((offer) =>
            !reportedFighters.contains(offer['createdBy']) &&
            !reportedFighters.contains(offer['opponentId']))
        .toList();
  }

  final double cardHeight = 200;

  final double likeHeight = 30;
  final double likeValueSize = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getOffers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List createdByList = snapshot.data
                  .toList()
                  .where((element) =>
                      element['createdBy'] == currentUser &&
                      element['status'] == 'PENDING')
                  .toList();

              List currentUserAsOpponent = snapshot.data
                  .toList()
                  .where((element) =>
                      element['opponentId'] == currentUser &&
                      element['status'] == 'PENDING')
                  .toList();

              List totalOffersCurrentUserUnderNegotiation = snapshot.data
                  .toList()
                  .where((element) =>
                      element['negotiationValues'].length >= 1 as bool &&
                      element['status'] == 'PENDING')
                  .toList();

              List agreedFights = snapshot.data
                  .toList()
                  .where((element) => element['status'] == 'APPROVED')
                  .toList();

              List declinedFights = snapshot.data
                  .toList()
                  .where((element) => element['status'] == 'DECLINED')
                  .toList();

              return SingleChildScrollView(
                child: snapshot.data.length != 0
                    ? Column(children: [
                        LogoHeader(backRequired: true),
                        const Text(
                          'Offers overview',
                          style: headerStyle,
                        ),
                        Padding(
                          padding: paddingLRT,
                          child: SizedBox(
                            child: Column(children: [
                              createdByList.isNotEmpty
                                  ? Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Offers made',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: cardHeight,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: createdByList.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              width: 16,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewOfferPage(
                                                            offerId:
                                                                createdByList[
                                                                        idx]
                                                                    ['offerId'],
                                                          ),
                                                        ),
                                                      )
                                                    },
                                                    child: OfferCard(
                                                      height: likeHeight,
                                                      valueSize: likeValueSize,
                                                      iconSize: likeValueSize,
                                                      likes: createdByList[idx]
                                                              ['like']
                                                          .length,
                                                      dislikes:
                                                          createdByList[idx]
                                                                  ['dislike']
                                                              .length,
                                                      creator:
                                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                                      opponent:
                                                          createdByList[idx]
                                                              ['opponent'],
                                                      opponentValue: createdByList[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['opponentValue']
                                                          .toString(),
                                                      creatorValue: createdByList[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['creatorValue']
                                                          .toString(),
                                                      weightClass: createdByList[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['weightClass'],
                                                      fightDate: createdByList[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['fightDate']
                                                          .toString(),
                                                      fighterStatus:
                                                          createdByList[idx]
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
                                      ],
                                    )
                                  : const SizedBox(),
                              currentUserAsOpponent.isNotEmpty
                                  ? Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Offers received',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: cardHeight,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                currentUserAsOpponent.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              width: 16,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewOfferPage(
                                                                    offerId: currentUserAsOpponent[
                                                                            idx]
                                                                        [
                                                                        'offerId'],
                                                                  )))
                                                    },
                                                    child: OfferCard(
                                                      height: likeHeight,
                                                      valueSize: likeValueSize,
                                                      iconSize: likeValueSize,
                                                      likes:
                                                          currentUserAsOpponent[
                                                                  idx]['like']
                                                              .length,
                                                      dislikes:
                                                          currentUserAsOpponent[
                                                                      idx]
                                                                  ['dislike']
                                                              .length,
                                                      creator:
                                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                                      opponent:
                                                          currentUserAsOpponent[
                                                              idx]['creator'],
                                                      opponentValue:
                                                          currentUserAsOpponent[
                                                                      idx]
                                                                  [
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString(), //These values are the other way around since the current user is now the opponent
                                                      creatorValue:
                                                          currentUserAsOpponent[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString(),
                                                      weightClass:
                                                          currentUserAsOpponent[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last['weightClass'],
                                                      fightDate:
                                                          currentUserAsOpponent[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last['fightDate']
                                                              .toString(),
                                                      fighterStatus:
                                                          currentUserAsOpponent[
                                                                  idx]
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
                                      ],
                                    )
                                  : const SizedBox(),
                              totalOffersCurrentUserUnderNegotiation.isNotEmpty
                                  ? Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Ongoing negotiations',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: cardHeight,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                totalOffersCurrentUserUnderNegotiation
                                                    .length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              width: 16,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewOfferPage(
                                                                    offerId: totalOffersCurrentUserUnderNegotiation[
                                                                            idx]
                                                                        [
                                                                        'offerId'],
                                                                  )))
                                                    },
                                                    child: OfferCard(
                                                      height: likeHeight,
                                                      valueSize: likeValueSize,
                                                      iconSize: likeValueSize,
                                                      likes:
                                                          totalOffersCurrentUserUnderNegotiation[
                                                                  idx]['like']
                                                              .length,
                                                      dislikes:
                                                          totalOffersCurrentUserUnderNegotiation[
                                                                      idx]
                                                                  ['dislike']
                                                              .length,
                                                      creator:
                                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                                      opponent: totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? totalOffersCurrentUserUnderNegotiation[
                                                              idx]['creator']
                                                          : totalOffersCurrentUserUnderNegotiation[
                                                              idx]['opponent'],
                                                      opponentValue: totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString()
                                                          : totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString(),
                                                      creatorValue: totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString()
                                                          : totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString(),
                                                      weightClass:
                                                          totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last['weightClass'],
                                                      fightDate:
                                                          totalOffersCurrentUserUnderNegotiation[
                                                                      idx][
                                                                  'negotiationValues']
                                                              .last['fightDate']
                                                              .toString(),
                                                      fighterStatus:
                                                          totalOffersCurrentUserUnderNegotiation[
                                                                  idx]
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
                                      ],
                                    )
                                  : const SizedBox(),
                              agreedFights.isNotEmpty
                                  ? Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Agreed fights',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: cardHeight,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: agreedFights.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              width: 16,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewOfferPage(
                                                                    offerId: agreedFights[
                                                                            idx]
                                                                        [
                                                                        'offerId'],
                                                                  )))
                                                    },
                                                    child: OfferCard(
                                                      height: likeHeight,
                                                      valueSize: likeValueSize,
                                                      iconSize: likeValueSize,
                                                      likes: agreedFights[idx]
                                                              ['like']
                                                          .length,
                                                      dislikes:
                                                          agreedFights[idx]
                                                                  ['dislike']
                                                              .length,
                                                      creator:
                                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                                      opponent: agreedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? agreedFights[idx]
                                                              ['creator']
                                                          : agreedFights[idx]
                                                              ['opponent'],
                                                      opponentValue: agreedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? agreedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString()
                                                          : agreedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString(),
                                                      creatorValue: agreedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? agreedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString()
                                                          : agreedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString(),
                                                      weightClass: agreedFights[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['weightClass'],
                                                      fightDate: agreedFights[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['fightDate']
                                                          .toString(),
                                                      fighterStatus:
                                                          agreedFights[idx]
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
                                      ],
                                    )
                                  : const SizedBox(),
                              declinedFights.isNotEmpty
                                  ? Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Declined fights',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: cardHeight,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: declinedFights.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              width: 16,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, idx) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewOfferPage(
                                                                    offerId: declinedFights[
                                                                            idx]
                                                                        [
                                                                        'offerId'],
                                                                  )))
                                                    },
                                                    child: OfferCard(
                                                      height: likeHeight,
                                                      valueSize: likeValueSize,
                                                      iconSize: likeValueSize,
                                                      likes: declinedFights[idx]
                                                              ['like']
                                                          .length,
                                                      dislikes:
                                                          declinedFights[idx]
                                                                  ['dislike']
                                                              .length,
                                                      creator:
                                                          '${userData.data()?['firstName']} ${userData.data()?['lastName']}',
                                                      opponent: declinedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? declinedFights[idx]
                                                              ['creator']
                                                          : declinedFights[idx]
                                                              ['opponent'],
                                                      opponentValue: declinedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? declinedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString()
                                                          : declinedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString(),
                                                      creatorValue: declinedFights[
                                                                      idx][
                                                                  'opponentId'] ==
                                                              currentUser
                                                          ? declinedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'opponentValue']
                                                              .toString()
                                                          : declinedFights[idx][
                                                                  'negotiationValues']
                                                              .last[
                                                                  'creatorValue']
                                                              .toString(),
                                                      weightClass: declinedFights[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['weightClass'],
                                                      fightDate: declinedFights[
                                                                  idx][
                                                              'negotiationValues']
                                                          .last['fightDate']
                                                          .toString(),
                                                      fighterStatus:
                                                          declinedFights[idx]
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
                                      ],
                                    )
                                  : const SizedBox(),
                            ]),
                          ),
                        ),
                      ])
                    : Column(
                        children: [
                          LogoHeader(backRequired: true),
                          Padding(
                            padding: paddingLRT,
                            child: const Text(
                                "You have no offers on the table. Start engaging with the fight fan base and other fighters by creating exciting fight offers! Set up your first offer now to connect with potential opponents and fans.\nLet the world know what you're about."),
                          ),
                        ],
                      ),
              );
            } else {
              return Column(
                children: [
                  LogoHeader(backRequired: true),
                  const CircularProgressIndicator(),
                ],
              );
            }
          }),
    );
  }
}
