import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key, required this.offerId});

  final String? offerId;

  Stream getMessages() {
    return FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(offerId)
        .collection('messages')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        decoration: const BoxDecoration(
            color: Color(lighterBlack),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: StreamBuilder(
            stream: getMessages(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, idx) {
                    return Container();
                  });
            }),
      ),
    );
  }
}
