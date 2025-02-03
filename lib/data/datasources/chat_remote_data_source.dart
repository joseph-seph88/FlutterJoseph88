import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/data/models/chat_message_model.dart';

abstract interface class ChatRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms(String userId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatRoomId);

  Future<String> createChatRoom(
      String content, String otherUserId, String senderId);

  Future<void> sendMessage(String chatRoomId, String content, String senderId);

  Future<void> markChatAsRead(String chatRoomId, String userId);
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
        .orderBy('sentTime', descending: true)
        .snapshots();
  }

  @override
  Future<String> createChatRoom(
      String content, String otherUserId, String senderId) async {
    final timestamp = Timestamp.now();
    final message = ChatMessageModel(
      id: '',
      senderId: senderId,
      type: 'text',
      content: content,
      sentTime: timestamp,
    ).toJson();

    final chatRoomId = (await _firestore.collection('chats').add({
      'buyer': senderId,
      'seller': otherUserId,
      'lastMessage': content,
      'lastMessageTime': timestamp,
      'lastMessageSender': senderId,
      'unreadMessageCount': 1,
    })).id;

    _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message);

    return chatRoomId;
  }

  @override
  Future<void> sendMessage(
      String chatRoomId, String content, String senderId) async {
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

  @override
  Future<void> markChatAsRead(String chatRoomId, String userId) async {
    final chatRoom = await _firestore.collection('chats').doc(chatRoomId).get();
    final senderId = chatRoom['lastMessageSender'];

    if (userId != senderId) {
      await _firestore.collection('chats').doc(chatRoomId).update({
        'unreadMessageCount': 0,
      });
    }
  }
}
