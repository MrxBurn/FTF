// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DatePicker extends StatefulWidget {
  String leadingText = '';

  TextEditingController controller;

  DatePicker({Key? key, required this.leadingText, required this.controller})
      : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime now = DateTime.now();

  Future onPressed({required BuildContext context}) async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
              data: ThemeData().copyWith(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.black,
                      brightness: Brightness.dark,
                      background: Colors.black,
                      surface: Colors.black,
                      surfaceTint: Colors.black,
                      tertiary: Colors.black,
                      tertiaryContainer: Colors.black,
                      primary: Colors.yellow, //cancel & ok buttons
                      primaryContainer: Colors.black,
                      onSecondary: Colors.black,
                      // secondary: Colors.yellow, //month selection
                      secondaryContainer: Colors.black)),
              child: child!);
        });

    setState(() {
      if (datePicked != null) {
        widget.controller.text =
            '${datePicked.day}-${datePicked.month}-${datePicked.year}';
      } else {
        widget.controller.text = now as String;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.leadingText,
            style: bodyStyle,
          ),
          SizedBox(
              width: 100,
              child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: widget.controller,
                  onTap: () => onPressed(context: context)))
        ],
      ),
    );
  }
}
