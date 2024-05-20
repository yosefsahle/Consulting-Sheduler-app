import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class AppColors {
  static Color white = Colors.white;
  static Color primary = hexToColor('#2F3C7E');
  static Color secondary = hexToColor('#FBEAEB');
  static Color error = Colors.red;
  static Color warning = Colors.yellow;
  static Color grey = Colors.grey;
  static Color black45 = Colors.black45;
}
