import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/chat/message_buble.dart';
import 'package:ftf/chat/message_class.dart';
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
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        child: StreamBuilder(
            stream: getMessages(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                List<Message> messages = (snapshot.data?.docs ?? [])
                    .map<Message>((e) => Message(
                          senderName: e['senderName'],
                          message: e['message'],
                          senderId: e['senderId'],
                        ))
                    .toList();

                return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                    itemCount: messages.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: MessageBuble(messageObject: messages[idx]),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
