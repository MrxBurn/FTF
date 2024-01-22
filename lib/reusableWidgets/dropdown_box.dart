import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class DropdownBox extends StatefulWidget {
  const DropdownBox(
      {super.key,
      required this.dropDownValue,
      required this.dropDownList,
      required this.changeParentValue,
      this.disabled = false,
      this.padding = const EdgeInsets.only(left: 24.0, right: 24)});

  final String dropDownValue;
  final List<String> dropDownList;
  final Function(String? value) changeParentValue;
  final bool disabled;
  final EdgeInsets padding;

  @override
  State<DropdownBox> createState() => _DropdownBoxState();
}

class _DropdownBoxState extends State<DropdownBox> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropDownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: widget.disabled == false
          ? (value) => widget.changeParentValue(value)
          : null,
      items: widget.dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
