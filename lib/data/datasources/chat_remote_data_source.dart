import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ChatRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRooms(String userId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      String chatRoomId);
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
        .orderBy('lastMessageTime')
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
}
