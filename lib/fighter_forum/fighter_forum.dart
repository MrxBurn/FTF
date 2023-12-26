import 'package:flutter/material.dart';
import 'package:ftf/fighter_forum/discussion_card.dart';
import 'package:ftf/fighter_forum/discussion_page.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';

List threads = [
  {
    'title': 'Pension Planning',
    'imagePath': 'assets/illustrations/pension.jpg',
    'description':
        'Exploring retirement planning, pension options, and long-term financial security strategies for your career.',
    'subTitle': 'Secure Your Financial Future',
    'body':
        "Explore retirement planning, pension options, and long-term financial strategies for your fighting career. Join discussions and access insights from a range of fighters. Click 'Chat forum' for valuable insights and start planning your secure future today.",
    'links': [
      {'name': 'Wealth and Tax Advice', 'url': 'https://www.evelyn.com/'},
      {
        'name': 'Pensions Explained',
        'url': 'https://www.youtube.com/watch?v=E2RDvUiRRG8'
      },
      {
        'name': 'Fighter Uses Pension for Inspiration',
        'url': 'https://www.youtube.com/watch?v=-jCWvQLcqCc'
      },
      {
        'name': 'For Fighters: Achieving Financial Goals',
        'url': 'https://www.devere-group.com/'
      },
    ]
  },
  {
    'title': 'Fighter Management Tips',
    'imagePath': 'assets/illustrations/management.jpg',
    'description':
        'Discussions on effective management, handling contracts, negotiations, and developing successful partnerships with managers and promoters.',
    'subTitle': 'Masterful Career Management',
    'body':
        "Engage in discussions on effective fighter management, handling contracts, negotiations, and cultivating successful partnerships with managers and promoters. Click 'Chat forum' for invaluable discussions and tips from experienced fighters."
  },
  {
    'title': 'Nutrition for Performance',
    'imagePath': 'assets/illustrations/nutrition.jpg',
    'description':
        'Topics focusing on specialized diets, meal plans, supplements, and nutrition strategies to enhance your performance and recovery.',
    'subTitle': 'Elevate Your Game',
    'body':
        "Explore specialized diets, meal plans, supplements, and nutrition strategies tailored to enhance your performance and accelerate recovery. Dive into the 'Chat forum' for in-depth discussions and advice from fellow fighters."
  },
  {
    'title': 'Promotion Insights',
    'imagePath': 'assets/illustrations/promotion.jpeg',
    'description':
        'Conversations about self-promotion, branding, marketing strategies, and leveraging social media to boost visibility and fan engagement.',
    'subTitle': 'Boost Your Visibility',
    'body':
        "Engage in conversations on self-promotion, branding, and dynamic marketing strategies. Delve into the art of leveraging media effectively to amplify visibility and foster stronger connections with your fan base. Click the 'Chat forum' for valuable insights and practical tips from fighters at different levels."
  }
];

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
