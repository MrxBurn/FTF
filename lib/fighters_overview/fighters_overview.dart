import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighter_view.dart';
import 'package:ftf/fighters_overview/fighters_overview_widgets/fighter_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FightersOverview extends StatefulWidget {
  const FightersOverview(
      {super.key, this.future, this.pageTitle, this.isFighterRoute = false});

  final Future<List<dynamic>>? future;

  final String? pageTitle;

  final bool isFighterRoute;

  @override
  State<FightersOverview> createState() => _FightersOverviewState();
}

class _FightersOverviewState extends State<FightersOverview> {
  CollectionReference fighters = FirebaseFirestore.instance.collection('users');
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<List<dynamic>> getFighters() async {
    var result = await fighters
        .where('route', isEqualTo: 'fighter')
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          LogoHeader(backRequired: true),
          Text(
            widget.pageTitle ?? 'Fighters overview',
            style: headerStyle,
          ),
          FutureBuilder(
              future: widget.future ?? getFighters(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = widget.isFighterRoute
                      ? snapshot.data
                          .where((fighter) => fighter['id'] != currentUser)
                          .toList()
                      : snapshot.data;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, idx) {
                          return FighterCard(
                            imageUrl: data[idx]['profileImageURL'],
                            fighterName:
                                '${data[idx]['firstName']} ${data[idx]['lastName']}',
                            weightClass: data[idx]['weightClass'],
                            fighterType: data[idx]['fighterType'],
                            fighterStatus: data[idx]['fighterStatus'],
                            gender: data[idx]['gender'],
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FighterView(
                                          fighterId: data[idx]['id'],
                                          isFighterRoute: widget.isFighterRoute,
                                        ))),
                          );
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      )),
    );
  }
}
