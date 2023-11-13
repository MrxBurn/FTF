// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/contract_split.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/month_year_picker.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/utils/snack_bar.dart';
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

  TextEditingController initialCreatorValue = TextEditingController(text: '0');

  TextEditingController initialOpponentValue = TextEditingController(text: '0');

  TextEditingController negotiateCreatorValue =
      TextEditingController(text: '0');

  TextEditingController negotiateOpponentValue =
      TextEditingController(text: '0');

  TextEditingController messageController = TextEditingController();

  TextEditingController pickerController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  TextEditingController alertYearController = TextEditingController();

  ScrollController scrollController = ScrollController();

  String opponentName = '';

  bool fighterNotFoundChecked = false;
  bool contractedChecked = false;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  bool buttonsVisible = false;

  bool dialogContractedChecked = false;

  void onContractedTick(bool? value) {
    setState(() {
      contractedChecked = value!;
    });
    if (negotiateOpponentValue.text != '0' ||
        negotiateOpponentValue.text != '' &&
            negotiateCreatorValue.text != '0' ||
        negotiateCreatorValue.text != '') {
      negotiateOpponentValue.text = '0';
      negotiateCreatorValue.text = '0';
    }
  }

  onContractSplitChange(String value) {
    const maxValue = 100;

    negotiateCreatorValue.text = value;

    negotiateOpponentValue.text =
        (maxValue - int.parse(negotiateCreatorValue.text)).toString();
  }

  void onEditingComplete() {
    negotiateCreatorValue.text = '0';
    negotiateOpponentValue.text = '0';
  }

  Future<Map<String, dynamic>> getDocument() async {
    DocumentSnapshot res = await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .get();

    data = res.data() as Map<String, dynamic>;

    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser)
        .get();

    if (data['fighterNotFoundChecked'] == true &&
        currentUser != data['createdBy'] &&
        data['opponentId'] == '') {
      await FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(widget.offerId)
          .update({
        'opponentId': currentUser,
        'opponent': userData['firstName'] + " " + userData['lastName']
      });

      setState(() {
        opponentName = data['opponent'];
      });
    }

    return res.data() as Map<String, dynamic>;
  }

  List updatedNegotiationValues = [];

  Future<void> updateNegotiationValues(int creatorValue, int opponentValue,
      String weight, String fightDate, bool contractedChecked) async {
    updatedNegotiationValues.add({
      'creatorValue': creatorValue,
      'opponentValue': opponentValue,
      'createdAt': DateTime.now(),
      'fightDate': fightDate,
      'weightClass': weight,
      'contractedChecked': contractedChecked
    });
    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .update({
      'negotiationValues': FieldValue.arrayUnion(updatedNegotiationValues)
    });
  }

  Future<void> onDeclineAlertSubmitted() async {
    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .update({'status': 'DECLINED'});
  }

  Future<void> onApproveButtonPressed() async {
    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .update({'status': 'APPROVED'});
    if (context.mounted) {
      Navigator.pushNamed(context, 'fighterHome');
      showSnackBar(
          text: 'Offer approved!', context: context, color: Colors.green);
    }
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
                  _initializeVideoPlayerFuture = _videoController.initialize();
                }
                if (snapshot.data['negotiationValues'].length == 1 &&
                    currentUser == snapshot.data['createdBy']) {
                  buttonsVisible = false;
                } else {
                  buttonsVisible = true;
                }

                DateTime firebaseDate = data['offerExpiryDate'].toDate();

                pickerController.text =
                    '${firebaseDate.day}-${firebaseDate.month}-${firebaseDate.year}';
                yearController.text = snapshot
                    .data['negotiationValues'].last['fightDate']
                    .toString();

                alertYearController.text = yearController.text;

                initialCreatorValue.text = snapshot
                    .data['negotiationValues'].last['creatorValue']
                    .toString();

                initialOpponentValue.text = snapshot
                    .data['negotiationValues'].last['opponentValue']
                    .toString();

                messageController.text = snapshot.data['message'];

                return SingleChildScrollView(
                    child: Column(children: [
                  LogoHeader(
                    backRequired: true,
                    onPressed: () =>
                        Navigator.pushNamed(context, 'fighterHome'),
                  ),
                  const Text(
                    'View offer',
                    style: headerStyle,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(children: [
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
                          snapshot.data['opponent'],
                          style:
                              const TextStyle(fontSize: 28, color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ContractSplit(
                        title: 'Contract split - latest offer',
                        readOnly: true,
                        contractedChecked: snapshot.data['negotiationValues']
                            .last['contractedChecked'],
                        creatorValue: initialCreatorValue,
                        onTickChanged: (value) => value,
                        opponentValue: initialOpponentValue,
                        onContractSplitChange: () {},
                        onEditingComplete: () {}),
                    const SizedBox(
                      height: 16,
                    ),
                    snapshot.data['negotiationValues'].length > 1
                        ? BlackButton(
                            onPressed: () => showNegotiationHistory(
                                context,
                                snapshot.data['negotiationValues'].reversed
                                    .toList()),
                            text: 'Review negotiations ')
                        : const SizedBox(),
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
                        dropDownValue: snapshot
                            .data['negotiationValues'].last['weightClass']
                            .toString(),
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
                    snapshot.data['message'] != ''
                        ? Padding(
                            padding: paddingLRT,
                            child: TextFormField(
                              readOnly: true,
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
                    data['calloutVideoURL'] != ''
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
                    buttonsVisible
                        ? Column(
                            children: [
                              Padding(
                                padding: paddingLRT,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => onApproveButtonPressed(),
                                      child: const Text(
                                        'Approve',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () => showDeclineAlert(
                                            context, onDeclineAlertSubmitted),
                                        child: const Text(
                                          'Decline',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () => showAlerDialog(
                                      context,
                                      contractedChecked,
                                      negotiateCreatorValue,
                                      negotiateOpponentValue,
                                      onContractSplitChange,
                                      onEditingComplete,
                                      (value) => onContractedTick(value),
                                      updateNegotiationValues,
                                      snapshot.data['negotiationValues']
                                          .last['weightClass']
                                          .toString(),
                                      alertYearController),
                                  child: const Text(
                                    'Negotiate',
                                    style: TextStyle(color: Colors.yellow),
                                  ))
                            ],
                          )
                        : const SizedBox()
                  ])
                ]));
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}

void showAlerDialog(
  BuildContext context,
  bool contractedChecked,
  TextEditingController negotiateCreatorValue,
  TextEditingController negotiateOpponentValue,
  Function onTickChanged,
  Function onContractSplitChange,
  Function onEditingComplete,
  Function updateValues,
  String dropdownValue,
  TextEditingController alertYearController,
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, alertState) {
          return Dialog(
              child: SizedBox(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContractSplit(
                  creator: 'Opponent',
                  opponent: 'Creator',
                  creatorColour: Colors.red,
                  opponentColour: Colors.grey,
                  title: 'Contract split',
                  contractedChecked: contractedChecked,
                  creatorValue: negotiateCreatorValue,
                  onTickChanged: (value) => {
                    alertState(
                      () => {
                        contractedChecked = value,
                        if (contractedChecked)
                          {
                            negotiateCreatorValue.text = '0',
                            negotiateOpponentValue.text = '0'
                          }
                      },
                    )
                  },
                  opponentValue: negotiateOpponentValue,
                  onContractSplitChange: (value) => {
                    alertState(() => {
                          negotiateCreatorValue.text = value,
                          negotiateOpponentValue.text =
                              (100 - int.parse(negotiateCreatorValue.text))
                                  .toString()
                        })
                  },
                  onEditingComplete: () {},
                ),
                DropDownWidget(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    changeParentValue: (v) =>
                        {alertState(() => dropdownValue = v)},
                    dropDownValue: dropdownValue,
                    dropDownList: weightList,
                    dropDownName: 'Weight class*'),
                YearPickerWidget(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  callback: (v) => {
                    alertState(
                        () => alertYearController.text = '${v.month}-${v.year}')
                  },
                  leadingText: 'Fight date*',
                  controller: alertYearController,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            updateValues(
                                int.parse(negotiateCreatorValue.text),
                                int.parse(negotiateOpponentValue.text),
                                dropdownValue,
                                alertYearController.text,
                                contractedChecked),
                            Navigator.pushNamed(context, 'fighterHome'),
                            showSnackBar(
                                color: Colors.green,
                                text: 'Negotiation sent!',
                                context: context)
                          },
                          child: const Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
        });
      });
}

void showNegotiationHistory(BuildContext context, List negotiations) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, alertState) {
          return Dialog(
              child: SizedBox(
            height: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Offer creator',
                        style: TextStyle(fontSize: 18, color: Colors.yellow),
                      ),
                      Text(
                        'Opponent',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                      itemCount:
                          negotiations.length < 5 ? negotiations.length : 5,
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                      itemBuilder: (context, index) {
                        DateTime creationTime =
                            negotiations[index]['createdAt'].toDate();

                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Container(
                            height: 110,
                            decoration: const BoxDecoration(
                                color: Color(black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                        negotiations[index]['creatorValue']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.yellow)),
                                    const Text(
                                      '%',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Text(
                                        negotiations[index]['opponentValue']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.red)),
                                  ],
                                ),
                                Text(
                                    'Created at: ${creationTime.day}-${creationTime.month}-${creationTime.year} - ${TimeOfDay.fromDateTime(creationTime).format(context)}'),
                                Text(
                                    'Weight class: ${negotiations[index]['weightClass']}'),
                                Text(
                                    'Fight date: ${negotiations[index]['fightDate']}')
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
        });
      });
}

void showDeclineAlert(BuildContext context, Function onSubmit) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 32, bottom: 8),
            child: SizedBox(
              height: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Are you sure you want to decline the offer?',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            )),
                        TextButton(
                            onPressed: () => {
                                  onSubmit(),
                                  Navigator.pushNamed(context, 'fighterHome'),
                                  showSnackBar(
                                      color: Colors.green,
                                      text: 'Offer declined!',
                                      context: context)
                                },
                            child: const Text('Yes',
                                style: TextStyle(color: Colors.red))),
                      ],
                    )
                  ]),
            ),
          ),
        );
      });
}
