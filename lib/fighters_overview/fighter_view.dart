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

          Container(
            decoration: BoxDecoration(boxShadow: [containerShadowWhite]),
            child: const Column(children: [
              Row(
                children: [],
              )
            ]),
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
