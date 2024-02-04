import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/contract_split.dart';
import 'package:ftf/reusableWidgets/date_picker.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/month_year_picker.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';
import 'package:video_player/video_player.dart';

class ViewOfferPageFan extends StatefulWidget {
  const ViewOfferPageFan({super.key, required this.offer});

  final offer;

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

  @override
  void initState() {
    super.initState();
    date = widget.offer['offerExpiryDate'].toDate();
    if (widget.offer['calloutVideoURL'] != '') {
      videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.offer['calloutVideoURL']));
      initializeVideoPlayerFuture = videoController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
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
      Column(children: [
        ContractSplit(
            creator: widget.offer['creator'],
            opponent: widget.offer['opponent'],
            title: 'Contract split - latest offer',
            readOnly: true,
            contractedChecked:
                widget.offer['negotiationValues'].last['contractedChecked'],
            creatorValue: TextEditingController(
                text: widget.offer['negotiationValues'].last['creatorValue']
                    .toString()),
            onTickChanged: (value) => value,
            opponentValue: TextEditingController(
                text: widget.offer['negotiationValues'].last['opponentValue']
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
          dropDownValue: widget.offer['rematchClause'],
          dropDownName: 'Rematch clause*',
        ),
        DropDownWidget(
            disabled: true,
            changeParentValue: null,
            dropDownValue: widget.offer['fighterStatus'],
            dropDownList: fighterStatusList,
            dropDownName: 'Fighter status*'),
        DropDownWidget(
            disabled: true,
            changeParentValue: null,
            dropDownValue: widget.offer['negotiationValues'].last['weightClass']
                .toString(),
            dropDownList: weightList,
            dropDownName: 'Weight class*'),
        YearPickerWidget(
          callback: (v) {},
          disabled: true,
          leadingText: 'Fight date*',
          controller: TextEditingController(
              text: widget.offer['negotiationValues'].last['fightDate']
                  .toString()),
        ),
        DatePicker(
            disabled: true,
            leadingText: 'Offer expiry date*',
            displayDate: TextEditingController(
                text: '${date.day}-${date.month}-${date.year}'),
            callback: (v) => v),
        widget.offer['message'] != ''
            ? Padding(
                padding: paddingLRT,
                child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller:
                      TextEditingController(text: widget.offer['message']),
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : const SizedBox(),
        widget.offer['calloutVideoURL'] != ''
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlackButton(
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
                                    future: initializeVideoPlayerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return AspectRatio(
                                          aspectRatio:
                                              videoController.value.aspectRatio,
                                          child: VideoPlayer(videoController),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () {
                                            videoController.play();
                                          },
                                          icon: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.yellow,
                                          ),
                                          label: const Text(
                                            "Play",
                                            style:
                                                TextStyle(color: Colors.yellow),
                                          )),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      text: 'Press to review video'),
                  widget.offer['negotiationValues'].length > 1
                      ? BlackButton(
                          width: widget.width,
                          height: widget.height,
                          fontSize: widget.fontSize,
                          onPressed: () => showNegotiationHistory(
                              context,
                              widget.offer['negotiationValues'].reversed
                                  .toList(),
                              widget.offer),
                          text: 'Review negotiations ')
                      : const SizedBox(),
                ],
              )
            : const SizedBox()
      ])
    ])));
  }
}
