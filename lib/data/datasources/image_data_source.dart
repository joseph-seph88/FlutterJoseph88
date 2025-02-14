import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadImage(String root, String id, String filePath) {
    final storagePath = '$root/$id/${DateTime.now().toIso8601String()}';
    final storageRef = _storage.ref().child(storagePath);

    return storageRef.putFile(File(filePath));
  }
}