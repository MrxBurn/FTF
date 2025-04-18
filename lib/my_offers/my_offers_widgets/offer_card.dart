import 'package:flutter/material.dart';
import 'package:ftf/fan_fights_overview/fights_overview_widgets/number_of_likes_card.dart';
import 'package:ftf/reusableWidgets/text_ellipsis.dart';
import 'package:ftf/styles/styles.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.creator,
    required this.opponent,
    required this.creatorValue,
    required this.opponentValue,
    required this.weightClass,
    required this.fighterStatus,
    required this.fightDate,
    required this.likes,
    required this.dislikes,
    this.height,
    this.iconSize,
    this.valueSize,
  });

  final String creator;
  final String opponent;

  final String creatorValue;
  final String opponentValue;

  final String weightClass;
  final String fighterStatus;

  final String fightDate;

  final int likes;

  final int dislikes;

  final double? height;

  final double? iconSize;

  final double? valueSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 250),
      height: 170,
      decoration: BoxDecoration(
        color: const Color(lighterBlack),
        boxShadow: [containerShadowWhite],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 6),
              child: Column(children: [
                NumberOfLikes(
                  likes: likes,
                  dislikes: dislikes,
                  height: height ?? 40,
                  iconSize: iconSize ?? 18,
                  valueSize: valueSize ?? 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextEllipsis(
                      maxWidth: 100,
                      text: creator,
                      style: const TextStyle(color: Colors.yellow),
                    ),
                    TextEllipsis(
                        maxWidth: 100,
                        text: opponent,
                        style: const TextStyle(color: Colors.red))
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
                const Spacer(),
                Text(weightClass),
                Text(fighterStatus),
                Text(
                  fightDate,
                  style: const TextStyle(color: Colors.grey),
                ),
              ]))),
    );
  }
}
