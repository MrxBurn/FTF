import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

class RegisterFanPage extends StatefulWidget {
  const RegisterFanPage({super.key});

  @override
  State<RegisterFanPage> createState() => _RegisterFanPageState();
}

class _RegisterFanPageState extends State<RegisterFanPage> {
  var firstNameController = TextEditingController();

  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  String route = '';

  String authenticationError = '';

  bool isLoading = false;

  void registerFanPage(
      String email, String password, String userName, String firstName) async {
    setState(() {
      isLoading = true;
    });
    users.where('userName', isEqualTo: userName).get().then(
          (doc) async => {
            if (doc.docs.isNotEmpty)
              {showSnackBar(text: 'Username already exists', context: context)}
            else
              {
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    )
                    .then((value) async => {
                          users.doc(value.user?.uid).set({
                            'firstName': firstName,
                            'userName': userName,
                            'route': 'fan',
                            'id': value.user?.uid,
                            'deviceToken':
                                await FirebaseMessaging.instance.getToken(),
                            'eula': false
                          }),
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) => Navigator.pushReplacementNamed(
                                  context, 'fanHome'))
                        })
                    .catchError((error) => {
                          showSnackBarNoContext(
                              text: error.toString(), snackbarKey: snackbarKey)
                        })
              }
          },
        );
    setState(() {
      isLoading = false;
    });

    firstNameController.clear();
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                    pLabelText: 'User name*',
                    controller: userNameController,
                    validatorFunction: (value) => userNameValidator(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'First name*',
                    controller: firstNameController,
                    validatorFunction: (value) => fieldRequired(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'Email*',
                    controller: emailController,
                    validatorFunction: (value) => emailValidation(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'Password*',
                    controller: passwordController,
                    validatorFunction: (value) => fieldRequired(value),
                    passwordField: true,
                  ),
                  InputFieldWidget(
                    pLabelText: 'Confirm password*',
                    controller: confirmPasswordController,
                    validatorFunction: (value) => confirmPasswordValidator(
                        value, passwordController.text),
                    passwordField: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
                child: BlackRoundedButton(
                    isLoading: false,
                    onPressed: () {
                      if (_formKey.currentState!.validate() == true) {
                        registerFanPage(
                            emailController.text,
                            passwordController.text,
                            userNameController.text,
                            firstNameController.text);
                      }
                    },
                    text: 'Register')),
          ],
        ),
      ),
    );
  }
}
