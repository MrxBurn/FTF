// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/regex.dart';

class RegisterFan extends StatefulWidget {
  const RegisterFan({super.key});

  @override
  State<RegisterFan> createState() => _RegisterFanState();
}

class _RegisterFanState extends State<RegisterFan> {
  String firstName = '';

  String userName = '';

  String email = '';

  String password = '';

  var firstNameController = TextEditingController();

  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference fanUsers =
      FirebaseFirestore.instance.collection('fanUsers');

  final _formKey = GlobalKey<FormState>();

  String authenticationError = '';
  void registerFan(
      String email, String password, String userName, String firstName) async {
    try {
      fanUsers
          .where('userName', isEqualTo: userName)
          .get()
          .then((doc) async => {
                if (doc.docs.isNotEmpty)
                  {showSnackBar('Username already exists', context)}
                else
                  {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        )
                        .then((value) => {
                              fanUsers.doc(value.user?.uid).set({
                                'firstName': firstName,
                                'userName': userName
                              })
                            })
                    //TODO: Redirect to fan home page
                  }
              });
    } on FirebaseAuthException catch (e) {
      authenticationError = e.message.toString();
      if (context.mounted) {
        showSnackBar(authenticationError, context);
      }
    }

    firstNameController.clear();
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(authenticationError);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoHeader(
              backRequired: true,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                'Register',
                style: headerStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  const Text(
                    "Already have an account?",
                    style: bodyStyle,
                  ),
                  TextButton(
                      style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () =>
                          Navigator.pushNamed(context, 'loginPage'),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ))
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'User name*',
                      ),
                      onChanged: (value) => userName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'First name*',
                      ),
                      onChanged: (value) => firstName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email*',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        } else if (!emailRgx.hasMatch(value)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'Password*',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value) => password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => {
                          if (_formKey.currentState!.validate() == true)
                            {
                              registerFan(email, password, userName, firstName),
                            }
                        },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
