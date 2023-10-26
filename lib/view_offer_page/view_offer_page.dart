// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/month_year_picker.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';
import 'package:video_player/video_player.dart';

class ViewOfferPage extends StatefulWidget {
  String? offerId;

  ViewOfferPage({Key? key, this.offerId}) : super(key: key);

  @override
  State<ViewOfferPage> createState() => _ViewOfferPageState();
}

class _ViewOfferPageState extends State<ViewOfferPage> {
  Map<String, dynamic> data = {};

  VideoPlayerController _videoController = VideoPlayerController.asset('');
  Future<void>? _initializeVideoPlayerFuture;

  TextEditingController creatorValue = TextEditingController(text: '0');

  TextEditingController opponentValue = TextEditingController(text: '0');

  TextEditingController messageController = TextEditingController();

  TextEditingController pickerController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  ScrollController scrollController = ScrollController();

  bool fighterNotFoundChecked = false;
  bool contractedChecked = false;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>> getDocument() async {
    DocumentSnapshot res = await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .get();

    data = res.data() as Map<String, dynamic>;

    if (data['fighterNotFoundChecked'] == true &&
        currentUser != data['createdBy'] &&
        data['opponentId'] == '') {
      print('adevarat');
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(widget.offerId)
          .update({'opponentId': currentUser, 'opponent': 'Gageo'});
    }

    return res.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDocument(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (data['calloutVideoURL'] != '') {
              _videoController = VideoPlayerController.networkUrl(
                  Uri.parse(data['calloutVideoURL']));
            }
            DateTime firebaseDate = data['offerExpiryDate'].toDate();

            pickerController.text =
                '${firebaseDate.day}-${firebaseDate.month}-${firebaseDate.year}';
            yearController.text = data['fightDate'].toString();

            _initializeVideoPlayerFuture = _videoController.initialize();

            return SingleChildScrollView(
              child: Column(children: [
                LogoHeader(
                  backRequired: true,
                  onPressed: () => Navigator.pushNamed(context, 'fighterHome'),
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
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: 205,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(lighterBlack),
                        boxShadow: [containerShadowRed],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          data['opponent'],
                          style:
                              const TextStyle(fontSize: 28, color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      constraints: const BoxConstraints(
                          minWidth: 350, maxWidth: 350, minHeight: 150),
                      decoration: BoxDecoration(
                        color: const Color(lighterBlack),
                        boxShadow: [containerShadowWhite],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contract split',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: contractedChecked == true
                                        ? Colors.grey
                                        : Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          readOnly: true,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          controller: creatorValue,
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 24),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      const Text(
                                        'You',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          controller: opponentValue,
                                          decoration: const InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey))),
                                          readOnly: true,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 24),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      const Text(
                                        'Opponent',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              CheckBoxWidget(
                                checkValue: data['contractedChecked'],
                                title: 'N/A - Contracted',
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropDownWidget(
                      disabled: true,
                      changeParentValue: null,
                      dropDownList: rematchClauseList,
                      dropDownValue: data['rematchClause'],
                      dropDownName: 'Rematch clause*',
                    ),
                    DropDownWidget(
                        disabled: true,
                        changeParentValue: null,
                        dropDownValue: data['fighterStatus'],
                        dropDownList: fighterStatusList,
                        dropDownName: 'Fighter status*'),
                    DropDownWidget(
                        disabled: true,
                        changeParentValue: null,
                        dropDownValue: data['weightClass'],
                        dropDownList: weightList,
                        dropDownName: 'Weight class*'),
                    YearPickerWidget(
                      callback: (v) {},
                      disabled: true,
                      leadingText: 'Fight date*',
                      controller: yearController,
                    ),
                    DatePicker(
                      disabled: true,
                      leadingText: 'Offer expiry date*',
                      displayDate: pickerController,
                      callback: (v) => {
                        setState(() => pickerController.text =
                            data['offerExpiryDate'].toDate())
                      },
                    ),
                    data['messasge'] == ''
                        ? Padding(
                            padding: paddingLRT,
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: messageController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    //TODO: FIx null error here
                    data['calloutVideoURL'] != null ||
                            data['calloutVideoURL'] == ''
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TextButton(
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
                                                    _initializeVideoPlayerFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return AspectRatio(
                                                      aspectRatio:
                                                          _videoController.value
                                                              .aspectRatio,
                                                      child: VideoPlayer(
                                                          _videoController),
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
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  ElevatedButton.icon(
                                                      onPressed: () {
                                                        _videoController.play();
                                                      },
                                                      icon: const Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.yellow,
                                                      ),
                                                      label: const Text(
                                                        "Play",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      )),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text(
                                    'Press to review video',
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                  )),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ]),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
