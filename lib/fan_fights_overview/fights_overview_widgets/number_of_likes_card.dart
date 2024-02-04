import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:intl/intl.dart';

class NumberOfLikes extends StatelessWidget {
  const NumberOfLikes({super.key, required this.likes, required this.dislikes});

  final int likes;
  final int dislikes;

  String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [containerShadowRed],
            borderRadius: BorderRadius.circular(5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.thumb_up),
          const SizedBox(
            width: 5,
          ),
          Text(formatNumber(likes)),
          const VerticalDivider(
            indent: 7,
            endIndent: 7,
            color: Colors.grey,
            thickness: 1.5,
          ),
          Text(formatNumber(dislikes)),
          const SizedBox(
            width: 5,
          ),
          const Icon(Icons.thumb_down)
        ]),
      ),
    );
  }
}
