// ignore_for_file: unused_import

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/circle_navigation_button.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';

class DynamicLinkSummary extends StatefulWidget {
  const DynamicLinkSummary({super.key});

  @override
  State<DynamicLinkSummary> createState() => _DynamicLinkSummaryState();
}

class _DynamicLinkSummaryState extends State<DynamicLinkSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: false),
            const Text(
              'Offer created!',
              style: headerStyle,
            ),
            Padding(
              padding: paddingLRT,
              child: const Text(
                "Congratulations, your offer is on its way! Now, all that's left is to copy and share the generated link below with the fighter you want to receive the offer. When they join the app, you'll be one step closer to making this fight a reality.",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingLRT,
              child: const Text(
                'https://tinyurl.com/bddd42sn',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlackRoundedButton(
                isLoading: false, onPressed: () {}, text: 'Copy'),
            const SizedBox(
              height: 16,
            ),
            CircleNavigationButton(
              color: Colors.yellow,
              onPressed: () => Navigator.pushNamed(context, 'fighterHome'),
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
