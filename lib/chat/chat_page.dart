import 'package:flutter/material.dart';
import 'package:ftf/chat/chat_window.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, this.offerId});

  final String? offerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          LogoHeader(backRequired: true),
          ChatWindow(offerId: offerId)
        ],
      )),
    );
  }
}
