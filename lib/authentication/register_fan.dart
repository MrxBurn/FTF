// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:ftf/styles/styles.dart';

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

  String confirmPassword = '';

  var firstNameController = TextEditingController();

  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

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
    confirmPasswordController.clear();
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
                  InputFieldWidget(
                    fieldValue: userName,
                    pLabelText: 'User name*',
                    controller: userNameController,
                    validatorFunction: (value) => userNameValidator(value),
                  ),
                  InputFieldWidget(
                    fieldValue: firstName,
                    pLabelText: 'First name*',
                    controller: firstNameController,
                    validatorFunction: (value) => fieldRequired(value),
                  ),
                  InputFieldWidget(
                    fieldValue: email,
                    pLabelText: 'Email*',
                    controller: emailController,
                    validatorFunction: (value) => emailValidation(value),
                  ),
                  InputFieldWidget(
                    fieldValue: password,
                    pLabelText: 'Password*',
                    controller: passwordController,
                    validatorFunction: (value) => fieldRequired(value),
                    passwordField: true,
                  ),
                  InputFieldWidget(
                    fieldValue: confirmPassword,
                    pLabelText: 'Confirm password*',
                    controller: confirmPasswordController,
                    validatorFunction: (value) =>
                        confirmPasswordValidator(value, password),
                    passwordField: true,
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
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: Colors.red,
                    ),
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
