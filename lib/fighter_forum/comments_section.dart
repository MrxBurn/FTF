import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.getComments});

  final Future<List<Map<String, dynamic>>> Function() getComments;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getComments(),
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                            text: '${data['firstName']} ${data['lastName']} ',
                            style: TextStyle(
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(1.0)),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${data['createdAt'].toDate().day}/${data['createdAt'].toDate().month}/${data['createdAt'].toDate().year} - ${data['createdAt'].toDate().hour}:${data['createdAt'].toDate().minute}',
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          )),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(data['comment'])
                        ]),
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
