import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  final storageRef = FirebaseStorage.instance.ref();

  String imageName = '';

  uploadImage(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      imageName = image.name;

      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  saveToFirebase(File? image) async {
    if (image != null) {
      await storageRef
          .child('fighterProfiles/$currentUser/$imageName')
          .putFile(image);
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
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                              children: [
                                                IconButton(
                                                    onPressed: () =>
                                                        uploadImage(
                                                            ImageSource.camera),
                                                    icon: const Icon(
                                                        Icons.camera_alt)),
                                                const Text('Camera'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () =>
                                                        uploadImage(ImageSource
                                                            .gallery),
                                                    icon: const Icon(
                                                        Icons.image)),
                                                const Text('Gallery'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                              child: const Text(
                                'Upload',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              )),
                        ],
                      ),
                      image != null
                          ? Center(
                              child: CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 100,
                            ))
                          : const Center(
                              child: CircleAvatar(
                                radius: 101,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.black,
                                  child: Center(
                                    child: Text(
                                      'image',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () => {
                                  // Navigator.pushNamed(context, 'homePageFigher'),
                                },
                            child: Text(
                              'Skip this step',
                              style: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () => saveToFirebase(image),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.red,
                          ),
                          child: const Text(
                            'Upload',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
          )
        ]),
      ),
    );
  }
}
