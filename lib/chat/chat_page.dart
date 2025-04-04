import 'package:flutter/material.dart';
import 'package:ftf/chat/chat_window.dart';
import 'package:ftf/chat/message_bar.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, this.offerId});

  final String? offerId;

  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          LogoHeader(backRequired: true),
          const Text(
            'Chat',
            style: headerStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          ChatWindow(
            offerId: offerId,
            listScrollController: listScrollController,
          ),
          TypeBar(
            offerId: offerId,
            listScrollController: listScrollController,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      )),
    );
  }
}
