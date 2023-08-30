import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoHeader extends StatefulWidget {
  bool backRequired;

  LogoHeader({Key? key, required this.backRequired}) : super(key: key);

  @override
  State<LogoHeader> createState() => _LogoHeaderState();
}

class _LogoHeaderState extends State<LogoHeader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/illustrations/boxing_ring.jpg',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: SvgPicture.asset('assets/illustrations/logo.svg'),
        ),
        widget.backRequired == true
            ? AppBar(
                leading: const BackButton(),
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : const SizedBox()
      ],
    );
  }
}
