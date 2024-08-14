import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';

class MyFollowedFightersPage extends StatefulWidget {
  const MyFollowedFightersPage({super.key});

  @override
  State<MyFollowedFightersPage> createState() => _MyFollowedFightersPageState();
}

class _MyFollowedFightersPageState extends State<MyFollowedFightersPage> {
  CollectionReference fighters = FirebaseFirestore.instance.collection('users');

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<List<dynamic>> getFollowedFighters() async {
    List followedFighters = await fighters
        .where('route', isEqualTo: 'fighter')
        .where('followers', arrayContains: currentUser)
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());

    List reportedFighters = await FirebaseFirestore.instance
        .collection('reportUsers')
        .where('reporter', isEqualTo: currentUser)
        .get()
        .then((data) =>
            data.docs.map((report) => report.data()['reportedUser']).toList());

    var filteredReportedFighters = followedFighters
        .where((fighter) => !reportedFighters.contains(fighter['id']));

    return filteredReportedFighters.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FightersOverview(
      pageTitle: 'Your fighters',
      future: getFollowedFighters(),
      text:
          'You are not following any fighters.\nPlease visit the "All Fighters" page to view the fighters currently registered in the app.',
    );
  }
}
