import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftf/chat/message_bubble.dart';
import 'package:ftf/chat/message_class.dart';
import 'package:ftf/styles/styles.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow(
      {super.key, required this.offerId, required this.listScrollController});

  final String? offerId;
  final ScrollController listScrollController;

  Stream getMessages() {
    return FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(offerId)
        .collection('messages')
        .orderBy('sentTime')
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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  listScrollController
                      .jumpTo(listScrollController.position.maxScrollExtent);
                });

                return messages.length < 1
                    ? PlaceholderText()
                    : ListView.builder(
                        controller: listScrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, bottom: 16),
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

class PlaceholderText extends StatelessWidget {
  const PlaceholderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'This private chat feature is exclusively designed for fighters and their teams to discuss the finer details of their potential matchups in a secure environment. Here, you can finalize agreements on market share prices, venue hire, promotional responsibilities, fight logistics, and more, in private. Feel free to engage with your opponent to ensure all aspects of your upcoming fight are addressed and agreed upon.',
        style: TextStyle(fontSize: 10, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
