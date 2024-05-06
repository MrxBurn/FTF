import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/contract_split.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/month_year_picker.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';
import 'package:video_player/video_player.dart';

class ViewOfferPageFan extends StatefulWidget {
  const ViewOfferPageFan({super.key, required this.offerId});

  final String offerId;

  final double width = 170;
  final double height = 40;
  final double fontSize = 12;

  @override
  State<ViewOfferPageFan> createState() => _ViewOfferPageFanState();
}

class _ViewOfferPageFanState extends State<ViewOfferPageFan> {
  VideoPlayerController videoController = VideoPlayerController.asset('');
  Future<void>? initializeVideoPlayerFuture;
  DateTime date = DateTime.now();

  String likeText = 'Like';
  String dislikeText = 'Dislike';

  Color likeButtonColour = Colors.white;
  Color dislikeButtonColour = Colors.white;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Map<String, dynamic> dataForLikes = {};

  Color statusColor = Colors.white;

  late Future _future;
  Future<Map<String, dynamic>?> getCurrentFighter() async {
    Map<String, dynamic>? result = await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .get()
        .then((value) => value.data());

    //check if already liked offer
    if (result?['like'].contains(currentUser)) {
      setState(() {
        likeText = 'Liked';
        likeButtonColour = Colors.yellow;
      });
    }
    //check if already disliked offer
    if (result?['dislike'].contains(currentUser)) {
      setState(() {
        dislikeText = 'Disliked';
        dislikeButtonColour = Colors.red;
      });
    }

    return result;
  }

  @override
  void initState() {
    super.initState();

    _future = getCurrentFighter();
  }

  void updateEngagementCount(bool shouldUpdateLike, offer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var postRef = FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(offer['offerId']);

      DocumentSnapshot snapshot = await transaction.get(postRef);
      Map<String, dynamic> fightOffer = snapshot.data() as Map<String, dynamic>;
      if (shouldUpdateLike) {
        transaction.update(postRef, {'likeCount': fightOffer['like'].length});
      } else {
        transaction
            .update(postRef, {'dislikeCount': fightOffer['dislike'].length});
      }
    });
  }

  void onLikePress(offer) async {
    if (likeText != "Liked") {
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(offer['offerId'])
          .update({
        'like': FieldValue.arrayUnion([currentUser]),
        'dislike': FieldValue.arrayRemove([currentUser]),
      }).then((value) => updateEngagementCount(true, offer));

      setState(() {
        likeText = 'Liked';
        likeButtonColour = Colors.yellow;

        //reset like button if necessary
        dislikeText = 'Dislike';
        dislikeButtonColour = Colors.white;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(offer['offerId'])
          .update({
        'like': FieldValue.arrayRemove([currentUser]),
      }).then((value) => updateEngagementCount(true, offer));

      setState(() {
        //reset like button if necessary
        likeText = 'Like';
        likeButtonColour = Colors.white;
      });
    }
  }

  void onDislikePress(offer) async {
    if (dislikeText != 'Disliked') {
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(offer['offerId'])
          .update({
        'like': FieldValue.arrayRemove([currentUser]),
        'dislike': FieldValue.arrayUnion([currentUser]),
        // 'dislikeCount': offer['dislike'].length + 1,
      }).then((value) => updateEngagementCount(false, offer));
      setState(() {
        dislikeText = 'Disliked';
        dislikeButtonColour = Colors.red;

        //reset like button if necessary
        likeText = 'Like';
        likeButtonColour = Colors.white;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(offer['offerId'])
          .update({
        'dislike': FieldValue.arrayRemove([currentUser]),
      }).then((value) => updateEngagementCount(false, offer));
      setState(() {
        dislikeText = 'Dislike';
        dislikeButtonColour = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(
              backRequired: true,
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'View offer',
              style: headerStyle,
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                FutureBuilder(
                    future: _future,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var offer = snapshot.data;

                        dataForLikes = offer;

                        date = offer['offerExpiryDate'].toDate();

                        if (offer['calloutVideoURL'] != '') {
                          videoController = VideoPlayerController.networkUrl(
                              Uri.parse(offer['calloutVideoURL']));
                          initializeVideoPlayerFuture =
                              videoController.initialize();
                        }

                        if (snapshot.data['status'] == "DECLINED") {
                          statusColor = Colors.red;
                        } else if (snapshot.data['status'] == "APPROVED") {
                          statusColor = Colors.green;
                        } else {
                          statusColor = Colors.orange;
                        }

                        return Column(
                          children: [
                            Text(
                              snapshot.data['status'],
                              style: TextStyle(color: statusColor),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ContractSplit(
                                creator: offer['creator'],
                                opponent: offer['opponent'],
                                title: 'Contract split - latest offer',
                                readOnly: true,
                                contractedChecked: offer['negotiationValues']
                                    .last['contractedChecked'],
                                creatorValue: TextEditingController(
                                    text: offer['negotiationValues']
                                        .last['creatorValue']
                                        .toString()),
                                onTickChanged: (value) => value,
                                opponentValue: TextEditingController(
                                    text: offer['negotiationValues']
                                        .last['opponentValue']
                                        .toString()),
                                onContractSplitChange: () {},
                                onEditingComplete: () {}),
                            const SizedBox(
                              height: 16,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            DropDownWidget(
                              disabled: true,
                              changeParentValue: null,
                              dropDownList: rematchClauseList,
                              dropDownValue: offer['rematchClause'],
                              dropDownName: 'Rematch clause*',
                            ),
                            DropDownWidget(
                                disabled: true,
                                changeParentValue: null,
                                dropDownValue: offer['fighterStatus'],
                                dropDownList: fighterStatusList,
                                dropDownName: 'Fighter status*'),
                            DropDownWidget(
                                disabled: true,
                                changeParentValue: null,
                                dropDownValue: offer['negotiationValues']
                                    .last['weightClass']
                                    .toString(),
                                dropDownList: weightList,
                                dropDownName: 'Weight class*'),
                            YearPickerWidget(
                              callback: (v) {},
                              disabled: true,
                              leadingText: 'Fight date*',
                              controller: TextEditingController(
                                  text: offer['negotiationValues']
                                      .last['fightDate']
                                      .toString()),
                            ),
                            DatePicker(
                                disabled: true,
                                leadingText: 'Offer expiry date*',
                                displayDate: TextEditingController(
                                    text:
                                        '${date.day}-${date.month}-${date.year}'),
                                callback: (v) => v),
                            offer['message'] != ''
                                ? Padding(
                                    padding: paddingLRT,
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: TextEditingController(
                                          text: offer['message']),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 25.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                offer['calloutVideoURL'] != ''
                                    ? BlackButton(
                                        width: widget.width,
                                        height: widget.height,
                                        fontSize: widget.fontSize,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  actions: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    FutureBuilder(
                                                      future:
                                                          initializeVideoPlayerFuture,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          return AspectRatio(
                                                            aspectRatio:
                                                                videoController
                                                                    .value
                                                                    .aspectRatio,
                                                            child: VideoPlayer(
                                                                videoController),
                                                          );
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      },
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        ElevatedButton.icon(
                                                            onPressed: () {
                                                              videoController
                                                                  .play();
                                                            },
                                                            icon: const Icon(
                                                              Icons.play_arrow,
                                                              color:
                                                                  Colors.yellow,
                                                            ),
                                                            label: const Text(
                                                              "Play",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .yellow),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        text: 'Press to review video')
                                    : SizedBox(),
                                offer['negotiationValues'].length > 1
                                    ? BlackButton(
                                        width: widget.width,
                                        height: widget.height,
                                        fontSize: widget.fontSize,
                                        onPressed: () => showNegotiationHistory(
                                            context,
                                            offer['negotiationValues']
                                                .reversed
                                                .toList(),
                                            offer),
                                        text: 'Review negotiations ')
                                    : SizedBox()
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlackRoundedButton(
                      isDisabled: dislikeText == 'Disliked',
                      onPressed: () => onLikePress(dataForLikes),
                      text: likeText,
                      textColour: likeButtonColour,
                      icon: Icon(
                        Icons.thumb_up,
                        size: 14,
                        color: likeButtonColour,
                      ),
                      shadowColour: Colors.yellow,
                      isLoading: false,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    BlackRoundedButton(
                      isDisabled: likeText == 'Liked',
                      onPressed: () => onDislikePress(dataForLikes),
                      text: dislikeText,
                      textColour: dislikeButtonColour,
                      icon: Icon(
                        Icons.thumb_down,
                        size: 14,
                        color: dislikeButtonColour,
                      ),
                      isLoading: false,
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
