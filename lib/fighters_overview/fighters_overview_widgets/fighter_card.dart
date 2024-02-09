import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';

class FighterCard extends StatefulWidget {
  const FighterCard(
      {super.key,
      required this.imageUrl,
      required this.fighterName,
      required this.weightClass,
      required this.fighterType,
      required this.fighterStatus,
      required this.gender});

  final String imageUrl;
  final String fighterName;
  final String weightClass;
  final String fighterType;
  final String fighterStatus;
  final String gender;

  @override
  State<FighterCard> createState() => _FighterCardState();
}

class _FighterCardState extends State<FighterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.white,
      child: Column(children: [
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: widget.imageUrl.isNotEmpty
                  ? NetworkImage(widget.imageUrl)
                  : NetworkImage(imgPlaceholder),
            ),
            SizedBox(
              width: 100,
              child: Text(
                widget.fighterName,
                style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Container(
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.black,
                  boxShadow: [containerShadowRed]),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.weightClass,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        widget.fighterType,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        widget.fighterStatus,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        widget.gender,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ]),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        const Text(
          'Press for more details',
          style: TextStyle(decoration: TextDecoration.underline, fontSize: 10),
        )
      ]),
    );
  }
}
