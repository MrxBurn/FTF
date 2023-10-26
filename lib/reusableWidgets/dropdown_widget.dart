// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DropDownWidget extends StatefulWidget {
  String dropDownValue;
  List<String> dropDownList;
  String dropDownName;
  Function(String value)? changeParentValue;
  bool disabled;
  DropDownWidget(
      {Key? key,
      required this.dropDownValue,
      required this.dropDownList,
      required this.dropDownName,
      this.changeParentValue,
      this.disabled = false})
      : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.dropDownName,
              style: bodyStyle,
            ),
            const SizedBox(
              width: 50,
            ),
            DropdownButton<String>(
              value: widget.dropDownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: widget.disabled == false
                  ? (value) {
                      setState(() {
                        widget.dropDownValue = value!;
                      });
                      if (widget.changeParentValue != null) {
                        widget.changeParentValue!(value ?? '');
                      }
                    }
                  : null,
              items: widget.dropDownList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
