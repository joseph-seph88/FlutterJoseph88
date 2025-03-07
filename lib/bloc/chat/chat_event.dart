import 'package:equatable/equatable.dart';
import 'package:personal_select_chat/data/models/chat_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final ChatModel message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SendImageEvent extends ChatEvent {
  final List<String> imagePaths;

  const SendImageEvent(this.imagePaths);

  @override
  List<Object> get props => [imagePaths];
}
