import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node_auth/constants/app_constants.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/notification_controller.dart';
import 'package:flutter_node_auth/controller/lang_controller.dart';
import 'package:flutter_node_auth/controller/message_controller.dart';
import 'package:flutter_node_auth/controller/product_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/themes/theme_constants.dart';
import 'package:flutter_node_auth/utils/strings.dart';
import 'package:flutter_node_auth/view/root.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
//  // : fix sending two notifications when app is in background or terminated
//  // createBasicNotificaton(title: message.notification!.title.toString(), body: message.notification!.body.toString());
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //system orientation and statusbar color
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  //get controllers
  Get.put<NotificationController>(NotificationController());
  Get.put<LanguageController>(LanguageController());
  Get.put<AuthController>(AuthController());
  Get.put<ApiController>(ApiController());
  Get.put<ThemeController>(ThemeController());
  Get.put<ProductController>(ProductController());
  Get.put<MessageController>(MessageController());

  if (!kIsWeb) {
    AwesomeNotifications().initialize(null, Get.find<NotificationController>().notificationChannels);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: false, sound: true);
  }
  //disable screenshot or screen recording
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

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
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Get.find<ThemeController>().themeMode,
        home: const Root(),
      ),
    );
  }
}
