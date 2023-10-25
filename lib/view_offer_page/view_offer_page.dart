// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class ViewOfferPage extends StatefulWidget {
  String? offerId;

  ViewOfferPage({Key? key, this.offerId}) : super(key: key);

  @override
  State<ViewOfferPage> createState() => _ViewOfferPageState();
}

class _ViewOfferPageState extends State<ViewOfferPage> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    if (widget.offerId != null) {
      FirebaseFirestore.instance
          .collection('fightOffers')
          .doc(widget.offerId)
          .get()
          .then(
              (DocumentSnapshot value) =>
                  {data = value.data() as Map<String, dynamic>},
              onError: (e) => print('Error getting data'));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.offerId);
    return Scaffold(
      body: Column(
        children: [
          // LogoHeader(
          //   backRequired: true,
          //   onPressed: () => Navigator.pushNamed(context, 'fighterHome'),
          // ),
          //  const Text(
          //   'Send offer',
          //   style: headerStyle,
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          // SearchBarWidget(
          //   onListTileTap: onListTileTap,
          //   onSelectedSuggestion: onSelectedSuggestion,
          //   scrollController: scrollController,
          //   displaySuggestions: displaySuggestions,
          //   onTap: getData,
          //   suggestions: queriedList,
          //   searchbarText: 'Search fighter...',
          //   onChanged: onSearchBarTextChanged,
          // ),
          // Column(
          //   children: [
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     Container(
          //       width: 205,
          //       height: 68,
          //       decoration: BoxDecoration(
          //         color: const Color(lighterBlack),
          //         boxShadow: [containerShadowRed],
          //         borderRadius: const BorderRadius.all(Radius.circular(10)),
          //       ),
          //       child: Center(
          //         child: Text(
          //           searchValue,
          //           style: const TextStyle(fontSize: 28, color: Colors.red),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: paddingLRT,
          //       child: const Text(
          //           style: TextStyle(fontSize: 10, color: Colors.grey),
          //           textAlign: TextAlign.center,
          //           "Your Potential Opponent Doesn't Have FTF? No worries! You can still create your offer. Fill in the necessary information, and we'll generate a link for you to send to your potential opponent via social media."),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 24, right: 24),
          //       child: CheckBoxWidget(
          //         checkValue: fighterNotFoundChecked,
          //         title: 'Fighter not found',
          //         onChanged: onFighterNotFoundTick,
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     Container(
          //       constraints: const BoxConstraints(
          //           minWidth: 350, maxWidth: 350, minHeight: 150),
          //       decoration: BoxDecoration(
          //         color: const Color(lighterBlack),
          //         boxShadow: [containerShadowWhite],
          //         borderRadius: const BorderRadius.all(Radius.circular(10)),
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.all(15.0),
          //         child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Contract split',
          //                 style: TextStyle(
          //                     fontSize: 20,
          //                     color: contractedChecked == true
          //                         ? Colors.grey
          //                         : Colors.white),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: [
          //                   Column(
          //                     children: [
          //                       SizedBox(
          //                         width: 50,
          //                         child: TextField(
          //                           readOnly: contractedChecked == true
          //                               ? true
          //                               : false,
          //                           textAlign: TextAlign.center,
          //                           keyboardType: TextInputType.number,
          //                           controller: creatorValue,
          //                           style: TextStyle(
          //                               color: contractedChecked == true
          //                                   ? Colors.grey
          //                                   : Colors.yellow,
          //                               fontSize: 24),
          //                           onChanged: (value) =>
          //                               onContractSplitChange(value),
          //                           onEditingComplete: () {
          //                             if (creatorValue.text == '') {
          //                               setState(() {
          //                                 creatorValue.text = '0';
          //                                 opponentValue.text = '0';
          //                               });
          //                             }
          //                           },
          //                           onTapOutside: (value) {
          //                             if (creatorValue.text == '') {
          //                               setState(() {
          //                                 creatorValue.text = '0';
          //                                 opponentValue.text = '0';
          //                               });
          //                             }
          //                           },
          //                         ),
          //                       ),
          //                       const SizedBox(
          //                         height: 6,
          //                       ),
          //                       Text(
          //                         'You',
          //                         style: TextStyle(
          //                             fontSize: 12,
          //                             color: contractedChecked == true
          //                                 ? Colors.grey
          //                                 : Colors.white),
          //                       ),
          //                     ],
          //                   ),
          //                   Text(
          //                     '%',
          //                     style: TextStyle(
          //                         fontSize: 24,
          //                         color: contractedChecked == true
          //                             ? Colors.grey
          //                             : Colors.white),
          //                   ),
          //                   Column(
          //                     children: [
          //                       SizedBox(
          //                         width: 50,
          //                         child: TextField(
          //                           controller: opponentValue,
          //                           decoration: const InputDecoration(
          //                               focusedBorder: UnderlineInputBorder(
          //                                   borderSide: BorderSide(
          //                                       color: Colors.grey))),
          //                           readOnly: true,
          //                           textAlign: TextAlign.center,
          //                           style: TextStyle(
          //                               color: contractedChecked == true
          //                                   ? Colors.grey
          //                                   : Colors.red,
          //                               fontSize: 24),
          //                         ),
          //                       ),
          //                       const SizedBox(
          //                         height: 6,
          //                       ),
          //                       const Text(
          //                         'Opponent',
          //                         style: TextStyle(fontSize: 12),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //               CheckBoxWidget(
          //                 checkValue: contractedChecked,
          //                 title: 'N/A - Contracted',
          //                 onChanged: onContractedTick,
          //               )
          //             ]),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     DropDownWidget(
          //       dropDownList: rematchClause,
          //       dropDownValue: rematchClause.first,
          //       dropDownName: 'Rematch clause*',
          //     ),
          //     DropDownWidget(
          //         dropDownValue: fighterStatusValue,
          //         dropDownList: fighterStatusList,
          //         dropDownName: 'Fighter status*'),
          //     DropDownWidget(
          //         dropDownValue: weightList.first,
          //         dropDownList: weightList,
          //         dropDownName: 'Weight class*'),
          //     YearPickerWidget(
          //       leadingText: 'Fight date*',
          //       controller: yearController,
          //     ),
          //     DatePicker(
          //       leadingText: 'Offer expiry date*',
          //       displayDate: pickerController,
          //       dateTimePicked: dateTimeExpirationDate,
          //     ),
          //     Padding(
          //       padding: paddingLRT,
          //       child: TextFormField(
          //         keyboardType: TextInputType.multiline,
          //         maxLines: null,
          //         controller: messageController,
          //         decoration: const InputDecoration(
          //             contentPadding: EdgeInsets.symmetric(
          //                 vertical: 25.0, horizontal: 10.0),
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.all(Radius.circular(15))),
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.white)),
          //             labelStyle: TextStyle(color: Colors.grey),
          //             hintText: 'Write a message...(200 characters)'),
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
          //       child: Row(
          //         children: [
          //           ElevatedButton.icon(
          //             onPressed: () => chooseUploadOption(
          //                 context: context, uploadVideo: uploadVideo),
          //             label: const Text('Attach callout video'),
          //             icon: const Icon(Icons.attach_file),
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           const Text(
          //             '(max. 5 seconds)',
          //             style: TextStyle(fontSize: 12, color: Colors.grey),
          //           )
          //         ],
          //       ),
          //     ),
          //     _videoController != null
          //         ? Padding(
          //             padding: const EdgeInsets.only(left: 16),
          //             child: Align(
          //               alignment: Alignment.topLeft,
          //               child: TextButton(
          //                   onPressed: () {
          //                     showDialog(
          //                         context: context,
          //                         builder: (BuildContext context) {
          //                           return AlertDialog(
          //                             actions: [
          //                               const SizedBox(
          //                                 height: 10,
          //                               ),
          //                               FutureBuilder(
          //                                 future: _initializeVideoPlayerFuture,
          //                                 builder: (context, snapshot) {
          //                                   if (snapshot.connectionState ==
          //                                       ConnectionState.done) {
          //                                     return AspectRatio(
          //                                       aspectRatio: _videoController!
          //                                           .value.aspectRatio,
          //                                       child: VideoPlayer(
          //                                           _videoController
          //                                               as VideoPlayerController),
          //                                     );
          //                                   } else {
          //                                     return const SizedBox();
          //                                   }
          //                                 },
          //                               ),
          //                               Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.spaceBetween,
          //                                 children: [
          //                                   TextButton(
          //                                     onPressed: () =>
          //                                         Navigator.of(context).pop(),
          //                                     child: const Text(
          //                                       'Cancel',
          //                                       style: TextStyle(
          //                                           color: Colors.white),
          //                                     ),
          //                                   ),
          //                                   ElevatedButton.icon(
          //                                       onPressed: () {
          //                                         _videoController?.play();
          //                                       },
          //                                       icon: const Icon(
          //                                         Icons.play_arrow,
          //                                         color: Colors.yellow,
          //                                       ),
          //                                       label: const Text(
          //                                         "Play",
          //                                         style: TextStyle(
          //                                             color: Colors.yellow),
          //                                       )),
          //                                 ],
          //                               )
          //                             ],
          //                           );
          //                         });
          //                   },
          //                   child: const Text(
          //                     'Press to review video',
          //                     style: TextStyle(
          //                         color: Colors.white,
          //                         decoration: TextDecoration.underline),
          //                   )),
          //             ),
          //           )
          //         : const SizedBox(),
          Padding(
            padding: paddingLRT,
            child: const Text(
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
                "Fans can vote and see your offer details, including messages and videos. Financials and market value will be privately discussed between you, your potential opponent, your manager/promoter, and your potential opponent's manager/promoter in our secure chat feature."),
          ),
        ],
      ),
    );
  }
}
