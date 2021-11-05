import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_node_auth/main.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ChatController() {
    _getToken();
    _setupNotificationListener();
  }
  _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Token " + token.toString());
  }

  _setupNotificationListener() {
    //
    AndroidInitializationSettings _initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings _initializationSettings = InitializationSettings(android: _initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(_initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
            ));
      }
      print(notification.hashCode);
      print(notification!.title);
      print(notification.body.toString());
    });
    //
  }
}
