// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/styles/styles.dart';

class MostLikedOffers extends StatelessWidget {
  MostLikedOffers({super.key, required this.likedOfferList});

  List likedOfferList;

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
                  SvgPicture.asset(
                    'assets/icons/like.svg',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Most liked offers',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              LikedOffersList(likedOfferList: likedOfferList)
            ],
          ),
        ),
      ),
    );
  }
}

class LikedOffersList extends StatelessWidget {
  LikedOffersList({super.key, required this.likedOfferList});

  List likedOfferList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 180,
      child: ListView.builder(
          itemCount: likedOfferList.length,
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
                                likedOfferList[idx]['creator'],
                                style: const TextStyle(color: Colors.yellow),
                              ),
                              Text(
                                likedOfferList[idx]['creatorValue'],
                                style: const TextStyle(color: Colors.yellow),
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
                                likedOfferList[idx]['opponent'],
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                likedOfferList[idx]['opponentValue'],
                                style: const TextStyle(color: Colors.red),
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
