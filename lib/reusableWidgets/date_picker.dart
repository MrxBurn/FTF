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

//TODO: Implement picker
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
                onTap: () => showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100))
                    .then(
                  (value) => setState(() => widget.controller.text =
                      '${value?.day}-${value?.month}-${value?.year}'),
                ),
              ))
        ],
      ),
    );
  }
}
