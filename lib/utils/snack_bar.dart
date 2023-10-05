import 'package:flutter/material.dart';

void showSnackBar(
    {required String text,
    required BuildContext context,
    Duration? duration,
    Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: color ?? Colors.red,
    ),
  );
}
