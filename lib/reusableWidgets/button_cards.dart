import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class ButtonCard extends StatelessWidget {
  final String route;
  final String name;
  final String path;
  final Future<dynamic> Function()?
      navigate; // used for navigation with arguments

  const ButtonCard(
      {super.key,
      required this.route,
      required this.name,
      required this.path,
      this.navigate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          navigate != null ? navigate!() : Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [containerShadowYellow],
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
            Stack(children: [
              Center(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                        boxShadow: [containerShadowBlack],
                        color: Colors.black,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
              Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                ),
              )
            ])
          ],
        )),
      ),
    );
  }
}
