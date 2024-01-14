import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/news_and_events/get_events.dart';
import 'package:intl/intl.dart';

class BoxingEvents extends StatefulWidget {
  const BoxingEvents({super.key});

  @override
  State<BoxingEvents> createState() => BoxingEventsState();
}

class BoxingEventsState extends State<BoxingEvents> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEvents('boxing_boxing', 'boxingEvents'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: 225,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/boxing_glove.svg'),
                      const SizedBox(
                        width: 6,
                      ),
                      const Text(
                        'Boxing',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 215,
                    width: 190,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data[0]['events'].length,
                        itemBuilder: (BuildContext context, idx) {
                          return SizedBox(
                            height: 85,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(children: [
                                    SizedBox(
                                      width: 80,
                                      child: Flexible(
                                        child: Text(
                                          '''${snapshot.data[0]['events'][idx]['home_team'].toString().split(' ').first}
${snapshot.data[0]['events'][idx]['home_team'].toString().split(' ').last}''',
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    const Text('vs'),
                                    SizedBox(
                                      width: 80,
                                      child: Flexible(
                                        child: Text(
                                          '''${snapshot.data[0]['events'][idx]['away_team'].toString().split(' ').first}
${snapshot.data[0]['events'][idx]['away_team'].toString().split(' ').last}''',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    )
                                  ]),
                                  const Spacer(),
                                  Text(
                                    DateFormat("hh:mm:ss - dd-MM-yyyy").format(
                                        DateTime.parse(snapshot.data[0]
                                            ['events'][idx]['commence_time'])),
                                    style: const TextStyle(fontSize: 10),
                                  )
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
