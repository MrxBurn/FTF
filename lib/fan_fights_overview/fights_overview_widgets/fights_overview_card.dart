import 'package:flutter/material.dart';
import 'package:ftf/fan_fights_overview/fights_overview_widgets/number_of_likes_card.dart';
import 'package:ftf/styles/styles.dart';

class FightsOverviewCard extends StatelessWidget {
  const FightsOverviewCard(
      {super.key,
      required this.creator,
      required this.opponent,
      required this.creatorValue,
      required this.opponentValue,
      required this.weightClass,
      required this.fighterStatus,
      required this.fightDate,
      required this.likes,
      required this.dislikes,
      required this.onTap});

  final String creator;
  final String opponent;

  final String creatorValue;
  final String opponentValue;

  final String weightClass;
  final String fighterStatus;

  final String fightDate;
  final int likes;
  final int dislikes;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 250),
      height: 190,
      decoration: BoxDecoration(
        color: const Color(lighterBlack),
        boxShadow: [containerShadowWhite],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 6),
                child: Column(children: [
                  Center(
                    child: NumberOfLikes(
                      likes: likes,
                      dislikes: dislikes,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        creator,
                        style: const TextStyle(color: Colors.yellow),
                      ),
                      Text(opponent, style: const TextStyle(color: Colors.red))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        creatorValue,
                        style: const TextStyle(color: Colors.yellow),
                      ),
                      const Text('VS'),
                      Text(
                        opponentValue,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(weightClass),
                  Text(fighterStatus),
                  Text(
                    fightDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    'Press for more details',
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                ]))),
      ),
    );
  }
}
