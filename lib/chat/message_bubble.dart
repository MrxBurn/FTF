import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

import 'message_class.dart';

class MessageBuble extends StatelessWidget {
  MessageBuble({super.key, required this.messageObject});

  final Message messageObject;

  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    bool isMessageSentByCurrentUser = currentUser == messageObject.senderId;
    return Align(
      alignment: isMessageSentByCurrentUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: isMessageSentByCurrentUser
            ? WrapCrossAlignment.end
            : WrapCrossAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 12),
            child: Text(
              messageObject.senderName ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10,
                color: isMessageSentByCurrentUser ? Colors.yellow : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 32),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                color: const Color(black),
                boxShadow: isMessageSentByCurrentUser
                    ? [containerShadowYellow]
                    : [containerShadowRed]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, top: 8, bottom: 8),
              child: Text(
                messageObject.message ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
