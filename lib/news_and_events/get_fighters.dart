import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> queryParameters = {
  "key": "4ff5a66e1e6e486f8267e4cf9b2b060f"
};

Future<List<dynamic>> getFighterStats() async {
  DocumentReference<Map<String, dynamic>> firebase =
      FirebaseFirestore.instance.collection('fighterNews').doc('fighters');

  List resultList = [];

  final uri = Uri.https(
    'api.sportsdata.io',
    '/v3/mma/scores/json/Fighters',
    queryParameters.map((key, value) {
      return MapEntry(key, value.toString());
    }),
  );

  await firebase.get().then((value) async {
    if (DateTime.now().month != value.data()?['monthNumber']) {
      final response = await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        final parsed = (jsonDecode(response.body) as List<dynamic>);

        await firebase.set({
          "monthNumber": DateTime.now().month,
          "fighters": parsed.take(100)
        });
        resultList.add(value.data());
      }
    } else {
      resultList.add(value.data());
    }
  });

  return resultList;
}
