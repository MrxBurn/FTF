// ignore_for_file: unused_import

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/circle_navigation_button.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/snack_bar.dart';

class DynamicLinkSummary extends StatefulWidget {
  const DynamicLinkSummary({super.key});

  @override
  State<DynamicLinkSummary> createState() => _DynamicLinkSummaryState();
}

class _DynamicLinkSummaryState extends State<DynamicLinkSummary> {
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

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
                "Your offer is on its way! Copy the link below and send it privately to your potential opponent. They can accept, decline, or negotiate the offer upon downloading FTF.Then, ignite the excitement by publicly calling out your opponent, letting fight fans know there's an offer waiting for them in FTF! 🔥",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingLRT,
              child: Text(
                routes['link'] ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlackRoundedButton(
                isLoading: false,
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: routes['link'] ?? ''));

                  if (context.mounted) {
                    showSnackBar(
                        text: 'Link copied',
                        context: context,
                        color: Colors.grey);
                  }
                },
                text: 'Copy'),
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
