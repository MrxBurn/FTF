// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DreamOpponents extends StatelessWidget {
  DreamOpponents({super.key, required this.opponentsList});

  List opponentsList;

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
  DreamOpponentsList({super.key, required this.opponentsList});

  List opponentsList;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    backgroundImage: NetworkImage(opponentsList[idx]['image']),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opponentsList[idx]['name'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        opponentsList[idx]['category'],
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
