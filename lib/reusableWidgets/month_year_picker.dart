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
                onTap: () => showMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      //TODO: Implement on selected month and year
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
                              buttonTheme: const ButtonThemeData(
                                  buttonColor: Colors.red)),
                          child: child!);
                    })),
          )
        ]));
  }
}


// YearPicker(
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2100),
//                   selectedDate: DateTime.now(),
//                   onChanged: (date) {})
