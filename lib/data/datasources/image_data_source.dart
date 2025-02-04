import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract interface class ImageDataSource {
  UploadTask uploadImage(String chatRoomId, String path);
}

class ImageDataSourceImpl implements ImageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  UploadTask uploadImage(String id, String path) {
    final storagePath = '$id/${DateTime.now().toIso8601String()}';
    final storageRef = _storage.ref().child(storagePath);

    return storageRef.putFile(File(path));
  }
}