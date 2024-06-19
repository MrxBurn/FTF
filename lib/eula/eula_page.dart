import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/eula/eula_text.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';

class EULAPage extends StatefulWidget {
  const EULAPage({super.key, this.user});

  final Map<String, dynamic>? user;

  @override
  State<EULAPage> createState() => _EULAPageState();
}

class _EULAPageState extends State<EULAPage> {
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<void> onAccept() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({'eula': true});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 350,
          child: SingleChildScrollView(child: Text(eulaText)),
        ),
      ),
      SizedBox(
        height: 12,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlackRoundedButton(
              isLoading: false,
              onPressed: () => {Navigator.pushNamed(context, 'declineEula')},
              text: 'Decline',
              textColour: Colors.red,
            ),
            BlackRoundedButton(
              isLoading: false,
              onPressed: () => onAccept(),
              text: 'Accept',
              textColour: Colors.green,
            )
          ],
        ),
      ),
    ]);
  }
}
