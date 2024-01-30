import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class ButtonCard extends StatefulWidget {
  final String path;
  final String route;
  final String name;

  const ButtonCard(
      {super.key, required this.path, required this.route, required this.name});

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  late Image image;

  @override
  void initState() {
    super.initState();
    image = Image.asset(
      widget.path,
      fit: BoxFit.fill,
      height: 145,
      width: double.infinity,
    );
  }

  @override
  void didChangeDependencies() async {
    await precacheImage(image.image, context, size: const Size(100, 100));
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
        height: 120,
        width: 130,
        child: Card(
            child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: image),
            ),
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    boxShadow: [containerShadowBlack],
                    color: Colors.black,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Text(
                  widget.name,
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
