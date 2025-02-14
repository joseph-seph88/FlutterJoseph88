import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/data/models/chat_message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int pageSize = 20;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatRoomId, int pageSize) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .limit(pageSize)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchMoreMessages(String chatRoomId, Timestamp last) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .startAfter([last])
        .limit(pageSize)
        .get();
  }

  Future<String> createChatRoom(String otherUserId, String senderId, String productID) async {
    final chatRoomId = (await _firestore.collection('chats').add({
      'buyer': senderId,
      'seller': otherUserId,
      'unreadMessageCount': 0,
      'productID': productID,
    })).id;

    return chatRoomId;
  }

  Future<void> sendMessage(
      String chatRoomId, String type, String content, String senderId) async {
    final timestamp = Timestamp.now();
    final message = ChatMessageModel(
      id: '',
      senderId: senderId,
      type: type,
      content: content,
      sentTime: timestamp,
    ).toJson();

    final messageId = (await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message)).id;

    _firestore.collection('chats').doc(chatRoomId).update({
      'lastMessage': content,
      'lastMessageId': messageId,
      'lastMessageSender': senderId,
      'lastMessageTime': timestamp,
      'lastMessageType': type,
      'unreadMessageCount': FieldValue.increment(1),
    });
  }

  Future<void> markChatAsRead(String chatRoomId, String userId) async {
    final chatRoom = await _firestore.collection('chats').doc(chatRoomId).get();
    final senderId = chatRoom['lastMessageSender'];

    if (userId != senderId) {
      await _firestore.collection('chats').doc(chatRoomId).update({
        'unreadMessageCount': 0,
      });
    }
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await _firestore.collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'type': 'deleted',
    });

    final chatRoom = (await _firestore.collection('chats').doc(chatRoomId).get()).data();
    if (chatRoom?['lastMessageId'] == messageId) {
      _firestore.collection('chats').doc(chatRoomId).update({
        'lastMessageType': 'deleted',
      });
    }
  }
}
