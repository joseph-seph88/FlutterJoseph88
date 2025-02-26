import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/service/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';

class WebsocketService extends GetxService {
  WebSocketChannel? _channel;
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  bool _isConnected = false;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse("${dotenv.env['MY_URL']}"));
      _isConnected = true;
      debugPrint("웹소켓 연결 완료");
    } catch (e) {
      _isConnected = false;
      debugPrint("웹소켓 연결 실패: ${e.toString()}");
    }
  }

  void startListeningForMessages() {
    if (_channel == null || !_isConnected) {
      debugPrint("웹소켓 연결이 되지 않았습니다.");
      return;
    }
    _channel!.stream.listen((message) {
      var jsonData = jsonDecode(message);
      String decodedMessage = jsonData['message'];
      String sender = jsonData['sender'];

      _notificationService.showInstanceNotification(
        "오늘 날씨 $sender님",
        decodedMessage,
        DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      );
    }, onDone: () {
      debugPrint("서버 연결이 종료되었습니다.");
    }, onError: (e) {
      debugPrint("WebSocket 오류: ${e.toString()}");
    });
  }

  void setId(String sender) {
    Map<String, dynamic> data = {
      'sender': sender,
    };
    _channel?.sink.add(jsonEncode(data));
  }

  void sendMessage(String message, String sender, String receiver) {
    Map<String, dynamic> data = {
      'sender': sender,
      'receiver': receiver,
      'message': message,
    };
    _channel?.sink.add(jsonEncode(data));
  }

}
