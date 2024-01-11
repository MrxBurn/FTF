import 'package:flutter/material.dart';
import 'package:ftf/news_and_events/instagram_embedded.dart';
import 'package:ftf/news_and_events/mma_events.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';

class NewsAndEventsPage extends StatelessWidget {
  const NewsAndEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LogoHeader(backRequired: true),
          const InstagramEmbedded(),
          const MMAEvents()
        ],
      ),
    );
  }
}
