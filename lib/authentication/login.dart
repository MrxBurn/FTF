import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLogingIn = false;

  var doc = FirebaseFirestore.instance.collection('users');

  //TODO: Implement redirection login for fighter or fan
  void loginFighter(String email, String password) async {
    try {
      isLogingIn = true;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                doc
                    .doc(value.user?.uid)
                    .get()
                    .then((DocumentSnapshot value) => {
                          if (value.get('route') == 'fighter')
                            {
                              Navigator.pushReplacementNamed(
                                  context, 'fighterHome')
                            },
                          if (value.get('route') == 'fan')
                            {Navigator.pushReplacementNamed(context, 'fanHome')}
                        })
              });
      isLogingIn = false;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        isLogingIn = false;
        showSnackBar(e.toString(), context);
      }
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
                          Navigator.pushNamed(context, 'accountType'),
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
                                      print(isLogingIn),
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
