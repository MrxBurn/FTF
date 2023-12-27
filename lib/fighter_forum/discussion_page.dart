import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscussionPage extends StatelessWidget {
  const DiscussionPage(
      {super.key,
      required this.title,
      required this.body,
      required this.subTitle,
      required this.links,
      required this.imagePath});

  final String title;
  final String body;
  final String subTitle;
  final List<Map<String, String>> links;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CustomImageHeader(backRequired: true, imagePath: imagePath),
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
                  'For more insights (links):',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                  children: links.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => {launchUrl(Uri.parse(e['url']!))},
                      child: Text(
                        e['name']!,
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList())
            ],
          ),
        ),
      ]),
    );
  }
}
