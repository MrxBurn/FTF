import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/reusableWidgets/rounded_text_box.dart';
import 'package:ftf/styles/styles.dart';

class MyAccountFan extends StatefulWidget {
  const MyAccountFan({super.key});

  @override
  State<MyAccountFan> createState() => _MyAccountFanState();
}

class _MyAccountFanState extends State<MyAccountFan> {
  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  TextEditingController firstNameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  Future<Map<String, dynamic>?> getUser() async {
    Map<String, dynamic>? result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            FutureBuilder(
                future: getUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    firstNameController.text = snapshot.data['firstName'];
                    userNameController.text = snapshot.data['userName'];

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Container(
                            constraints: const BoxConstraints(minHeight: 150),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: const Color(black),
                                boxShadow: [containerShadowRed]),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const SizedBox(
                                            width: 80,
                                            child: Text('User name')),
                                        RoundedTextInput(
                                          disabled: true,
                                          width: 95,
                                          controller: userNameController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 8,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const SizedBox(
                                            width: 80,
                                            child: Text('First name')),
                                        RoundedTextInput(
                                          disabled: true,
                                          width: 95,
                                          controller: firstNameController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ])))
                      ]),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            BlackRoundedButton(
              isLoading: false,
              onPressed: () async => {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser)
                    .update({'deviceToken': FieldValue.delete()}),
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => LoginPage()),
                        (route) => false))
              },
              text: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
