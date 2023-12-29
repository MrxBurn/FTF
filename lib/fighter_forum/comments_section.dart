import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:ftf/utils/general.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.getComments});

  final Future<List<Map<String, dynamic>>> getComments;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getComments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, idx) {
                var data = snapshot.data[idx];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                              data['profileImage'] ?? imgPlaceholder,
                            )),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${data['firstName']} ${data['lastName']} - ${data['createdAt'].toDate().day}/${data['createdAt'].toDate().month}/${data['createdAt'].toDate().year} - ${data['createdAt'].toDate().hour}:${data['createdAt'].toDate().minute}'),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(data['comment'])
                            ]),
                      ],
                    ),
                  ),
                );
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
