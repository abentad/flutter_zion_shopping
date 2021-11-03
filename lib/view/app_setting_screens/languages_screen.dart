import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/lang_controller.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomMaterialButton(
                onPressed: () {
                  Get.find<LanguageController>().changeLanguage(langCode: 'en', countryCode: 'US');
                  Get.back();
                },
                btnLabel: "English",
              ),
              SizedBox(height: size.height * 0.02),
              CustomMaterialButton(
                onPressed: () {
                  Get.find<LanguageController>().changeLanguage(langCode: 'am', countryCode: 'ET');
                  Get.back();
                },
                btnLabel: "Amharic",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
