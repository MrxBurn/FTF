// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BlackRoundedButton extends StatelessWidget {
  bool isLoading;

  Function onPressed;

  String text;

  BlackRoundedButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: Colors.red,
        ),
        onPressed: () => onPressed(),
        child: isLoading == true
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: const TextStyle(fontSize: 16),
              ));
  }
}
