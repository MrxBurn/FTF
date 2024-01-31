import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class ButtonCard extends StatelessWidget {
  final String route;
  final String name;
  final String path;

  const ButtonCard(
      {super.key, required this.route, required this.name, required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [containerShadowRed],
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        height: 120,
        width: 130,
        child: Card(
            child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Image.asset(
                    path,
                    fit: BoxFit.fill,
                    height: 145,
                    width: double.infinity,
                  )),
            ),

            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                  )
                ]),
              ),
            )
            // Center(
            //   child: Container(
            //     width: 100,
            //     decoration: BoxDecoration(
            //         boxShadow: [containerShadowBlack],
            //         color: Colors.black,
            //         borderRadius: const BorderRadius.all(Radius.circular(5))),
            //     child: Text(
            //       name,
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // )
          ],
        )),
      ),
    );
  }
}
