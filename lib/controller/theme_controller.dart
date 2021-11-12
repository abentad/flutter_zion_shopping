import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  toggleThemeMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    update();
  }
}





  // ThemeData defaultThemeData = ThemeData(
  //   scaffoldBackgroundColor: Colors.white,
  //   primarySwatch: Colors.teal,
  // );
  // Map<String, Color> defaultTheme = {
  //   "addButton": Colors.teal,
  //   "whiteColor": Colors.white,
  //   "blackColor": Colors.black,
  //   "greyColor": Colors.grey,
  //   "bgColor": Colors.white,
  //   "greyishColor": const Color(0xfff2f2f2),
  // };

  // void changeToDartTheme() {
  //   defaultTheme['addButton'] = Colors.white;
  //   defaultTheme['whiteColor'] = Colors.black;
  //   defaultTheme['bgColor'] = Colors.black87;
  //   defaultTheme['greyishColor'] = Colors.black12;
  //   defaultTheme['blackColor'] = Colors.white;
  //   defaultTheme['greyColor'] = Colors.white;
  //   update();
  // }

  // void changeToLightTheme() {
  //   defaultTheme['addButton'] = Colors.teal;
  //   defaultTheme['whiteColor'] = Colors.white;
  //   defaultTheme['bgColor'] = Colors.white;
  //   defaultTheme['greyishColor'] = const Color(0xfff2f2f2);
  //   defaultTheme['blackColor'] = Colors.black;
  //   defaultTheme['greyColor'] = Colors.grey;
  //   update();
  // }

  // void changeTheme(Color color) {
  //   defaultTheme['addButton'] = color;
  //   update();
  // }