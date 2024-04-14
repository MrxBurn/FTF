import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fan_forum/comments_section_fan.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/styles/styles.dart';

class DiscussionPageFan extends StatefulWidget {
  const DiscussionPageFan(
      {super.key,
      required this.title,
      required this.body,
      required this.subTitle,
      required this.links,
      required this.imagePath,
      required this.firebaseCollection});

  final String title;
  final String body;
  final String subTitle;
  final List<dynamic> links;
  final String imagePath;
  final String firebaseCollection;

  @override
  State<DiscussionPageFan> createState() => _DiscussionPageFanState();
}

class _DiscussionPageFanState extends State<DiscussionPageFan> {
  final TextEditingController controller = TextEditingController();
  bool isTextFieldTapped = false;

  User? currentUser = FirebaseAuth.instance.currentUser;

  bool isLoading = false;
  Future<void> onCommentSubmit(String comment) async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    await FirebaseFirestore.instance
        .collection('forumDiscussions')
        .doc(widget.firebaseCollection)
        .collection('comments')
        .doc()
        .set({
      'userName': userData['userName'],
      'comment': comment,
      'createdAt': DateTime.now(),
    });

    setState(() {
      isLoading = false;
      controller.clear();
      isTextFieldTapped = false;

      //Re-fetch comments on submit
      future = getComments();
    });
  }

  late Future<List<Map<String, dynamic>>> future;

  Future<List<Map<String, dynamic>>> getComments() async {
    var comments = await FirebaseFirestore.instance
        .collection('forumDiscussions')
        .doc(widget.firebaseCollection)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    return comments.toList();
  }

  @override
  void initState() {
    future = getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        CustomImageHeader(backRequired: true, imagePath: widget.imagePath),
        const SizedBox(
          height: 16,
        ),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        Padding(
          padding: paddingLRT,
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Comments',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: 'Add a comment...',
                  ),
                  onChanged: (value) =>
                      {setState(() => controller.text = value)},
                  onTap: () => setState(() {
                        isTextFieldTapped = true;
                      })),
              const SizedBox(
                height: 8,
              ),
              isTextFieldTapped == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => {
                                  setState(() {
                                    isTextFieldTapped = false;
                                    controller.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  })
                                },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            )),
                        ElevatedButton(
                            onPressed: controller.text.isEmpty
                                ? null
                                : () => onCommentSubmit(controller.text),
                            child: isLoading == true
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: const CircularProgressIndicator())
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: controller.text.isEmpty
                                            ? Colors.grey
                                            : Colors.white),
                                  ))
                      ],
                    )
                  : const SizedBox(),
              CommentsSectionFan(
                getComments: future,
                // isFighterForum: false,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ])),
    );
  }
}
