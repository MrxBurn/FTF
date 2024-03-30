import 'package:flutter/material.dart';

class TypeBar extends StatefulWidget {
  const TypeBar({super.key});

  @override
  State<TypeBar> createState() => _TypeBarState();
}

class _TypeBarState extends State<TypeBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Stack(
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 10.0, top: -15.0, bottom: 15.0),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.2, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              hintText: 'Press to type',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_circle_right,
                  color: Colors.yellow,
                )),
          )
        ],
      ),
    );
  }
}
