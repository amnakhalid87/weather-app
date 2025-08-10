import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData(
    cardColor: Color(0xffD1D5DB),

    scaffoldBackgroundColor: Color(0xffF9F9FB),
    primaryColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white54),
  );
  static final darkTheme = ThemeData(
    cardColor: Color(0xff334155),
    scaffoldBackgroundColor: Color(0xff1C2526),
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
