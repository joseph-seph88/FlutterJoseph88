import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_select_chat/data/models/chat_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(InitialChatState()) {
    on<SendMessageEvent>((event, emit) {
      final ChatModel chatMsg =
          ChatModel(text: event.message.text, isMine: true);

      if (state is UpdateChatState) {
        final List<ChatModel> messageList =
            List.from((state as UpdateChatState).messageList);
        messageList.add(chatMsg);
        emit(UpdateChatState(messageList));
      } else {
        emit(UpdateChatState([chatMsg]));
      }
    });

    on<SendImageEvent>((event, emit) async {
      final List<ChatModel> chatImages = event.imagePaths.map((image) {
        return ChatModel(imagePaths: [image], isMine: true);
      }).toList();

      if (state is UpdateChatState) {
        final List<ChatModel> messageList =
            List.from((state as UpdateChatState).messageList);
        messageList.addAll(chatImages);
        emit(UpdateChatState(messageList));
      } else {
        emit(UpdateChatState(chatImages));
      }
    });
  }
}
