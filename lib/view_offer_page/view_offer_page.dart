// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/contract_split.dart';
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

  TextEditingController initialCreatorValue = TextEditingController(text: '0');

  TextEditingController initialOpponentValue = TextEditingController(text: '0');

  TextEditingController negotiateCreatorValue =
      TextEditingController(text: '0');

  TextEditingController negotiateOpponentValue =
      TextEditingController(text: '0');

  TextEditingController messageController = TextEditingController();

  TextEditingController pickerController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  ScrollController scrollController = ScrollController();

  String opponentName = '';

  bool fighterNotFoundChecked = false;
  bool contractedChecked = false;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  bool buttonsVisible = false;

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
    // setState(() {
    negotiateCreatorValue.text = '0';
    negotiateOpponentValue.text = '0';
    // });
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

  Future<void> updateNegotiationValues(
      int creatorValue, int opponentValue) async {
    updatedNegotiationValues.add({
      'creatorValue': creatorValue,
      'opponentValue': opponentValue,
      'createdAt': DateTime.now()
    });
    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .update({
      'negotationValues': FieldValue.arrayUnion(updatedNegotiationValues)
    });
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
                if (snapshot.data['negotationValues'].length == 1 &&
                    currentUser == snapshot.data['createdBy']) {
                  buttonsVisible = false;
                } else {
                  buttonsVisible = true;
                }

                DateTime firebaseDate = data['offerExpiryDate'].toDate();

                pickerController.text =
                    '${firebaseDate.day}-${firebaseDate.month}-${firebaseDate.year}';
                yearController.text = data['fightDate'].toString();

                initialCreatorValue.text = snapshot.data['negotationValues'][0]
                        ['creatorValue']
                    .toString();

                initialOpponentValue.text = snapshot.data['negotationValues'][0]
                        ['opponentValue']
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
                        readOnly: true,
                        contractedChecked: contractedChecked,
                        creatorValue: initialCreatorValue,
                        onTickChanged: (value) => value,
                        opponentValue: initialOpponentValue,
                        onContractSplitChange: () {},
                        onEditingComplete: () {}),
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
                                      onPressed: () {},
                                      child: const Text(
                                        'Approve',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {},
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
                                      updateNegotiationValues),
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
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, alertState) {
          return Dialog(
              child: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContractSplit(
                  checkBoxRequired: false,
                  contractedChecked: contractedChecked,
                  creatorValue: negotiateCreatorValue,
                  onTickChanged: (value) => {
                    alertState(
                      () => {
                        contractedChecked = value as bool,
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
                            ),
                            Navigator.pushNamed(context, 'fighterHome'),
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
