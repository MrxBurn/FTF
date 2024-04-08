import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

class LoginPage extends StatefulWidget {
  final String? offerId;
  const LoginPage({super.key, this.offerId});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLogingIn = false;

  var doc = FirebaseFirestore.instance.collection('users');

  Future<void> loginFighter(String email, String password) async {
    try {
      isLogingIn = true;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                doc.doc(value.user?.uid).get().then(
                      (value) async => {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(value.id)
                            .set({
                          'deviceToken':
                              await FirebaseMessaging.instance.getToken()
                        }, SetOptions(merge: true)),
                        if (value.get('route') == 'fighter')
                          {
                            navigatorKey.currentState
                                ?.pushReplacementNamed('fighterHome')
                          },
                        if (value.get('route') == 'fan')
                          {
                            navigatorKey.currentState
                                ?.pushReplacementNamed('fanHome')
                          },
                      },
                    ),
              });
      isLogingIn = false;
    } on FirebaseAuthException catch (e) {
      isLogingIn = false;
      showSnackBarNoContext(
          text: e.message.toString(), snackbarKey: snackbarKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoHeader(
              backRequired: false,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                'Login',
                style: headerStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  const Text(
                    "Don't have an account?",
                    style: bodyStyle,
                  ),
                  TextButton(
                      style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AccountType(
                                    offerId: widget.offerId,
                                  ))),
                      child: const Text(
                        'Register',
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
                      pLabelText: 'Email',
                      controller: emailController,
                      validatorFunction: (value) => emailValidation(value),
                    ),
                    InputFieldWidget(
                      pLabelText: 'Password',
                      controller: passwordController,
                      validatorFunction: (value) => fieldRequired(value),
                      passwordField: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, 'forgotPassword'),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Colors.yellow.withOpacity(0.8)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
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
                                      loginFighter(emailController.text,
                                          passwordController.text)
                                    }
                                },
                            child: isLogingIn == true
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  )),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
