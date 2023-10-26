// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DatePicker extends StatefulWidget {
  String leadingText = '';

  TextEditingController displayDate;

  Function(DateTime) callback;

  bool disabled;

  DatePicker(
      {Key? key,
      required this.leadingText,
      required this.displayDate,
      required this.callback,
      this.disabled = false})
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

    if (datePicked != null) {
      widget.callback(datePicked);
    } else {
      widget.callback(now);
    }
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
                  controller: widget.displayDate,
                  onTap: widget.disabled == false
                      ? () => onPressed(context: context)
                      : null))
        ],
      ),
    );
  }
}
