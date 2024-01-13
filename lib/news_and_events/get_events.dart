import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> queryParameters = {
  "regions": "uk,eu",
  "oddsFormat": "decimal",
  "apiKey": "b77f5601162111788484440fa60588bd",
  "commenceTimeFrom":
      "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())}Z",
};

Future<List<dynamic>> getEvents(String type) async {
  DocumentReference<Map<String, dynamic>> firebase =
      FirebaseFirestore.instance.collection('boxingEvents').doc('events');

  List resultList = [];

  final uri = Uri.https(
    'api.the-odds-api.com',
    '/v4/sports/$type/odds',
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
        await firebase
            .set({"monthNumber": DateTime.now().month, "events": parsed});
        resultList.add(value.data());
      }
    } else {
      resultList.add(value.data());
    }
  });

  return resultList;
}
