import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/styles/styles.dart';

class DiscussionPage extends StatelessWidget {
  const DiscussionPage(
      {super.key,
      required this.title,
      required this.body,
      required this.subTitle,
      required this.links});

  final String title;
  final String body;
  final String subTitle;
  final Map links;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CustomImageHeader(
            backRequired: true, imagePath: 'assets/illustrations/pension.jpg'),
        const SizedBox(
          height: 16,
        ),
        Text(
          title,
          style: headerStyle,
        ),
        Padding(
          padding: paddingLRT,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  subTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                body,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 24,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'For more insights',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Column(
                children: links.entries.map((e) {}).toList() as List<Widget>,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
