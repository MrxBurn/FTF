// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/fan_fights_overview/fights_overview_widgets/number_of_likes_card.dart';
import 'package:ftf/styles/styles.dart';

class MostDislikedOffers extends StatelessWidget {
  MostDislikedOffers({super.key, required this.dislikedOfferList});

  List dislikedOfferList;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.flip(
                    flipY: true,
                    child: SvgPicture.asset(
                      'assets/icons/like.svg',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Most disliked offers',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              DislikedOfferList(dislikedOfferList: dislikedOfferList)
            ],
          ),
        ),
      ),
    );
  }
}

class DislikedOfferList extends StatelessWidget {
  DislikedOfferList({super.key, required this.dislikedOfferList});

  List dislikedOfferList;

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 180,
      child: ListView.builder(
          itemCount: dislikedOfferList.length,
          itemBuilder: (context, idx) {
            return SizedBox(
              width: 300,
              child: Card(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        NumberOfLikes(
                            height: 26,
                            valueSize: 16,
                            iconSize: 16,
                            likes: dislikedOfferList[idx]['like'].length,
                            dislikes: dislikedOfferList[idx]['dislike'].length),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text(
                                    currentUser ==
                                            dislikedOfferList[idx]['createdBy']
                                        ? dislikedOfferList[idx]['creator']
                                        : dislikedOfferList[idx]['opponent'],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    currentUser ==
                                            dislikedOfferList[idx]['createdBy']
                                        ? dislikedOfferList[idx]
                                                ['negotiationValues']
                                            .last['creatorValue']
                                            .toString()
                                        : dislikedOfferList[idx]
                                                ['negotiationValues']
                                            .last['opponentValue']
                                            .toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            const Text('%'),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  Text(
                                    currentUser !=
                                            dislikedOfferList[idx]['createdBy']
                                        ? dislikedOfferList[idx]['creator']
                                        : dislikedOfferList[idx]['opponent'],
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    currentUser !=
                                            dislikedOfferList[idx]['createdBy']
                                        ? dislikedOfferList[idx]
                                                ['negotiationValues']
                                            .last['creatorValue']
                                            .toString()
                                        : dislikedOfferList[idx]
                                                ['negotiationValues']
                                            .last['opponentValue']
                                            .toString(),
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
