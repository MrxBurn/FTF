import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/popup_menu_button.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/reusableWidgets/rounded_text_box.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/delete_user.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccountFanPage extends StatefulWidget {
  const MyAccountFanPage({super.key});

  @override
  State<MyAccountFanPage> createState() => _MyAccountFanPageState();
}

class _MyAccountFanPageState extends State<MyAccountFanPage> {
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
            const SizedBox(
              height: 16,
            ),
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
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              color: const Color(black),
                              boxShadow: [containerShadowRed]),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CustomPopupMenuButton(
                                    children: [
                                      PopupMenuItem(
                                        child: Text(
                                          'Delete Account',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Account deletion',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18),
                                            ),
                                            content: Text(
                                                'Are you sure you want to delete your account?'),
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
                                                  onPressed: () =>
                                                      deleteFan(currentUser),
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: Text(
                                          'Contact us',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Contact us',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                              ),
                                            ),
                                            content: Text(
                                                'If any user has posted something of a serious nature, please email us at fightertofighter.official@gmail.com. We will investigate and take appropriate action within 24 hours.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: const SizedBox(
                                          width: 80, child: Text('User name')),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: RoundedTextInput(
                                        disabled: true,
                                        controller: userNameController,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: const SizedBox(
                                          width: 80, child: Text('First name')),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: RoundedTextInput(
                                        disabled: true,
                                        controller: firstNameController,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () => {
                                      launchUrl(Uri.parse(
                                          'https://fightertofighter.wixsite.com/ftf-site/general-8'))
                                    },
                                    child: Text(
                                      'Privacy policy',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
                        MaterialPageRoute(builder: (ctx) => const LoginPage()),
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
