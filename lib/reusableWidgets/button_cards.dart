import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class ButtonCard extends StatefulWidget {
  final String path;
  final String route;

  const ButtonCard({
    super.key,
    required this.path,
    required this.route,
  });

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  late Image image;

  @override
  void initState() {
    image = Image.asset(
      widget.path,
      fit: BoxFit.cover,
      height: 145,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(image.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, widget.route),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [containerShadowRed],
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        height: 153,
        width: 150,
        child: Card(
            child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: image),
            ),
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    boxShadow: [containerShadowBlack],
                    color: Colors.black,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Text(
                  'Create offer',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
