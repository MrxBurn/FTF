import 'package:flutter/material.dart';

void showSnackBar(String text, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}
