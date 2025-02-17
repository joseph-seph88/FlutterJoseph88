import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

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
  final _supportedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ];

  ImageDataSourceImpl(this._storage);

  Future<void> _validateImageFile(File file) async {
    final mimeType = lookupMimeType(file.path);

    if (mimeType == null || !_supportedMimeTypes.contains(mimeType)) {
      throw Exception('지원하지 않는 이미지 형식입니다. (지원 형식: JPG, PNG, WebP, HEIC)');
    }

    final fileSize = await file.length();
    if (fileSize > 10 * 1024 * 1024) {
      // 10MB
      throw Exception('이미지 크기는 10MB를 초과할 수 없습니다.');
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, File file) async {
    await _validateImageFile(file);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('profiles/$userId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<String> uploadProductImage(
      String sellerId, String productId, File file) async {
    await _validateImageFile(file);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('products/$sellerId/$productId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  @override
  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files) async {
    // 모든 파일 사전 검증
    await Future.wait(files.map(_validateImageFile));

    // 동시에 처리할 최대 이미지 수
    const int maxConcurrent = 3;
    final List<String> urls = [];

    // 이미지를 청크로 나누어 처리
    for (var i = 0; i < files.length; i += maxConcurrent) {
      final end =
          (i + maxConcurrent < files.length) ? i + maxConcurrent : files.length;
      final chunk = files.sublist(i, end);

      // 각 청크 내의 이미지를 병렬로 업로드
      final chunkResults = await Future.wait(
          chunk.map((file) => _uploadSingleImage(sellerId, productId, file)));

      urls.addAll(chunkResults);
    }

    return urls;
  }

  Future<String> _uploadSingleImage(
      String sellerId, String productId, File file) async {
    await _validateImageFile(file);

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('products/$sellerId/$productId/$fileName');

    final mimeType = lookupMimeType(file.path);
    final metadata = SettableMetadata(
      cacheControl: 'public, max-age=31536000',
      contentType: mimeType,
    );

    try {
      final uploadTask = ref.putFile(file, metadata);

      // 업로드 진행 상황 모니터링 (디버그용)
      if (kDebugMode) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          debugPrint('이미지 업로드 진행률: ${progress.toStringAsFixed(2)}%');
        });
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  @override
  Future<String> uploadChatImage(
      String chatRoomId, String senderId, File file) async {
    await _validateImageFile(file);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref =
        _storage.ref().child('chats/$chatRoomId/images/$senderId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  // 공통 업로드 로직
  Future<String> _uploadAndGetUrl(Reference ref, File file) async {
    final mimeType = lookupMimeType(file.path);
    final metadata = SettableMetadata(
      cacheControl: 'public, max-age=31536000',
      contentType: mimeType,
    );

    try {
      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }
}
