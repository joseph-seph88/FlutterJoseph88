import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

abstract interface class ImageDataSource {
  Future<String> uploadProfileImage(File file);
  Future<String> uploadProductImage(File file);
  Future<List<String>> uploadProductImages(List<File> files);
  Future<String> uploadChatImage(String chatRoomId, File file);
}

class ImageDataSourceImpl implements ImageDataSource {
  final FirebaseStorage _storage;

  ImageDataSourceImpl(this._storage);

  @override
  Future<String> uploadProfileImage(File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('profiles/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<String> uploadProductImage(File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('products/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<List<String>> uploadProductImages(List<File> files) async {
    final futures = files.map((file) => uploadProductImage(file));
    return await Future.wait(futures);
  }

  @override
  Future<String> uploadChatImage(String chatRoomId, File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('chats/$chatRoomId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  // 공통 업로드 로직
  Future<String> _uploadAndGetUrl(Reference ref, File file) async {
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
