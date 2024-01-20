import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>> getUser() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    return result as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    CustomImageHeader(
                        networkImage: true,
                        backRequired: true,
                        imagePath: snapshot.data['profileImageURL']),
                    const SizedBox(height: 16),
                    const Text(
                      'My account',
                      style: headerStyle,
                    )
                  ],
                ));
              } else {
                return Column(
                  children: [
                    LogoHeader(backRequired: true),
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              }
            }));
  }
}
