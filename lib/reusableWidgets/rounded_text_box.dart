import 'package:flutter/material.dart';

class RoundedTextInput extends StatelessWidget {
  const RoundedTextInput(
      {super.key,
      required this.controller,
      this.disabled = false,
      this.width = 200});

  final TextEditingController controller;
  final bool disabled;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 30,
      child: TextFormField(
        style: const TextStyle(
            color: Colors.grey, fontSize: 14, overflow: TextOverflow.ellipsis),
        readOnly: disabled,
        key: GlobalKey(),
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.black,
          filled: true,
          contentPadding:
              const EdgeInsets.only(left: 10.0, top: -15.0, bottom: 15.0),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1.2, color: Colors.grey.withOpacity(0.5)),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}
