import 'package:flutter/material.dart';

class InstagramEmbedded extends StatefulWidget {
  const InstagramEmbedded({super.key});

  @override
  State<InstagramEmbedded> createState() => _InstagramEmbeddedState();
}

class _InstagramEmbeddedState extends State<InstagramEmbedded> {
  Future<String> getTwitterTimeline() async {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTwitterTimeline(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Column(
              children: [],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
