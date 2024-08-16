import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/styles/styles.dart';

class OffersEngagement extends StatelessWidget {
  OffersEngagement({super.key, required this.likes, required this.dislikes});

  final String likes;
  final String dislikes;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: 100, maxWidth: 220, maxHeight: 95),
      decoration: BoxDecoration(boxShadow: [containerShadowRed]),
      child: Container(
        decoration: const BoxDecoration(color: Color(lighterBlack)),
        child: Column(
          children: [
            const Text(
              'Engagement',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Likes'),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/like.svg',
                            width: 18,
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(likes),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Dislikes'),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Transform.flip(
                            flipY: true,
                            child: SvgPicture.asset(
                              'assets/icons/like.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(dislikes),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
