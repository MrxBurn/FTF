import 'package:flutter/material.dart';

class CircleNavigationButton extends StatelessWidget {
  CircleNavigationButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.color});

  final Function onPressed;
  final Widget icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: IconButton(onPressed: () => onPressed(), icon: icon));
  }
}
