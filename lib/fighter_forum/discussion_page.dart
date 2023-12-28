import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/fighter_forum/comments_section.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class DiscussionPage extends StatefulWidget {
  const DiscussionPage(
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
  final List<Map<String, String>> links;
  final String imagePath;
  final String firebaseCollection;

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
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
      'comment': comment,
      'firstName': userData['firstName'],
      'lastName': userData['lastName'],
      'createdAt': DateTime.now(),
    });

    setState(() {
      isLoading = false;
      controller.clear();
      isTextFieldTapped = false;
    });
  }

  late Future<List<Map<String, dynamic>>> getComments1;

  Future<List<Map<String, dynamic>>> getComments() async {
    var comments = await FirebaseFirestore.instance
        .collection('forumDiscussions')
        .doc(widget.firebaseCollection)
        .collection('comments')
        .get()
        .then((value) => value.docs.map((e) => e.data()));

    return comments.toList();
  }

  @override
  void initState() {
    getComments1 = getComments();
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
          style: headerStyle,
        ),
        Padding(
          padding: paddingLRT,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.subTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.body,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'For more insights (links):',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                  children: widget.links.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => {launchUrl(Uri.parse(e['url']!))},
                      child: Text(
                        e['name']!,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
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
              CommentsSection(getComments: getComments)
            ],
          ),
        ),
      ])),
    );
  }
}
