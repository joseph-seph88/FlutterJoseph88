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

    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
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
//
//    Future<void> scheduleNotification(
//       String title, String body, DateTime scheduledDate, int index) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'default_channel_id',
//       'default_channel_name',
//       channelDescription: '알림 채널 설명',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     const DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails(
//       sound: 'default',
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     NotificationDetails notificationDetails = const NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//
//     await _notificationsPlugin.zonedSchedule(
//       index,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
//
//    Future cancelNotification(int index) async {
//     await _notificationsPlugin.cancel(index);
//   }
//
//    Future allCancelNotification() async {
//     await _notificationsPlugin.cancelAll();
//   }
// }
