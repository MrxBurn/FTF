import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';

  String password = '';

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  //TODO: Implement redirection login for fighter or fan
  void loginFighter(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => print('Logged in user ${value.user?.uid}'));
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
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
                  labelText: 'Email',
                ),
                onChanged: (value) => (email = value),
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
                  labelText: 'Password',
                ),
                onChanged: ((value) => password = value),
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
                    onPressed: () => loginFighter(email, password),
                    child: const Text(
                      'Login',
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
