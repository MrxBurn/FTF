import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

    allOffers.add(sentOffers);

    allOffers.add(receivedOffers);

    return allOffers;
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
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  boxShadow: [containerShadowWhite],
                  color: const Color(lighterBlack)),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 115.0,
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
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Costel'))
                  ],
                )
              ]),
            ),
          )

          //TODO: Do this later
          // FutureBuilder(future:getFighterOffers() , builder: (BuildContext context, AsyncSnapshot snapshot) {
          //   if(snapshot.connectionState == ConnectionState.done)
          //   {
          //     return const SizedBox();
          //   }
          //   else {
          //     return const Center(child: CircularProgressIndicator(),)
          //   }
          // },),
        ],
      )),
    );
  }
}
