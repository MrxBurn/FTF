import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class AccountType extends StatelessWidget {
  const AccountType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const LogoHeader(),
          BlackButton(
            onPressed: () => (),
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
