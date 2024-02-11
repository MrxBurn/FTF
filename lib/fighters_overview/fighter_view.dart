import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/my_offers/my_offers_widgets/offer_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FighterView extends StatefulWidget {
  const FighterView({super.key, this.fighter});

  final dynamic fighter;

  @override
  State<FighterView> createState() => _FighterViewState();
}

class _FighterViewState extends State<FighterView> {
  TextStyle fighterDescriptionStyle = const TextStyle(fontSize: 12);

  Color followColour = Colors.white;

  TextEditingController bioController = TextEditingController();

  CollectionReference offers =
      FirebaseFirestore.instance.collection('fightOffers');

  Future<List<dynamic>> getFighterOffers() async {
    List allOffers = [];

    var sentOffers = await offers
        .where('createdBy', isEqualTo: widget.fighter['id'])
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    var receivedOffers = await offers
        .where('opponentId', isEqualTo: widget.fighter['id'])
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    allOffers.addAll(sentOffers);

    allOffers.addAll(receivedOffers);

    return allOffers;
  }

  @override
  void initState() {
    super.initState();

    bioController.text = widget.fighter['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          LogoHeader(backRequired: true),
          Text(
            '${widget.fighter['firstName']} ${widget.fighter['lastName']}',
            style: headerStyle,
          ),
          Padding(
            padding: paddingLRT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      boxShadow: [containerShadowWhite],
                      color: const Color(lighterBlack)),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 130.0,
                            ),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 8, top: 16),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.fighter['weightClass'],
                                    style: fighterDescriptionStyle,
                                  ),
                                  Text(
                                    widget.fighter['fighterType'],
                                    style: fighterDescriptionStyle,
                                  ),
                                  Text(
                                    widget.fighter['fighterStatus'],
                                    style: fighterDescriptionStyle,
                                  ),
                                  Text(
                                    widget.fighter['gender'],
                                    style: fighterDescriptionStyle,
                                  ),
                                  Text(
                                    widget.fighter['nationality'],
                                    style: fighterDescriptionStyle,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 6, left: 64),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [containerShadowYellow]),
                            height: 25,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Follow',
                                  style: TextStyle(
                                      fontSize: 12, color: followColour),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: TextInputType.multiline,
                  readOnly: true,
                  maxLines: null,
                  controller: bioController,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Received fights',
                ),
                FutureBuilder(
                  future: getFighterOffers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List receivedFights = snapshot.data
                          .toList()
                          .where((element) =>
                              element['opponentId'] == widget.fighter['id'])
                          .toList();

                      print(receivedFights);

                      return SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 16,
                                ),
                            itemCount: receivedFights.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, idx) {
                              return OfferCard(
                                  creator: receivedFights[idx]['creator'],
                                  opponent: receivedFights[idx]['opponent'],
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
                                  fighterStatus: receivedFights[idx]
                                      ['fighterStatus'],
                                  fightDate: receivedFights[idx]
                                          ['negotiationValues']
                                      .last['fightDate']);
                            }),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
