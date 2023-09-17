import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/button_black.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class FighterHomePage extends StatefulWidget {
  const FighterHomePage({super.key});

  @override
  State<FighterHomePage> createState() => _FighterHomePageState();
}

class _FighterHomePageState extends State<FighterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        LogoHeader(backRequired: false),
        BlackButton(
          text: 'Create offer',
          onPressed: () => Navigator.pushNamed(context, 'createOfferFighter'),
        )
      ]),
    );
  }
}
