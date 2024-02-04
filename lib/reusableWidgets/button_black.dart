import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class BlackButton extends StatelessWidget {
  final Function onPressed;

  final String text;

  final double width;
  final double height;
  final double fontSize;

  const BlackButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width = 230,
      this.height = 60,
      this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(boxShadow: [containerShadowRed]),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.black),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            onPressed: () => onPressed(),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            )),
      ),
    );
  }
}
