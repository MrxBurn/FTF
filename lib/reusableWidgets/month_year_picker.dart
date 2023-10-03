// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';
import 'package:month_year_picker/month_year_picker.dart';

class YearPickerWidget extends StatefulWidget {
  String leadingText = '';

  TextEditingController controller;
  YearPickerWidget(
      {Key? key, required this.leadingText, required this.controller})
      : super(key: key);

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  DateTime now = DateTime.now();

  Future<void> onPressed({
    required BuildContext context,
  }) async {
    final monthSelected = await showMonthYearPicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.black,
                    brightness: Brightness.dark,
                    background: Colors.black,
                    surface: Colors.black,
                    surfaceTint: Colors.black,
                    tertiary: Colors.black,
                    tertiaryContainer: Colors.black,
                    primary: Colors.white, //cancel & ok buttons
                    primaryContainer: Colors.black,
                    onSecondary: Colors.black,
                    secondary: Colors.yellow, //month selection
                    secondaryContainer: Colors.black),
                dialogTheme: const DialogTheme(
                  backgroundColor: Colors.black,
                ),
                buttonTheme: const ButtonThemeData(buttonColor: Colors.red)),
            child: child!);
      },
    );
    setState(() {
      if (monthSelected != null) {
        widget.controller.text = '${monthSelected.month}-${monthSelected.year}';
      } else {
        widget.controller.text = '${now.month}-${now.year}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            widget.leadingText,
            style: bodyStyle,
          ),
          SizedBox(
            width: 100,
            height: 50,
            child: TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                ),
                controller: widget.controller,
                onTap: () => onPressed(context: context)),
          )
        ]));
  }
}
