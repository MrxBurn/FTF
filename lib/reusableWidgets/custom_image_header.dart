// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomImageHeader extends StatelessWidget {
  bool backRequired;
  Function? onPressed;
  String imagePath;

  CustomImageHeader(
      {super.key,
      required this.backRequired,
      this.onPressed,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/illustrations/boxing_ring.jpg',
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 170.0),
            child: CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage(
                  imagePath,
                )),
          ),
        ),
        backRequired == true
            ? AppBar(
                leading: BackButton(
                  onPressed: () =>
                      onPressed != null ? onPressed!() : Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : const SizedBox(),
      ],
    );
  }
}
