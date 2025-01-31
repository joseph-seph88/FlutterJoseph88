import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/data/models/chat_message_model.dart';

abstract interface class ChatRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms(String userId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatRoomId);

  Future<void> sendMessage(String chatRoomId, String content, String senderId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms(String userId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('buyer', isEqualTo: userId),
          Filter('seller', isEqualTo: userId),
        ))
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentTime')
        .snapshots();
  }

  @override
  Future<void> sendMessage(String chatRoomId, String content, String senderId) async {
    final timestamp = Timestamp.now();
    final message = ChatMessageModel(
      id: '',
      senderId: senderId,
      type: 'text',
      content: content,
      sentTime: timestamp,
    ).toJson();

    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message);

    _firestore.collection('chats').doc(chatRoomId).update({
      'lastMessage': content,
      'lastMessageSender': senderId,
      'lastMessageTime': timestamp,
      'unreadMessageCount': FieldValue.increment(1),
    });
  }
}
