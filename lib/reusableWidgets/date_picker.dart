import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DatePicker extends StatefulWidget {
  final String leadingText;

  final TextEditingController displayDate;

  final Function(DateTime) callback;

  final bool disabled;

  DatePicker(
      {super.key,
      required this.leadingText,
      required this.displayDate,
      required this.callback,
      this.disabled = false});

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
