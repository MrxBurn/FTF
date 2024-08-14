import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class NumberFollowers extends StatelessWidget {
  NumberFollowers({super.key, required this.numberFollowers});

  final String numberFollowers;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: 100, maxWidth: 200, maxHeight: 95),
      decoration: BoxDecoration(boxShadow: [containerShadowRed]),
      child: Container(
        decoration: const BoxDecoration(color: Color(lighterBlack)),
        child: Column(
          children: [
            Text(
              numberFollowers,
              style: const TextStyle(fontSize: 32),
            ),
            const Text('Followers', style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}
