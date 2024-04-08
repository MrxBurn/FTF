import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future forgotPassword({
    required String email,
  }) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      showSnackBarNoContext(
          text: err.message.toString(), snackbarKey: snackbarKey);

      setState(() {
        isLoading = false;
      });
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        LogoHeader(backRequired: true),
        InputFieldWidget(
          pLabelText: 'Email',
          controller: emailController,
          validatorFunction: (value) => emailValidation(value),
        ),
        const SizedBox(
          height: 12,
        ),
        BlackRoundedButton(
            isLoading: isLoading,
            onPressed: () => forgotPassword(email: emailController.text).then(
                (value) => showSnackBar(
                    text: 'Password reset email sent', context: context)),
            text: 'Submit')
      ]),
    );
  }
}
