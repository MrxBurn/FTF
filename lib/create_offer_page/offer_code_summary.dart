import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/circle_navigation_button.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/snack_bar.dart';

class OfferCodeSummary extends StatelessWidget {
  const OfferCodeSummary({super.key, this.offerId});

  final String? offerId;
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
                "Your offer is on its way! Send the code below to your potential opponent via direct message. They can use this code to accept, decline, or negotiate the offer upon downloading FTF. Also, call them out on social media, letting fight fans know you've made an offer and challenging your opponent to respond 🥊",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingLRT,
              child: Text(
                routes['offerId'] ?? '',
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
                      ClipboardData(text: routes['offerId'] ?? ''));

                  if (context.mounted) {
                    showSnackBar(
                        text: 'Offer code copied',
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
