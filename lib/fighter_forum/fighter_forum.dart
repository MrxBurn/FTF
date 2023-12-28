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
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: threads.length,
                        itemBuilder: (BuildContext context, idx) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DiscussionPage(
                                        firebaseCollection: threads[idx]
                                            ['collection'],
                                        title: threads[idx]['title'],
                                        body: threads[idx]['body'],
                                        subTitle: threads[idx]['subTitle'],
                                        links: threads[idx]['links'],
                                        imagePath: threads[idx]['imagePath'],
                                      )))
                            },
                            child: DiscussionCard(
                              title: threads[idx]['title'],
                              description: threads[idx]['description'],
                              imagePath: threads[idx]['imagePath'],
                            ),
                          );
                        }),
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
