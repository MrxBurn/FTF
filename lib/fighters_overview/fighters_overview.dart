import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighter_view.dart';
import 'package:ftf/fighters_overview/fighters_overview_widgets/fighter_card.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FightersOverview extends StatefulWidget {
  const FightersOverview(
      {super.key,
      this.future,
      this.pageTitle,
      this.isFighterRoute = false,
      this.text =
          'There are no users (fighters) at the moment.\nUsers will be displayed here once they register.'});

  final Future<List<dynamic>>? future;

  final String? pageTitle;

  final bool isFighterRoute;

  final String text;

  @override
  State<FightersOverview> createState() => _FightersOverviewState();
}

class _FightersOverviewState extends State<FightersOverview> {
  CollectionReference fighters = FirebaseFirestore.instance.collection('users');
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<List<dynamic>> getFighters() async {
    List reportedFighters = await FirebaseFirestore.instance
        .collection('reportUsers')
        .where('reporter', isEqualTo: currentUser)
        .get()
        .then((data) =>
            data.docs.map((report) => report.data()['reportedUser']).toList());

    List allFighters = await fighters
        .where('route', isEqualTo: 'fighter')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    var filteredReportedFighters = allFighters
        .where((fighter) => !reportedFighters.contains(fighter['id']));

    return filteredReportedFighters.toList();
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

                  return data.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
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
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => FighterView(
                                                fighterId: data[idx]['id'],
                                                isFighterRoute:
                                                    widget.isFighterRoute,
                                              ))),
                                );
                              }),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 16.0),
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
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
