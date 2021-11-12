import 'package:flutter/material.dart';

const color_primary = Colors.white;
const color_secondary = Colors.black;
const color_accent = Colors.black;
const chip_border_Color_selected = Color(0xfff8f8f8);
final chip_border_Color_Unselected = Colors.grey.shade300;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: color_primary,
  secondaryHeaderColor: color_secondary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: color_accent, foregroundColor: color_primary),
);

const d_color_primary = Colors.black87;
const d_color_secondary = Colors.white;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: d_color_primary,
  secondaryHeaderColor: d_color_secondary,
);
