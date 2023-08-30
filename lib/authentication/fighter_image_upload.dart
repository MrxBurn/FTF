import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class FighterImageUpload extends StatefulWidget {
  const FighterImageUpload({super.key});

  @override
  State<FighterImageUpload> createState() => _FighterImageUploadState();
}

class _FighterImageUploadState extends State<FighterImageUpload> {
  String firstName = '';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    CollectionReference fighterUsers =
        FirebaseFirestore.instance.collection('fighterUsers');

    var uid = firebaseAuth.currentUser?.uid;

    fighterUsers
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) => {firstName = doc['firstName']});

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LogoHeader(backRequired: false),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $firstName!',
                style: headerStyle,
              ),
              Row(
                children: [
                  const Text(
                    'Upload your profile picture?',
                    style: bodyStyle,
                  ),
                  TextButton(
                      style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () => {/* TODO: Implement image upload */},
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )),
                ],
              ),
              //TODO: Implement image display widget
            ],
          ),
        )
      ]),
    );
  }
}
