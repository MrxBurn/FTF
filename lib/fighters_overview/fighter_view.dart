import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighters_overview_widgets/select_dream_opponent.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page_fan.dart';

class FighterView extends StatefulWidget {
  const FighterView({super.key, required this.fighterId});

  final String fighterId;

  @override
  State<FighterView> createState() => _FighterViewState();
}

class _FighterViewState extends State<FighterView> {
  TextStyle fighterDescriptionStyle = const TextStyle(fontSize: 12);

  Color followColour = Colors.white;
  String followText = 'Follow';

  CollectionReference offers =
      FirebaseFirestore.instance.collection('fightOffers');

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  List<Map<String, dynamic>> fightersList = [];

  Future<void> getFighters() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('route', isEqualTo: 'fighter')
        .where('id', isNotEqualTo: widget.fighterId)
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    fightersList = result.toList();
  }

  late Future getCurrentFighterFuture;

  Map<String, dynamic>? currentFighter = {};
  Future<Map<String, dynamic>?> getCurrentFighter() async {
    Map<String, dynamic>? result = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.fighterId)
        .get()
        .then((value) => value.data());

    if (result?['followers'].contains(currentUser)) {
      followText = 'Followed';
      followColour = Colors.yellow;
    } else {
      followText = 'Follow';
      followColour = Colors.white;
    }

    return result;
  }

  Stream getFighterOffers() {
    return offers.snapshots();
  }

  Future<void> onFollowTap() async {
    if (followText != "Followed") {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.fighterId)
          .update({
        'followers': FieldValue.arrayUnion([currentUser]),
      });
      setState(() {
        followText = 'Followed';
        followColour = Colors.yellow;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.fighterId)
          .update({
        'followers': FieldValue.arrayRemove([currentUser]),
      });
      setState(() {
        followText = 'Follow';
        followColour = Colors.white;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentFighterFuture = getCurrentFighter();
    getCurrentFighter().then((value) => currentFighter = value);
    getFighters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            FutureBuilder(
                future: getCurrentFighterFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var fighter = snapshot.data;

                    return Column(children: [
                      Text(
                        '${fighter['firstName']} ${fighter['lastName']}',
                        style: headerStyle,
                      ),
                      Padding(
                        padding: paddingLRT,
                        child: Container(
                          height: 170,
                          decoration: BoxDecoration(
                              boxShadow: [containerShadowWhite],
                              color: const Color(lighterBlack)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: Container(
                                          decoration: BoxDecoration(boxShadow: [
                                            containerShadowYellow
                                          ]),
                                          height: 25,
                                          width: 100,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                )),
                                              ),
                                              onPressed: onFollowTap,
                                              child: Text(
                                                followText,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: followColour),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 40,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Weight class:',
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              'Type:',
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              'Status:',
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              'Gender:',
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              'Nationality:',
                                              style: fighterDescriptionStyle,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fighter['weightClass'],
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              fighter['fighterType'],
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              fighter['fighterStatus'],
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              fighter['gender'],
                                              style: fighterDescriptionStyle,
                                            ),
                                            Text(
                                              fighter['nationality'],
                                              style: fighterDescriptionStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: BlackButton(
                                      width: 150,
                                      height: 40,
                                      fontSize: 12,
                                      onPressed: () => showDreamOpponent(
                                          context, fightersList, fighter['id']),
                                      text: 'Suggest opponent'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: paddingLRT,
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          keyboardType: TextInputType.multiline,
                          readOnly: true,
                          maxLines: null,
                          controller: TextEditingController(
                              text: fighter['description']),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 10.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      )
                    ]);
                  } else {
                    return const SizedBox();
                  }
                }),
            Padding(
              padding: paddingLRT,
              child: StreamBuilder(
                stream: getFighterOffers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    List receivedFights = snapshot.data.docs
                        .toList()
                        .where((element) =>
                            element['opponentId'] == widget.fighterId)
                        .toList();

                    List sentFights = snapshot.data.docs
                        .toList()
                        .where((element) =>
                            element['createdBy'] == widget.fighterId)
                        .toList();

                    return Column(
                      children: [
                        receivedFights.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Received fight offers',
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: 180,
                                    width: double.infinity,
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              width: 16,
                                            ),
                                        itemCount: receivedFights.length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, idx) {
                                          return GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewOfferPageFan(
                                                  offerId: receivedFights[idx]
                                                      ['offerId'],
                                                ),
                                              ),
                                            ),
                                            child: OfferCard(
                                                height: 30,
                                                valueSize: 12,
                                                iconSize: 12,
                                                likes: receivedFights[idx]['like']
                                                    .length,
                                                dislikes: receivedFights[idx]
                                                        ['dislike']
                                                    .length,
                                                creator: receivedFights[idx]
                                                    ['creator'],
                                                opponent: receivedFights[idx]
                                                    ['opponent'],
                                                creatorValue: receivedFights[idx]
                                                        ['negotiationValues']
                                                    .last['creatorValue']
                                                    .toString(),
                                                opponentValue: receivedFights[idx]
                                                        ['negotiationValues']
                                                    .last['opponentValue']
                                                    .toString(),
                                                weightClass: receivedFights[idx]
                                                        ['negotiationValues']
                                                    .last['weightClass'],
                                                fighterStatus:
                                                    receivedFights[idx]
                                                        ['fighterStatus'],
                                                fightDate: receivedFights[idx]['negotiationValues'].last['fightDate']),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        sentFights.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sent fight offers',
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: 170,
                                    width: double.infinity,
                                    child: ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              width: 16,
                                            ),
                                        itemCount: sentFights.length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, idx) {
                                          return GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewOfferPageFan(
                                                  offerId: sentFights[idx]
                                                      ['offerId'],
                                                ),
                                              ),
                                            ),
                                            child: OfferCard(
                                                height: 30,
                                                valueSize: 12,
                                                iconSize: 12,
                                                likes: sentFights[idx]['like']
                                                    .length,
                                                dislikes: sentFights[idx]
                                                        ['dislike']
                                                    .length,
                                                creator: sentFights[idx]
                                                    ['creator'],
                                                opponent: sentFights[idx]
                                                    ['opponent'],
                                                creatorValue: sentFights[idx]
                                                        ['negotiationValues']
                                                    .last['creatorValue']
                                                    .toString(),
                                                opponentValue: sentFights[idx]
                                                        ['negotiationValues']
                                                    .last['opponentValue']
                                                    .toString(),
                                                weightClass: sentFights[idx]
                                                        ['negotiationValues']
                                                    .last['weightClass'],
                                                fighterStatus: sentFights[idx]
                                                    ['fighterStatus'],
                                                fightDate: sentFights[idx]
                                                        ['negotiationValues']
                                                    .last['fightDate']),
                                          );
                                        }),
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: paddingLRT,
              child: StreamBuilder(
                stream: getFighterOffers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    List sentFights = snapshot.data.docs
                        .toList()
                        .where((element) =>
                            element['createdBy'] == widget.fighterId)
                        .toList();

                    return sentFights.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sent fight offers',
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 170,
                                width: double.infinity,
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          width: 16,
                                        ),
                                    itemCount: sentFights.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, idx) {
                                      return GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewOfferPageFan(
                                              offerId: sentFights[idx]
                                                  ['offerId'],
                                            ),
                                          ),
                                        ),
                                        child: OfferCard(
                                            height: 30,
                                            valueSize: 12,
                                            iconSize: 12,
                                            likes:
                                                sentFights[idx]['like'].length,
                                            dislikes: sentFights[idx]['dislike']
                                                .length,
                                            creator: sentFights[idx]['creator'],
                                            opponent: sentFights[idx]
                                                ['opponent'],
                                            creatorValue: sentFights[idx]
                                                    ['negotiationValues']
                                                .last['creatorValue']
                                                .toString(),
                                            opponentValue: sentFights[idx]
                                                    ['negotiationValues']
                                                .last['opponentValue']
                                                .toString(),
                                            weightClass: sentFights[idx]
                                                    ['negotiationValues']
                                                .last['weightClass'],
                                            fighterStatus: sentFights[idx]
                                                ['fighterStatus'],
                                            fightDate: sentFights[idx]
                                                    ['negotiationValues']
                                                .last['fightDate']),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : const SizedBox();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
