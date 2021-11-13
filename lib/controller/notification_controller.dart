import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = "token";

  String? _token;
  String? get token => _token;
  final List<NotificationChannel> _notificationChannels = [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Channel',
      defaultColor: Colors.teal,
      importance: NotificationImportance.High,
      // channelShowBadge: true,
      playSound: true,
      defaultPrivacy: NotificationPrivacy.Private,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      enableVibration: true,
      enableLights: true,
    ),
  ];
  List<NotificationChannel> get notificationChannels => _notificationChannels;

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
  }

  //for sending notification by using device token
  Future<bool> sendNotificationUsingDeviceToken(String deviceToken, String messageTitle, String messageBody) async {
    // print('send notification called using:\ndeviceToken: $deviceToken\nmessageTitle: $messageTitle\nmessagebody: $messageBody');
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(BaseOptions(
      baseUrl: kbaseUrl,
      connectTimeout: 20000,
      receiveTimeout: 100000,
      headers: {'x-access-token': _token},
      responseType: ResponseType.json,
    ));
    try {
      final response = await _dio.get('/chat/sendNotification?deviceToken=$deviceToken&messageTitle=${messageTitle.capitalize}&messageBody=$messageBody');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //
  //
  //
  Future<void> createBasicNotificaton({required String title, required String body, String channelKey = 'basic_channel'}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: channelKey,
        title: title.capitalize,
        body: body,
        createdDate: DateTime.now().toString(),
        notificationLayout: NotificationLayout.Inbox,
      ),
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecond;
  }
}
