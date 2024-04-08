import 'package:flutter/material.dart';

void showSnackBarNoContext(
    {required String text,
    required final GlobalKey<ScaffoldMessengerState> snackbarKey,
    Duration? duration,
    Color? color}) {
  final SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 3),
    backgroundColor: color ?? Colors.red,
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}
