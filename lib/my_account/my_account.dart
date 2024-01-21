import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_text_box.dart';
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

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController weightClassController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                emailController.text = snapshot.data['email'];
                firstNameController.text = snapshot.data['firstName'];
                lastNameController.text = snapshot.data['lastName'];
                weightClassController.text = snapshot.data['weightClass'];
                nationalityController.text = snapshot.data['nationality'];
                bioController.text = snapshot.data['description'];

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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            height: 350,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: const Color(black),
                                boxShadow: [containerShadowRed]),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Your details',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [containerShadowYellow]),
                                      height: 25,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            )),
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.yellow),
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Text('Email'),
                                      RoundedTextInput(
                                        controller: emailController,
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
                                      const Text('Name'),
                                      RoundedTextInput(
                                        width: 95,
                                        controller: firstNameController,
                                      ),
                                      RoundedTextInput(
                                        width: 95,
                                        controller: lastNameController,
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
                                      const Text('Weightclass'),
                                      RoundedTextInput(
                                        width: 95,
                                        controller: weightClassController,
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
                                      const Text('Nationality'),
                                      RoundedTextInput(
                                        width: 95,
                                        controller: nationalityController,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  keyboardType: TextInputType.multiline,
                                  readOnly: true,
                                  maxLines: null,
                                  controller: bioController,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 25.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
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
