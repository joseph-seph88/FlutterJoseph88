import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

abstract interface class ImageDataSource {
  Future<String> uploadProfileImage(String userId, File file);
  Future<String> uploadProductImage(
      String sellerId, String productId, File file);
  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files);
  Future<String> uploadChatImage(String chatRoomId, String senderId, File file);
}

class ImageDataSourceImpl implements ImageDataSource {
  final FirebaseStorage _storage;

  ImageDataSourceImpl(this._storage);

  @override
  Future<String> uploadProfileImage(String userId, File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('profiles/$userId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<String> uploadProductImage(
      String sellerId, String productId, File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('products/$sellerId/$productId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files) async {
    final futures =
        files.map((file) => uploadProductImage(sellerId, productId, file));
    return await Future.wait(futures);
  }

  @override
  Future<String> uploadChatImage(
      String chatRoomId, String senderId, File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref =
        _storage.ref().child('chats/$chatRoomId/images/$senderId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  // 공통 업로드 로직
  Future<String> _uploadAndGetUrl(Reference ref, File file) async {
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
