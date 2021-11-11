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
import 'package:flutter_node_auth/utils/strings.dart';
import 'package:flutter_node_auth/view/root.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> createBasicNotificaton({required String title, required String body}) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: createUniqueId(),
    channelKey: 'basic_channel',
    title: title,
    body: body,
    notificationLayout: NotificationLayout.Default,
  ));
}

int createUniqueId() {
  return DateTime.now().millisecond;
}

//
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //TODO: fix sending two notifications when app is in background or terminated
  createBasicNotificaton(title: message.notification!.title.toString(), body: message.notification!.body.toString());
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    AwesomeNotifications().initialize(
      'resource://drawable/res_notification',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Channel',
          defaultColor: Colors.teal,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          ledColor: Colors.blue,
          playSound: true,
          defaultPrivacy: NotificationPrivacy.Public,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          enableLights: true,
          ledOffMs: 800,
          ledOnMs: 800,
        ),
      ],
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

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
  Get.put<NotificationController>(NotificationController());
  Get.put<MessageController>(MessageController());

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
