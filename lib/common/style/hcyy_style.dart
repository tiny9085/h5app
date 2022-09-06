

import 'package:flutter/material.dart';

class HCYYColor{
  static const int primaryIntValue = 0xFF5585FF;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryIntValue,
    const <int, Color>{
      50: const Color(primaryIntValue),
      100: const Color(primaryIntValue),
      200: const Color(primaryIntValue),
      300: const Color(primaryIntValue),
      400: const Color(primaryIntValue),
      500: const Color(primaryIntValue),
      600: const Color(primaryIntValue),
      700: const Color(primaryIntValue),
      800: const Color(primaryIntValue),
      900: const Color(primaryIntValue),
    },
  );

  static const Color primaryColor = Color(0xFF5585FF);
  static const Color blue_6d = Color(0xFF6DB9FF);
  static const Color grey_88 = Color(0xFF888888);
  static const Color grey_66 = Color(0xFF666666);
}

class HCYYConstant {
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

  static const inputText = TextStyle(
    color: HCYYColor.blue_6d,
    fontSize: smallTextSize,
  );

  static const labelText = TextStyle(
    color: Color(0xff666666),
    fontSize: smallTextSize,
  );

  static const whiteText = TextStyle(
    color: Colors.white,
    fontSize: smallTextSize,
  );
}