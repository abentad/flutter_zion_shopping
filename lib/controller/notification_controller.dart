import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  String? _token;
  String? get token => _token;

  NotificationController() {
    _getToken();
    _setupNotificationListener();
  }
  _getToken() async {
    _token = await FirebaseMessaging.instance.getToken();
    print("Token " + _token.toString());
  }

  _setupNotificationListener() {
    print('listener is on');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        createBasicNotificaton(title: notification.title!.capitalize.toString(), body: notification.body.toString());
      }
      print(notification.hashCode);
      print(notification!.title);
      print(notification.body.toString());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {return null});
  }

  Future<void> createBasicNotificaton({required String title, required String body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: title.capitalize,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecond;
  }
}
