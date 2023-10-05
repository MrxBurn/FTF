import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class BlackButton extends StatelessWidget {
  final Function onPressed;

  final String text;

  const BlackButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 60,
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
      ),
    );
  }
}
