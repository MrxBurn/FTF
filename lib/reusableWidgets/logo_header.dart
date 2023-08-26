import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        Image.asset(
          'assets/illustrations/boxing_ring.jpg',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: SvgPicture.asset('assets/illustrations/logo.svg'),
        ),
      ],
    );
  }
}
