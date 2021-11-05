import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node_auth/constants/app_constants.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/lang_controller.dart';
import 'package:flutter_node_auth/controller/product_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/utils/strings.dart';
import 'package:flutter_node_auth/view/root.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  //ad initialization
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  //system orientation and statusbar color
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  //disable screenshot or screen recording
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  Get.put<LanguageController>(LanguageController());
  Get.put<AuthController>(AuthController());
  Get.put<ApiController>(ApiController());
  Get.put<ThemeController>(ThemeController());
  Get.put<ProductController>(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => GetMaterialApp(
        translations: Messages(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        title: kappName,
        theme: controller.defaultThemeData,
        home: const Root(),
      ),
    );
  }
}
