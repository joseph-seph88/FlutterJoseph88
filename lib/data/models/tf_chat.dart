import 'package:flutter_gemini/flutter_gemini.dart';

class TfChat {
  final Content content;
  final String tone;
  final String feature;

  TfChat({
    required this.content,
    required this.tone,
    required this.feature,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'tone': tone,
      'feature': feature,
    };
  }

  factory TfChat.fromMap(Map<String, dynamic> chatData) {
    return TfChat(
      content: chatData['content'],
      tone: chatData['tone'],
      feature: chatData['feature'],
    );
  }
}
