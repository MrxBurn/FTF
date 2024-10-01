import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighters_overview_widgets/select_dream_opponent.dart';
import 'package:ftf/main.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/popup_menu_button.dart';
import 'package:ftf/reusableWidgets/text_ellipsis.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/radio_button_options.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';
import 'package:ftf/view_offer_page/view_offer_page_fan.dart';

class FighterView extends StatefulWidget {
  const FighterView(
      {super.key, required this.fighterId, this.isFighterRoute = false});

  final String fighterId;

  final bool isFighterRoute;

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

  String? _groupValue = '';

  Future<void> reportUser(String reportedUser) async {
    await FirebaseFirestore.instance.collection('reportUsers').add({
      "reporter": currentUser,
      "reason": _groupValue,
      "reportedUser": reportedUser
    });

    showSnackBarNoContext(
        text: 'User reported', snackbarKey: snackbarKey, color: Colors.green);
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
                      Transform.translate(
                        offset: Offset(0, -20),
                        child: Text(
                          '${fighter['firstName']} ${fighter['lastName']}',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: paddingLRT,
                        child: Container(
                          height: 170,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              boxShadow: [containerShadowWhite],
                              color: const Color(lighterBlack)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      widget.isFighterRoute == false
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        containerShadowYellow
                                                      ]),
                                                  height: 25,
                                                  width: 100,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: WidgetStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        )),
                                                      ),
                                                      onPressed: onFollowTap,
                                                      child: Text(
                                                        followText,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                followColour),
                                                      )),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 30,
                                        child: CustomPopupMenuButton(
                                          children: [
                                            PopupMenuItem(
                                              child: Text(
                                                'Report user',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    StatefulBuilder(builder:
                                                        (context, dialogState) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Report reason',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18),
                                                    ),
                                                    content: SizedBox(
                                                      height: 350,
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            children: List<
                                                                Widget>.generate(
                                                              reportUserOptions
                                                                  .length,
                                                              (idx) =>
                                                                  RadioListTile(
                                                                title: Text(
                                                                    reportUserOptions[idx]
                                                                            [
                                                                            'text'] ??
                                                                        ''),
                                                                value:
                                                                    reportUserOptions[
                                                                            idx]
                                                                        [
                                                                        'value'],
                                                                groupValue:
                                                                    _groupValue,
                                                                onChanged:
                                                                    (value) {
                                                                  dialogState(
                                                                      () {
                                                                    _groupValue =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          Text(
                                                            "Note: Once reported, you can’t see this user anymore",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                      TextButton(
                                                          onPressed: _groupValue !=
                                                                  ''
                                                              ? () => reportUser(
                                                                      fighter[
                                                                          'id'])
                                                                  .then((v) => widget
                                                                          .isFighterRoute
                                                                      ? Navigator.pushNamed(
                                                                          context,
                                                                          'fighterHome')
                                                                      : Navigator.pushNamed(
                                                                          context,
                                                                          'fanHome'))
                                                              : null,
                                                          child: Text(
                                                            'Report',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: _groupValue !=
                                                                        ''
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .grey),
                                                          ))
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Wrap(
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
                                    SizedBox(
                                      width: 80,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextEllipsis(
                                            maxWidth: 100,
                                            text: fighter['weightClass'],
                                            style: fighterDescriptionStyle,
                                          ),
                                          TextEllipsis(
                                            maxWidth: 100,
                                            text: fighter['fighterType'],
                                            style: fighterDescriptionStyle,
                                          ),
                                          TextEllipsis(
                                            maxWidth: 100,
                                            text: fighter['fighterStatus'],
                                            style: fighterDescriptionStyle,
                                          ),
                                          TextEllipsis(
                                            maxWidth: 100,
                                            text: fighter['gender'],
                                            style: fighterDescriptionStyle,
                                          ),
                                          TextEllipsis(
                                            maxWidth: 100,
                                            text: fighter['nationality'],
                                            style: fighterDescriptionStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.isFighterRoute == false
                                  ? Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: BlackButton(
                                            width: 150,
                                            height: 40,
                                            fontSize: 12,
                                            onPressed: () => showDreamOpponent(
                                                context,
                                                fightersList,
                                                fighter['id']),
                                            text: 'Suggest opponent'),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      fighter['description'].toString().isNotEmpty
                          ? Padding(
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
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                ),
                              ),
                            )
                          : SizedBox()
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

                    return Column(
                      children: [
                        receivedFights.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Received offers',
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
                                                  isFighterRoute:
                                                      widget.isFighterRoute,
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
                                'Sent offers',
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
                                              isFighterRoute:
                                                  widget.isFighterRoute,
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
