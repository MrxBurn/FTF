import 'package:flutter/material.dart';

class DiscussionCard extends StatelessWidget {
  const DiscussionCard(
      {super.key,
      required this.title,
      required this.description,
      required this.imagePath});

  final String title;
  final String description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 250,
      child: Card(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 12,
            ),
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                description,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}
