import 'package:flutter/material.dart';
import 'package:ftf/fighter_forum/forum_page.dart';
import 'package:ftf/utils/fan_forum_data.dart';

class FanForumPage extends StatelessWidget {
  const FanForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ForumPage(
      title: 'Fan discussions',
      threads: fanThreads,
      isFanForum: true,
    );
  }
}
