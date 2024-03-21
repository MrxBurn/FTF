import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fan_fights_overview/fights_overview_widgets/fights_overview_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page_fan.dart';

class FanFightsOverview extends StatefulWidget {
  const FanFightsOverview({super.key});

  @override
  State<FanFightsOverview> createState() => _FanFightsOverviewState();
}

class _FanFightsOverviewState extends State<FanFightsOverview> {
  CollectionReference offers =
      FirebaseFirestore.instance.collection('fightOffers');

  Stream getAllOffers() {
    return offers.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            const Text(
              'Fights overview',
              style: headerStyle,
            ),
            StreamBuilder(
                stream: getAllOffers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    List snapshotList = snapshot.data.docs.toList();
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 16,
                                ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshotList.length,
                            itemBuilder: (BuildContext context, idx) {
                              return FightsOverviewCard(
                                creator: snapshotList[idx]['creator'],
                                opponent: snapshotList[idx]['opponent'],
                                creatorValue: snapshotList[idx]
                                        ['negotiationValues']
                                    .last['creatorValue']
                                    .toString(),
                                opponentValue: snapshotList[idx]
                                        ['negotiationValues']
                                    .last['opponentValue']
                                    .toString(),
                                weightClass: snapshotList[idx]
                                        ['negotiationValues']
                                    .last['weightClass'],
                                fighterStatus: snapshotList[idx]
                                    ['fighterStatus'],
                                fightDate: snapshotList[idx]
                                        ['negotiationValues']
                                    .last['fightDate'],
                                likes: snapshotList[idx]['like'].length,
                                dislikes: snapshotList[idx]['dislike'].length,
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => ViewOfferPageFan(
                                              offerId: snapshotList[idx]
                                                  ['offerId'],
                                            ))),
                              );
                            }),
                      )
                    ]);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
