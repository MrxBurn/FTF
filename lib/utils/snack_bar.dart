import 'package:flutter/material.dart';

void showSnackBar(
    {required String text, required BuildContext context, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration ?? const Duration(seconds: 3),
    ),
  );
}
