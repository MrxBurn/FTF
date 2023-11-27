// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Column(
                            children: [
                              Text(
                                dislikedOfferList[idx]['creator'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                dislikedOfferList[idx]['creatorValue'],
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
                                dislikedOfferList[idx]['opponent'],
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                dislikedOfferList[idx]['opponentValue'],
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
