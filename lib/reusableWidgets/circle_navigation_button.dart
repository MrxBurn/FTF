// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CircleNavigationButton extends StatelessWidget {
  CircleNavigationButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.color})
      : super(key: key);

  Function onPressed;
  Widget icon;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: IconButton(onPressed: () => onPressed(), icon: icon));
  }
}
