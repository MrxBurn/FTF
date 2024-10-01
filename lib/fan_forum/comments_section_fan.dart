import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/popup_menu_button.dart';
import 'package:ftf/utils/radio_button_options.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

class CommentsSectionFan extends StatefulWidget {
  const CommentsSectionFan(
      {super.key, required this.getComments, required this.firebaseCollection});

  final Future<List<Map<String, dynamic>>> getComments;
  final String firebaseCollection;

  @override
  State<CommentsSectionFan> createState() => _CommentsSectionFanState();
}

class _CommentsSectionFanState extends State<CommentsSectionFan> {
  String? _groupValue = '';

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<void> reportComment(
      String comment, String commentId, String commentOwner) async {
    await FirebaseFirestore.instance.collection('reportComments').add({
      "reporter": currentUser,
      "reason": _groupValue,
      "comment": comment,
      "commentId": commentId,
      "forumTopic": widget.firebaseCollection,
      "commentOwner": commentOwner
    });

    showSnackBarNoContext(
        text: 'Comment reported',
        snackbarKey: snackbarKey,
        color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getComments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data.length > 0
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, idx) {
                    var data = snapshot.data[idx];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${data['userName']} ${data['createdAt'].toDate().day}/${data['createdAt'].toDate().month}/${data['createdAt'].toDate().year} - ${data['createdAt'].toDate().hour}:${data['createdAt'].toDate().minute}'),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(data['comment'])
                                  ]),
                            ),
                            Spacer(),
                            data['userId'] != currentUser
                                ? CustomPopupMenuButton(
                                    children: [
                                      PopupMenuItem(
                                        child: Text(
                                          'Report comment',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (context) => StatefulBuilder(
                                              builder: (context, dialogState) {
                                            return AlertDialog(
                                              title: Text(
                                                'Report reason',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              ),
                                              content: SizedBox(
                                                height: 450,
                                                child: Column(
                                                  children: [
                                                    Column(
                                                      children:
                                                          List<Widget>.generate(
                                                        reportCommentOptions
                                                            .length,
                                                        (idx) => RadioListTile(
                                                          title: Text(
                                                              reportCommentOptions[
                                                                          idx][
                                                                      'text'] ??
                                                                  ''),
                                                          value:
                                                              reportCommentOptions[
                                                                  idx]['value'],
                                                          groupValue:
                                                              _groupValue,
                                                          onChanged: (value) {
                                                            dialogState(() {
                                                              _groupValue =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      "Note: Once reported, you can’t see this comment anymore",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                TextButton(
                                                    onPressed: _groupValue != ''
                                                        ? () => reportComment(
                                                                data['comment'],
                                                                data[
                                                                    'commentId'],
                                                                data['userId'])
                                                            .then((v) => Navigator
                                                                .pushNamed(
                                                                    context,
                                                                    'fanHome'))
                                                        : null,
                                                    child: Text(
                                                      'Report',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _groupValue !=
                                                                  ''
                                                              ? Colors.red
                                                              : Colors.grey),
                                                    ))
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  })
              : Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'There are currently no comments on this page',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
