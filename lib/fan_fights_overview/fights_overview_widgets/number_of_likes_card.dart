import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:intl/intl.dart';

class NumberOfLikes extends StatelessWidget {
  const NumberOfLikes(
      {super.key,
      required this.likes,
      required this.dislikes,
      this.height = 40,
      this.iconSize = 18,
      this.valueSize = 16});

  final int likes;
  final int dislikes;

  final double height;

  final double iconSize;

  final double valueSize;

  String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        height: height,
        decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [containerShadowRed],
            borderRadius: BorderRadius.circular(5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.thumb_up,
            size: iconSize,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            formatNumber(likes),
            style: TextStyle(fontSize: valueSize),
          ),
          const VerticalDivider(
            indent: 7,
            endIndent: 7,
            color: Colors.grey,
            thickness: 1.5,
          ),
          Text(formatNumber(dislikes), style: TextStyle(fontSize: valueSize)),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.thumb_down,
            size: iconSize,
          )
        ]),
      ),
    );
  }
}
