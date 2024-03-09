import 'package:flutter/material.dart';

class BlackRoundedButton extends StatelessWidget {
  final bool isLoading;

  final Function onPressed;

  final String text;

  final Color shadowColour;

  final Icon? icon;

  final Color textColour;

  final double? width;

  final double? height;

  final double fontSize;

  final bool isDisabled;

  const BlackRoundedButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.text,
      this.shadowColour = Colors.red,
      this.icon,
      this.textColour = Colors.white,
      this.width,
      this.height,
      this.fontSize = 16,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: shadowColour,
        ),
        onPressed: !isDisabled ? () => onPressed() : null,
        child: isLoading == true
            ? Transform.scale(
                scale: 0.5, child: const CircularProgressIndicator())
            : icon != null
                ? Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      icon ?? const SizedBox(),
                      Text(
                        text,
                        style: TextStyle(fontSize: 16, color: textColour),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: TextStyle(fontSize: fontSize),
                  ),
      ),
    );
  }
}
