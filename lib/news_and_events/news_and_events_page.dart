import 'package:flutter/material.dart';
import 'package:ftf/news_and_events/boxing_events.dart';
import 'package:ftf/news_and_events/fighters_data.dart';
import 'package:ftf/news_and_events/mma_events.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class NewsAndEventsPage extends StatelessWidget {
  const NewsAndEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            const FightersData(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 150, height: 100, child: MMAEvents()),
                SizedBox(width: 150, height: 100, child: BoxingEvents()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
