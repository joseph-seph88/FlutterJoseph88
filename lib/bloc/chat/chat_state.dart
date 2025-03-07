import 'package:equatable/equatable.dart';
import 'package:personal_select_chat/data/models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class InitialChatState extends ChatState {}

class UpdateChatState extends ChatState {
  final List<ChatModel> messageList;
  const UpdateChatState(this.messageList);

  @override
  List<Object> get props => [messageList];
}
