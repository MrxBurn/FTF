import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';

class DreamOpponents extends StatelessWidget {
  const DreamOpponents({super.key, required this.opponentsList});

  final List<dynamic> opponentsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingLRT,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [containerShadowRed]),
        child: Container(
          decoration: const BoxDecoration(color: Color(lighterBlack)),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Dream opponents',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              DreamOpponentsList(
                opponentsList: opponentsList,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DreamOpponentsList extends StatelessWidget {
  const DreamOpponentsList({super.key, required this.opponentsList});

  final List opponentsList;
  @override
  Widget build(BuildContext context) {
    return opponentsList.length > 0
        ? SizedBox(
            width: 300,
            height: 100,
            child: ListView.builder(
                itemCount: opponentsList.length,
                itemBuilder: (context, idx) {
                  return Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              opponentsList[idx]['profileImageURL'] != ''
                                  ? NetworkImage(
                                      opponentsList[idx]['profileImageURL'])
                                  : NetworkImage(imgPlaceholder),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opponentsList[idx]['dreamOpponentName'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              opponentsList[idx]['fighterType'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
            child: Text(
              textAlign: TextAlign.center,
              'Currently, there are no users (fighters) signed up to FTF, so you do not have any dream opponents.',
              style: TextStyle(color: Colors.grey),
            ),
          );
  }
}
