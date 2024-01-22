import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/reusableWidgets/dropdown_box.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_text_box.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  String weight = '';

  Future<Map<String, dynamic>> getUser() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    weight = result?['weightClass'];

    return result as Map<String, dynamic>;
  }

  TextEditingController emailController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController weightClassController = TextEditingController();

  TextEditingController nationalityController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  late Future<Map<String, dynamic>> future;

  void onDropDownChanged(value) {
    setState(() {
      weight = value!;
    });
  }

  @override
  void initState() {
    future = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: future,
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
                                      const SizedBox(
                                          width: 80, child: Text('Email')),
                                      RoundedTextInput(
                                        disabled: true,
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
                                      const SizedBox(
                                          width: 80, child: Text('Name')),
                                      RoundedTextInput(
                                        disabled: true,
                                        width: 95,
                                        controller: firstNameController,
                                      ),
                                      RoundedTextInput(
                                        disabled: true,
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
                                      const SizedBox(
                                          width: 80,
                                          child: Text('Weightclass')),
                                      DropdownBox(
                                          disabled: true,
                                          dropDownValue: weight,
                                          dropDownList: weightList,
                                          changeParentValue: (value) =>
                                              onDropDownChanged(value))
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
                                          child: Text('Nationality')),
                                      RoundedTextInput(
                                        disabled: true,
                                        width: 150,
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
