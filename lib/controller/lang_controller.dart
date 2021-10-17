import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final String langCodeKey = 'langCode';
  final String countryCodeKey = 'countryCode';
  final prefs = const FlutterSecureStorage();

  LanguageController() {
    loadLocale();
  }

  void loadLocale() async {
    if (await prefs.read(key: langCodeKey) != null) {
      String langCode = await prefs.read(key: langCodeKey) ?? "";
      String countryCode = await prefs.read(key: countryCodeKey) ?? "";
      Get.updateLocale(Locale(langCode, countryCode));
    }
  }

  void changeLanguage({required String langCode, required String countryCode}) async {
    Get.updateLocale(Locale(langCode, countryCode));
    await prefs.write(key: langCodeKey, value: langCode);
    await prefs.write(key: countryCodeKey, value: countryCode);
  }
}
