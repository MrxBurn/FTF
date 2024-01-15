import 'package:flutter/material.dart';
import 'package:ftf/news_and_events/get_fighters.dart';
import 'package:ftf/styles/styles.dart';

class FightersData extends StatefulWidget {
  const FightersData({super.key});

  @override
  State<FightersData> createState() => _FightersDataState();
}

class _FightersDataState extends State<FightersData> {
  Future<String> getTwitterTimeline() async {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFighterStats(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: const Color(lighterBlack),
                    boxShadow: [containerShadowRed],
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: paddingLRT,
                  child: const Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft, child: Text('Fighters'))
                    ],
                  ),
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
