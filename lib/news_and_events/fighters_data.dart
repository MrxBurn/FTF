import 'package:flutter/material.dart';
import 'package:ftf/news_and_events/get_fighters.dart';
import 'package:ftf/styles/styles.dart';
import 'package:intl/intl.dart';

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
            var data = snapshot.data[0]['fighters'];
            return Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: const Color(lighterBlack),
                    boxShadow: [containerShadowRed],
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: paddingLRT,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Fighters')),
                          Icon(
                            Icons.arrow_downward,
                            size: 16,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            itemBuilder: (BuildContext context, idx) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.yellow.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${data[idx]['FirstName']} ${data[idx]['LastName']}',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16)),
                                    Text(
                                      'Nickname: ${data[idx]['Nickname']}',
                                      style:
                                          const TextStyle(color: Colors.yellow),
                                    ),
                                    Text(
                                        'DOB: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(data[idx]['BirthDate']))}'),
                                    Text('Height: ${data[idx]['Height']} cm'),
                                    Text('Height: ${data[idx]['Weight']} lbs'),
                                    Text(
                                      'Wins: ${data[idx]['Wins']}',
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    Text('Losses: ${data[idx]['Losses']}',
                                        style:
                                            const TextStyle(color: Colors.red)),
                                    Text(
                                        'KOs: ${data[idx]['TechnicalKnockouts']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
