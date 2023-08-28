import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class AccountType extends StatelessWidget {
  const AccountType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          LogoHeader(
            backRequired: true,
          ),
          BlackButton(
            onPressed: () => Navigator.pushNamed(context, 'registerFighter'),
            text: 'I am a fighter',
          ),
          const SizedBox(
            height: 32,
          ),
          BlackButton(
            onPressed: () => Navigator.pushNamed(context, 'registerFan'),
            text: 'I am a fan',
          ),
        ]),
      ),
    );
  }
}
