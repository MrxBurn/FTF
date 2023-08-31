import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:image_picker/image_picker.dart';

class FighterImageUpload extends StatefulWidget {
  const FighterImageUpload({super.key});

  @override
  State<FighterImageUpload> createState() => _FighterImageUploadState();
}

class _FighterImageUploadState extends State<FighterImageUpload> {
  String firstName = '';

  File? image;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference fighterUsers =
      FirebaseFirestore.instance.collection('fighterUsers');

  uploadImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var uid = firebaseAuth.currentUser?.uid;
    fighterUsers.doc(uid).get().then((DocumentSnapshot doc) => {
          setState(() {
            firstName = doc['firstName'];
          })
        });

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LogoHeader(backRequired: false),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: firstName.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $firstName!',
                      style: headerStyle,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Upload your profile picture?',
                          style: bodyStyle,
                        ),
                        TextButton(
                            style: const ButtonStyle(
                                splashFactory: NoSplash.splashFactory),
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: ((context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: SizedBox(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                  onPressed: () => uploadImage(
                                                      ImageSource.camera),
                                                  icon: const Icon(
                                                      Icons.camera_alt)),
                                              IconButton(
                                                  onPressed: () => uploadImage(
                                                      ImageSource.gallery),
                                                  icon: const Icon(Icons.image))
                                            ],
                                          ),
                                          const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Camera'),
                                              Text('Gallery')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                            child: const Text(
                              'Upload',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            )),
                      ],
                    ),
                    image != null
                        ? Center(
                            child: Image.file(
                              image!,
                              height: 200,
                              width: 200,
                            ),
                          )
                        : Container()
                  ],
                ),
        )
      ]),
    );
  }
}
