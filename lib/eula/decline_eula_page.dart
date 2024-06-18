import 'package:flutter/material.dart';
import 'package:ftf/home_pages/fan_home_page.dart';
import 'package:ftf/home_pages/fighter_home_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';

class DeclineEULAPage extends StatelessWidget {
  const DeclineEULAPage({super.key, this.user});

  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(
            backRequired: false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'You have declined the EULA. You cannot proceed with navigation within the app. Please go back and accept EULA.'),
          ),
          SizedBox(
            height: 12,
          ),
          BlackRoundedButton(
              isLoading: false,
              onPressed: () => {
                    if (user?['route'] == 'fighter')
                      {
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (context) => FighterHomePage(),
                          ),
                        ),
                      }
                    else
                      {
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (context) => FanHomePage(),
                          ),
                        ),
                      }
                  },
              text: 'Go back')
        ],
      ),
    );
  }
}
