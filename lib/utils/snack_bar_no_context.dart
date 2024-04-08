import 'package:flutter/material.dart';

void showSnackBarNoContext(
    {required String text,
    required final GlobalKey<ScaffoldMessengerState> snackbarKey,
    Duration? duration,
    Color? color}) {
  final SnackBar snackBar = SnackBar(
    showCloseIcon: true,
    content: Text(text, style: const TextStyle(color: Colors.white)),
    duration: const Duration(seconds: 3),
    backgroundColor: color ?? Colors.red,
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}
