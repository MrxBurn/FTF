import 'package:flutter/material.dart';
import 'package:ftf/styles/styles.dart';

class TypeBar extends StatefulWidget {
  const TypeBar({super.key});

  @override
  State<TypeBar> createState() => _TypeBarState();
}

class _TypeBarState extends State<TypeBar> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Press to type',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                borderSide: BorderSide(
                  color: Colors.red,
                ))),
      ),
    );
  }
}
