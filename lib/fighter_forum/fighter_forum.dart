import 'package:flutter/material.dart';
import 'package:ftf/fighter_forum/discussion_card.dart';
import 'package:ftf/fighter_forum/discussion_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/forum_data.dart';

class FighterForum extends StatelessWidget {
  const FighterForum({super.key});

  @override
  Widget build(BuildContext context) {
    final SliverGridDelegate gridDelegate;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoHeader(backRequired: true),
            const Text(
              'Fighter discussions',
              style: headerStyle,
            ),
            Padding(
              padding: paddingLRT,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Threads',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DiscussionPage(
                                      title: threads[0]['title'],
                                      body: threads[0]['body'],
                                      subTitle: threads[0]['subTitle'],
                                      links: threads[0]['links'],
                                      imagePath: threads[0]['imagePath'],
                                    )))
                          },
                          child: DiscussionCard(
                            title: threads[0]['title'],
                            description: threads[0]['description'],
                            imagePath: threads[0]['imagePath'],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DiscussionPage(
                                      title: threads[1]['title'],
                                      body: threads[1]['body'],
                                      subTitle: threads[1]['subTitle'],
                                      links: threads[1]['links'],
                                      imagePath: threads[1]['imagePath'],
                                    )))
                          },
                          child: DiscussionCard(
                            title: threads[1]['title'],
                            description: threads[1]['description'],
                            imagePath: threads[1]['imagePath'],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DiscussionPage(
                                      title: threads[2]['title'],
                                      body: threads[2]['body'],
                                      subTitle: threads[2]['subTitle'],
                                      links: threads[2]['links'],
                                      imagePath: threads[2]['imagePath'],
                                    )))
                          },
                          child: DiscussionCard(
                            title: threads[2]['title'],
                            description: threads[2]['description'],
                            imagePath: threads[2]['imagePath'],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DiscussionPage(
                                      title: threads[3]['title'],
                                      body: threads[3]['body'],
                                      subTitle: threads[3]['subTitle'],
                                      links: threads[3]['links'],
                                      imagePath: threads[3]['imagePath'],
                                    )))
                          },
                          child: DiscussionCard(
                            title: threads[3]['title'],
                            description: threads[3]['description'],
                            imagePath: threads[3]['imagePath'],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
