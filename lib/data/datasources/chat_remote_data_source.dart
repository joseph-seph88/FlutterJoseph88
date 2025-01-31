import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ChatRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomList(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatRoomList(String userId) {
    return _firestore
        .collection('chats')
        .where(Filter.or(
          Filter('buyer', isEqualTo: userId),
          Filter('seller', isEqualTo: userId),
        ))
        .orderBy('lastMessageTime')
        .snapshots();
  }
}
