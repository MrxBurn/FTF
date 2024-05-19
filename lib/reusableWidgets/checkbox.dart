// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  bool checkValue;
  String title;

  final Function? onChanged;

  CheckBoxWidget(
      {super.key,
      required this.checkValue,
      required this.title,
      this.onChanged});

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      checkColor: Colors.white,
      fillColor: const WidgetStatePropertyAll(Colors.grey),
      title: Text(widget.title),
      value: widget.checkValue,
      onChanged: (newValue) {
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
