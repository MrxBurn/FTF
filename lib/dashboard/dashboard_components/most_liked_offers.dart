// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ftf/fan_fights_overview/fights_overview_widgets/number_of_likes_card.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/view_offer_page/view_offer_page_fighter.dart';

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
                    'Most recent liked offers',
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

  String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return likedOfferList.length > 0
        ? SizedBox(
            width: 300,
            height: 180,
            child: ListView.builder(
                itemCount: likedOfferList.length,
                itemBuilder: (context, idx) {
                  return SizedBox(
                    width: 300,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewOfferPage(
                                offerId: likedOfferList[idx]['offerId'],
                              ))),
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
                                    likes: likedOfferList[idx]['like'].length,
                                    dislikes:
                                        likedOfferList[idx]['dislike'].length),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Text(
                                            currentUser ==
                                                    likedOfferList[idx]
                                                        ['createdBy']
                                                ? likedOfferList[idx]['creator']
                                                : likedOfferList[idx]
                                                    ['opponent'],
                                            style: const TextStyle(
                                                color: Colors.yellow),
                                          ),
                                          Text(
                                            currentUser ==
                                                    likedOfferList[idx]
                                                        ['createdBy']
                                                ? likedOfferList[idx]
                                                        ['negotiationValues']
                                                    .last['creatorValue']
                                                    .toString()
                                                : likedOfferList[idx]
                                                        ['negotiationValues']
                                                    .last['opponentValue']
                                                    .toString(),
                                            style: const TextStyle(
                                                color: Colors.yellow),
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
                                                    likedOfferList[idx]
                                                        ['createdBy']
                                                ? likedOfferList[idx]['creator']
                                                : likedOfferList[idx]
                                                    ['opponent'],
                                            style: const TextStyle(
                                                color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            currentUser !=
                                                    likedOfferList[idx]
                                                        ['createdBy']
                                                ? likedOfferList[idx]
                                                        ['negotiationValues']
                                                    .last['creatorValue']
                                                    .toString()
                                                : likedOfferList[idx]
                                                        ['negotiationValues']
                                                    .last['opponentValue']
                                                    .toString(),
                                            style: const TextStyle(
                                                color: Colors.red),
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
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 16.0),
            child: Text(
              textAlign: TextAlign.center,
              'Currently, there are no users (fighters) signed up to FTF, so you do not have any liked offers.',
              style: TextStyle(color: Colors.grey),
            ),
          );
  }
}
