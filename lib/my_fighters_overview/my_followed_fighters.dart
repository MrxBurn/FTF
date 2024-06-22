import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighters_overview/fighters_overview.dart';

class MyFollowedFighters extends StatefulWidget {
  const MyFollowedFighters({super.key});

  @override
  State<MyFollowedFighters> createState() => _MyFollowedFightersState();
}

class _MyFollowedFightersState extends State<MyFollowedFighters> {
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
    );
  }
}
