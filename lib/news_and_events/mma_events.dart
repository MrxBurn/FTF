import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MMAEvents extends StatefulWidget {
  const MMAEvents({super.key});

  @override
  State<MMAEvents> createState() => _MMAEventsState();
}

class _MMAEventsState extends State<MMAEvents> {
  Map<String, dynamic> queryParameters = {
    "regions": "uk,eu",
    "oddsFormat": "decimal",
    "apiKey": "6f6072646af92ca46905b0ef75b0afb8",
    "commenceTimeFrom":
        "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())}Z",
  };

  Future<List<dynamic>> getMMAEvents() async {
    final uri = Uri.https(
      'api.the-odds-api.com',
      '/v4/sports/mma_mixed_martial_arts/odds',
      queryParameters.map((key, value) {
        return MapEntry(key, value.toString());
      }),
    );

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      final parsed = (jsonDecode(response.body) as List<dynamic>);
      return parsed;
    } else {
      throw Exception('Failed to load event');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMMAEvents(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Column(
              children: [],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
