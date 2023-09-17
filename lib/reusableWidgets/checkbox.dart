// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CheckBoxWidget extends StatefulWidget {
  bool checkValue = false;
  String title;

  CheckBoxWidget({Key? key, required this.checkValue, required this.title})
      : super(key: key);

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      checkColor: Colors.white,
      fillColor: const MaterialStatePropertyAll(Colors.grey),
      title: Text(widget.title),
      value: widget.checkValue,
      onChanged: (newValue) {
        setState(() {
          widget.checkValue = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
