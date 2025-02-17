import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/data/datasources/user_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:o2/presentation/providers/route_provider.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _userDataSource = UserDataSource();
  final _auth = FirebaseAuth.instance;

  late final FlutterLocalNotificationsPlugin _localNotifications;
  late final AndroidNotificationChannel _channel;

  Future<void> initialize() async {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    _localNotifications = FlutterLocalNotificationsPlugin();

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        ),
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _initializeLocalNotifications();
    await _setupFCM();
  }

  Future<void> _initializeLocalNotifications() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _setupFCM() async {
    await _requestNotificationPermission();

    final apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken == null) {
      debugPrint("APNS 토큰을 받을 수 없습니다. 오류 발생.");
    }

    final fcmToken = await _firebaseMessaging.getToken();
    await _updateToken(fcmToken);

    _firebaseMessaging.onTokenRefresh.listen(_updateToken);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _updateToken(String? token) async {
    if (token != null) {
      final user = _auth.currentUser;
      if (user != null) {
        await _userDataSource.updateFcmToken(user.uid, token);
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = json.decode(response.payload!);
      _handleNotificationData(data);
    }
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    if (data['type'] == 'chat') {
      final chatRoomId = data['chatId'].toString();
      final otherUserId = data['senderId'].toString();
      final productID = data['productId'].toString();

      final context = navigatorKey.currentContext;
      if (context != null) {
        context.push('/chat_room', extra: {
          'chatRoomId': chatRoomId,
          'otherUserId': otherUserId,
          'productID': productID,
        });
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (message.data['senderId'] == _auth.currentUser?.uid) return;

    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: true,
          presentBadge: true,
          presentAlert: true,
        ),
      ),
      payload: json.encode(message.data),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    if (message.data.isEmpty) return;
    _handleNotificationData(message.data);
  }
}
