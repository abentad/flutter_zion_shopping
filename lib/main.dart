import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_node_auth/constants/app_constants.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/chat_controller.dart';
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

//
//
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  //ad initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  //

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
  Get.put<ChatController>(ChatController());

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
