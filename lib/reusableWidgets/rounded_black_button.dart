import 'package:flutter/material.dart';

class BlackRoundedButton extends StatelessWidget {
  final bool isLoading;

  final Function onPressed;

  final String text;

  final Color shadowColour;

  final Icon? icon;

  final Color textColour;

  const BlackRoundedButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.text,
      this.shadowColour = Colors.red,
      this.icon,
      this.textColour = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        shadowColor: shadowColour,
      ),
      onPressed: () => onPressed(),
      child: isLoading == true
          ? const CircularProgressIndicator()
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
                  style: const TextStyle(fontSize: 16),
                ),
    );
  }
}
