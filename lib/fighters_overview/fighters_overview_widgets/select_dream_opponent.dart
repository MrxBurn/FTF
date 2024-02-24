import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getFighters() async {
  var result = await FirebaseFirestore.instance
      .collection('users')
      .where('route', isEqualTo: 'fighter')
      .get()
      .then((value) => value.docs.map((e) => e.data()));

  return result.toList();
}

void showDreamOpponent(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
              height: 450,
              child: FutureBuilder(
                  future: getFighters(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var data = snapshot.data;

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 16,
                        ),
                        itemBuilder: (BuildContext context, idx) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: ChoiceChip(
                                label: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                        '${data[idx]['firstName']} ${data[idx]['lastName']}')),
                                selected: false),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
        );
      });
}
