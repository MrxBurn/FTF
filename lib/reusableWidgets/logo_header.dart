import 'dart:ui';

import 'package:flutter/material.dart';

class LogoHeader extends StatefulWidget {
  final bool backRequired;
  final Function? onPressed;

  LogoHeader({super.key, required this.backRequired, this.onPressed});

  @override
  State<LogoHeader> createState() => _LogoHeaderState();
}

class _LogoHeaderState extends State<LogoHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
          child: Image.asset(
            'assets/illustrations/boxing_ring.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 15),
            child: Image.asset(
              'assets/illustrations/logo.png',
              height: 220,
            ),
          ),
        ),
        widget.backRequired == true
            ? AppBar(
                leading: BackButton(
                  onPressed: () => widget.onPressed != null
                      ? widget.onPressed!()
                      : Navigator.pop(context),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : const SizedBox(),
      ],
    );
  }
}
