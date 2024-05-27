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
        future: getEvents('mma_mixed_martial_arts', 'mmaEvents'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var filteredEvents = snapshot.data[0]['events']
                .where((ev) =>
                    DateTime.parse(ev['commence_time']).isAfter(DateTime.now()))
                .toList();

            return SizedBox(
              width: 225,
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
                    height: 500,
                    width: 190,
                    child: ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (BuildContext context, idx) {
                          return SizedBox(
                            height: 85,
                            child: Card(
                              child: Column(
                                children: [
                                  Row(children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        '''${filteredEvents[idx]['home_team'].toString().split(' ').first}
${filteredEvents[idx]['home_team'].toString().split(' ').last}''',
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            color: Colors.yellow, fontSize: 12),
                                      ),
                                    ),
                                    const Text('vs'),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        '''${filteredEvents[idx]['away_team'].toString().split(' ').first}
${filteredEvents[idx]['away_team'].toString().split(' ').last}''',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    )
                                  ]),
                                  const Spacer(),
                                  Text(
                                    DateFormat("hh:mm:ss - dd-MM-yyyy").format(
                                        DateTime.parse(filteredEvents[idx]
                                            ['commence_time'])),
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
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
