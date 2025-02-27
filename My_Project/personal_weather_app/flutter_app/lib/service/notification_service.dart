import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  static void onDidReceiveBackgroundNotification(
      NotificationResponse notificationResponse) {}

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotification,
    );

    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async{
    if(Platform.isAndroid){
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }

    if(Platform.isIOS){
      final iOSImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iOSImplementation != null) {
        await iOSImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }
  }

  Future<void> showInstanceNotification(
      String title, String body, int index) async {
    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'weather_channel',
          title,
          channelDescription: body,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails());

    await _notificationsPlugin.show(index, title, body, notificationDetails);
  }
}