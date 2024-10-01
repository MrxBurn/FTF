import 'package:flutter/material.dart';

class TextEllipsis extends StatelessWidget {
  const TextEllipsis({
    super.key,
    required this.text,
    this.style,
    required this.maxWidth,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final double maxWidth;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Text(
        textAlign: textAlign,
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
