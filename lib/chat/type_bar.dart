import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/chat/message_class.dart';

class TypeBar extends StatefulWidget {
  const TypeBar({super.key, this.offerId, required this.listScrollController});

  final String? offerId;
  final ScrollController listScrollController;

  @override
  State<TypeBar> createState() => _TypeBarState();
}

class _TypeBarState extends State<TypeBar> {
  TextEditingController messageController = TextEditingController();

  final Message _message = Message();

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  //TODO: Move arrow when text is bigger

  void onMessageSent() async {
    messageController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    _message.senderId = currentUser;
    _message.senderName = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) =>
            '${value.data()?['firstName']} ${value.data()?['lastName']}');

    _message.sentTime = DateTime.now();

    await FirebaseFirestore.instance
        .collection('fightOffers')
        .doc(widget.offerId)
        .collection('messages')
        .add(_message.toMap());

    widget.listScrollController
        .jumpTo(widget.listScrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Stack(
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 10.0, top: -15.0, bottom: 15.0, right: 50),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.2, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              hintText: 'Press to type',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
            ),
            onChanged: (value) => {
              setState(() {
                _message.message = value;
              })
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                onPressed: () => onMessageSent(),
                icon: const Icon(
                  Icons.arrow_circle_right,
                  color: Colors.yellow,
                  size: 32,
                )),
          )
        ],
      ),
    );
  }
}
