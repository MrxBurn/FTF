import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/checkbox.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/reusableWidgets/search_input.dart';
import 'package:ftf/reusableWidgets/month_year_picker.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/classes.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreateOfferFighter extends StatefulWidget {
  const CreateOfferFighter({super.key});

  @override
  State<CreateOfferFighter> createState() => _CreateOfferFighterState();
}

class _CreateOfferFighterState extends State<CreateOfferFighter> {
  String rematchClause = rematchClauseList.first;

  String fighterStatus = fighterStatusList.first;

  String weight = weightList.first;

  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  TextEditingController creatorValue = TextEditingController(text: '0');

  TextEditingController opponentValue = TextEditingController(text: '0');

  TextEditingController messageController = TextEditingController();

  DateTime today = DateTime.now();

  TextEditingController pickerController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  //TODO: Use Reusable login, register button in all occurences

  String searchValue = '';

  bool fighterNotFoundChecked = false;
  bool contractedChecked = false;

  DateTime dateTimeExpirationDate = DateTime.now();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<UserClass> fighterList = [];

  List<UserClass> queriedList = [];

  bool displaySuggestions = false;

  ScrollController scrollController = ScrollController();

  UserClass selectedSuggestion = UserClass();

  String submitButton = 'Send offer';

  String videoName = '';

  File? video;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  final storageRef = FirebaseStorage.instance.ref();

  CollectionReference fightOffers =
      FirebaseFirestore.instance.collection('fightOffers');

  _callback(String value) {
    rematchClause = value;

    fighterStatus = value;

    weight = value;
  }

  Future<void> getData() async {
    queriedList.clear();
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _usersCollection.where('route', isEqualTo: 'fighter').get();

    // Get data from docs and convert map to List
    fighterList = querySnapshot.docs
        .map((e) => UserClass(
              uid: e.id,
              weightClass: e['weightClass'],
              firstName: e['firstName'],
              lastName: e['lastName'],
              fighterStatus: e['fighterStatus'],
              route: e['route'],
              nationality: e['nationality'],
              gender: e['gender'],
              description: e['description'],
              fighterType: e['fighterType'],
              profileImageURL: e['profileImageURL'],
            ))
        .toList();

    setState(() {
      queriedList.addAll(fighterList);
      displaySuggestions = true;
    });
  }

  void onFighterNotFoundTick(bool? value) {
    setState(() {
      fighterNotFoundChecked = value!;
      if (fighterNotFoundChecked == true) {
        searchValue = '-';
        submitButton = 'Create offer';
      } else {
        searchValue = '';
        submitButton = 'Send offer';
      }
    });
  }

  void onListTileTap(String value) {
    setState(() {
      searchValue = value;
      displaySuggestions = false;
    });
  }

  void onSelectedSuggestion(UserClass value) {
    setState(() {
      selectedSuggestion = value;
      displaySuggestions = false;
    });
  }

  void onContractedTick(bool? value) {
    setState(() {
      contractedChecked = value!;
    });
  }

  void onSearchBarTextChanged(String value) {
    setState(() {
      if (value.isNotEmpty) {
        queriedList = fighterList
            .where((element) =>
                element.firstName.toLowerCase().contains(value.toLowerCase()) ||
                element.lastName.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        queriedList.clear();
        getData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pickerController = TextEditingController(
        text: ('${today.day}-${today.month}-${today.year}').toString());

    yearController = TextEditingController(
        text: ('${today.month}-${today.year}').toString());
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  void uploadVideo(ImageSource source) async {
    try {
      var video = await ImagePicker()
          .pickVideo(source: source, maxDuration: const Duration(seconds: 5));

      if (video == null) return;

      final videoTemporary = File(video.path);

      setState(() {
        this.video = videoTemporary;
        videoName = video.name;

        _videoController = VideoPlayerController.file(this.video!);
        _initializeVideoPlayerFuture = _videoController?.initialize();
      });
      if (context.mounted) {
        showSnackBar(
            text: 'Video uploaded', context: context, color: Colors.green);
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        showSnackBar(text: e.toString(), context: context);
      }
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  saveToFirebase(File? video, String offerId) async {
    if (video != null) {
      Reference file = storageRef.child('calloutVideos/$offerId/$videoName');

      await file.putFile(video);

      String videoURL = (await file.getDownloadURL()).toString();

      await fightOffers.doc(offerId).update({'calloutVideoURL': videoURL});
    }
  }

  onContractSplitChange(String value) {
    const maxValue = 100;

    setState(() {
      creatorValue.text = value;

      opponentValue.text = (maxValue - int.parse(creatorValue.text)).toString();
    });
  }

  Future<void> createDynamicLink(String offerId) async {
    //TODO: Implement for IOS
    var fallbackURL =
        Uri.parse('https://fightertofighter.wixsite.com/ftf-site');

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://fighterTOfighter.com?offerId=$offerId"),

      uriPrefix: "https://f2f.page.link",
      androidParameters: AndroidParameters(
          packageName: "com.ftf.ftf", fallbackUrl: fallbackURL),
      // iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    if (context.mounted) {
      Navigator.pushNamed(context, 'dynamicLinkSummary',
          arguments: {'link': dynamicLink.toString()});
    }
  }

  void createOffer(Object offer) async {
    if (searchValue.isEmpty && !fighterNotFoundChecked) {
      showSnackBar(
          text: 'Please select fighter or tick fighter not found',
          context: context,
          duration: const Duration(seconds: 5));
    } else {
      await fightOffers.add(offer).then((value) => {
            saveToFirebase(video, value.id),
            if (fighterNotFoundChecked) {createDynamicLink(value.id)}
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> offer = {
      'opponent': searchValue,
      'opponentId': selectedSuggestion.uid,
      'fighterNotFoundChecked': fighterNotFoundChecked,
      'contractedChecked': contractedChecked,
      'creatorSplitValue': int.parse(creatorValue.text),
      'opponentSplitValue': int.parse(opponentValue.text),
      'rematchClause': rematchClause,
      'weightClass': weight,
      'fightDate': yearController.text,
      'offerExpiryDate': dateTimeExpirationDate,
      'message': messageController.text,
      'calloutVideoURL': '',
      'like': 0,
      'dislike': 0,
      'createdBy': currentUser,
      'fighterStatus': fighterStatus
    };

    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: [
          LogoHeader(backRequired: true),
          const Text(
            'Send offer',
            style: headerStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          SearchBarWidget(
            onListTileTap: onListTileTap,
            onSelectedSuggestion: onSelectedSuggestion,
            scrollController: scrollController,
            displaySuggestions: displaySuggestions,
            onTap: getData,
            suggestions: queriedList,
            searchbarText: 'Search fighter...',
            onChanged: onSearchBarTextChanged,
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    searchValue,
                    style: const TextStyle(fontSize: 28, color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: paddingLRT,
                child: const Text(
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                    "Your Potential Opponent Doesn't Have FTF? No worries! You can still create your offer. Fill in the necessary information, and we'll generate a link for you to send to your potential opponent via social media."),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: CheckBoxWidget(
                  checkValue: fighterNotFoundChecked,
                  title: 'Fighter not found',
                  onChanged: onFighterNotFoundTick,
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    readOnly: contractedChecked == true
                                        ? true
                                        : false,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: creatorValue,
                                    style: TextStyle(
                                        color: contractedChecked == true
                                            ? Colors.grey
                                            : Colors.yellow,
                                        fontSize: 24),
                                    onChanged: (value) =>
                                        onContractSplitChange(value),
                                    onEditingComplete: () {
                                      if (creatorValue.text == '') {
                                        setState(() {
                                          creatorValue.text = '0';
                                          opponentValue.text = '0';
                                        });
                                      }
                                    },
                                    onTapOutside: (value) {
                                      if (creatorValue.text == '') {
                                        setState(() {
                                          creatorValue.text = '0';
                                          opponentValue.text = '0';
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'You',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: contractedChecked == true
                                          ? Colors.grey
                                          : Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              '%',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: contractedChecked == true
                                      ? Colors.grey
                                      : Colors.white),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: opponentValue,
                                    decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: contractedChecked == true
                                            ? Colors.grey
                                            : Colors.red,
                                        fontSize: 24),
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
                          checkValue: contractedChecked,
                          title: 'N/A - Contracted',
                          onChanged: onContractedTick,
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              DropDownWidget(
                changeParentValue: _callback,
                dropDownList: rematchClauseList,
                dropDownValue: rematchClause,
                dropDownName: 'Rematch clause*',
              ),
              DropDownWidget(
                  changeParentValue: _callback,
                  dropDownValue: fighterStatus,
                  dropDownList: fighterStatusList,
                  dropDownName: 'Fighter status*'),
              DropDownWidget(
                  changeParentValue: _callback,
                  dropDownValue: weight,
                  dropDownList: weightList,
                  dropDownName: 'Weight class*'),
              YearPickerWidget(
                leadingText: 'Fight date*',
                controller: yearController,
              ),
              DatePicker(
                leadingText: 'Offer expiry date*',
                displayDate: pickerController,
                dateTimePicked: dateTimeExpirationDate,
              ),
              Padding(
                padding: paddingLRT,
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(200),
                  ],
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: messageController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Write a message...(200 characters)'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => chooseUploadOption(
                          context: context, uploadVideo: uploadVideo),
                      label: const Text('Attach callout video'),
                      icon: const Icon(Icons.attach_file),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      '(max. 5 seconds)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
              _videoController != null
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
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: _videoController!
                                                    .value.aspectRatio,
                                                child: VideoPlayer(
                                                    _videoController
                                                        as VideoPlayerController),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  _videoController?.play();
                                                },
                                                icon: const Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.yellow,
                                                ),
                                                label: const Text(
                                                  "Play",
                                                  style: TextStyle(
                                                      color: Colors.yellow),
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
              Padding(
                padding: paddingLRT,
                child: const Text(
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                    "Fans can vote and see your offer details, including messages and videos. Financials and market value will be privately discussed between you, your potential opponent, your manager/promoter, and your potential opponent's manager/promoter in our secure chat feature."),
              ),
              const SizedBox(
                height: 16,
              ),
              BlackRoundedButton(
                  isLoading: false /*TODO: Implement is loading */,
                  text: submitButton,
                  onPressed: () => createOffer(offer)),
            ],
          )
        ]),
      ),
    );
  }
}

//TODO: Use this in fighter_image_upload.dart and move to separate file
chooseUploadOption(
    {required BuildContext context,
    required Function(ImageSource source) uploadVideo}) {
  showModalBottomSheet(
    context: context,
    builder: ((context) {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => uploadVideo(ImageSource.camera),
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent),
              child: const Row(
                children: [
                  Icon(Icons.camera_alt),
                  Text(
                    'Camera',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => uploadVideo(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent),
              child: const Row(
                children: [
                  Icon(
                    Icons.image,
                  ),
                  Text(
                    'Gallery',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }),
  );
}
