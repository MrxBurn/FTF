import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController? controller;

  final String? pLabelText;

  final String? Function(String?)? validatorFunction;

  final bool? passwordField;

  InputFieldWidget(
      {super.key,
      this.controller,
      required this.pLabelText,
      this.validatorFunction,
      this.passwordField});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: TextFormField(
          onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            labelStyle: const TextStyle(color: Colors.grey),
            labelText: pLabelText,
          ),
          obscureText: passwordField == true ? true : false,
          // onChanged: (value) => fieldValue = value,
          validator: validatorFunction),
    );
  }
}
