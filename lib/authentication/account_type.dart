// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/authentication/register_fighter.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class AccountType extends StatelessWidget {
  String? offerId;

  AccountType({super.key, this.offerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          LogoHeader(
            backRequired: true,
          ),
          BlackButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterFighter(
                      offerId: offerId,
                    ))),
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
