import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:get/get.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ThemesButton(
              onTap: () {
                Get.find<ThemeController>().changeTheme(Colors.red);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              btnColor: Colors.red,
            ),
            ThemesButton(
              onTap: () {
                Get.find<ThemeController>().changeTheme(Colors.orange);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              btnColor: Colors.orange,
            ),
            ThemesButton(
              onTap: () {
                Get.find<ThemeController>().changeTheme(Colors.blue);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              btnColor: Colors.blue,
            ),
            ThemesButton(
              onTap: () {
                Get.find<ThemeController>().changeToDartTheme();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              btnColor: Colors.black,
            ),
            ThemesButton(
              onTap: () {
                Get.find<ThemeController>().changeToLightTheme();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              btnColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class ThemesButton extends StatelessWidget {
  const ThemesButton({Key? key, required this.btnColor, required this.onTap}) : super(key: key);
  final Color btnColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height * 0.12,
        width: size.width * 0.12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: btnColor,
        ),
      ),
    );
  }
}
