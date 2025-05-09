import 'package:flutter/material.dart';

const headerStyle = TextStyle(fontSize: 24, color: Colors.white, height: -1);

const bodyStyle = TextStyle(fontSize: 16, color: Colors.white);

//colours
const lighterBlack = 0xff1E1E24;

const black = 0xff191716;

BoxShadow containerShadowRed = BoxShadow(
  color: Colors.red.withOpacity(0.3),
  spreadRadius: 1,
  blurRadius: 7,
  offset: const Offset(0, 4),
);

BoxShadow containerShadowWhite = BoxShadow(
  color: Colors.white.withOpacity(0.3),
  spreadRadius: 1,
  blurRadius: 7,
  offset: const Offset(0, 4),
);

BoxShadow containerShadowYellow = BoxShadow(
  color: Colors.yellow.withOpacity(0.3),
  spreadRadius: 1,
  blurRadius: 7,
  offset: const Offset(0, 4),
);

BoxShadow containerShadowBlack = BoxShadow(
  color: Colors.black.withOpacity(1),
  spreadRadius: 2,
  blurRadius: 7,
  offset: const Offset(0, 4),
);

EdgeInsets paddingLRT = const EdgeInsets.only(left: 24.0, right: 24, top: 16);
