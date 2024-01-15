import 'package:flutter/material.dart';
import 'package:ftf/news_and_events/boxing_events.dart';
import 'package:ftf/news_and_events/fighters_data.dart';
import 'package:ftf/news_and_events/mma_events.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

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
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 250,
              decoration:
                  BoxDecoration(color: const Color(lighterBlack), boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                )
              ]),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 195, child: MMAEvents()),
                  SizedBox(width: 195, child: BoxingEvents()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
