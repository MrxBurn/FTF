import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatefulWidget {
  const CustomPopupMenuButton({super.key, required this.children});

  final List<PopupMenuItem> children;

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        itemBuilder: (BuildContext context) {
          return widget.children;
        });
  }
}
