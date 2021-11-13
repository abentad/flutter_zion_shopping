import 'package:flutter/material.dart';

const colorPrimary = Colors.white;
const colorSecondary = Colors.black;
const colorAccent = Colors.black;
const chipBorderColorSelected = Color(0xfff8f8f8);
final chipBorderColorUnselected = Colors.grey.shade300;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimary,
  secondaryHeaderColor: colorSecondary,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: colorAccent, foregroundColor: colorPrimary),
);

const dColorPrimary = Colors.black87;
const dColorSecondary = Colors.white;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: dColorPrimary,
  secondaryHeaderColor: dColorSecondary,
);
