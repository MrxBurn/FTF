import 'package:flutter/material.dart';
import 'package:ftf/fighter_forum/forum_page.dart';
import 'package:ftf/utils/forum_data.dart';

class FighterForum extends StatelessWidget {
  const FighterForum({super.key});

  @override
  Widget build(BuildContext context) {
    return ForumPage(
      title: 'Discussions',
      threads: threads,
      isFanForum: false,
    );
  }
}
