import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/news_and_events/get_events.dart';
import 'package:intl/intl.dart';

class MMAEvents extends StatefulWidget {
  const MMAEvents({super.key});

  @override
  State<MMAEvents> createState() => _MMAEventsState();
}

class _MMAEventsState extends State<MMAEvents> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEvents('mma_mixed_martial_arts'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/mma_glove.svg'),
                      const SizedBox(
                        width: 6,
                      ),
                      const Text(
                        'MMA',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, idx) {
                          return SizedBox(
                            width: 115,
                            height: 95,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          snapshot.data[idx]['home_team'],
                                          style: const TextStyle(
                                              color: Colors.yellow),
                                        ),
                                        const Text('vs'),
                                        Text(
                                          snapshot.data[idx]['away_team'],
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      ]),
                                  const Spacer(),
                                  Text(DateFormat("hh:mm:ss - dd-MM-yyyy")
                                      .format(DateTime.parse(
                                          snapshot.data[idx]['commence_time'])))
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
