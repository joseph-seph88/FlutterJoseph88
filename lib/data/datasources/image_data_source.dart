import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

class ImageDataSource {
  final FirebaseStorage _storage;
  final _supportedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
  ];

  ImageDataSource(this._storage);

  Future<void> _validateImageFile(File file) async {
    // URL인 경우 검증 스킵
    if (file.path.startsWith('http')) {
      return;
    }

    final mimeType = lookupMimeType(file.path);
    // 순수 확장자만 추출 (쿼리 파라미터 제거)
    final extension = path.extension(file.path).split('?')[0].toLowerCase();
    final validExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
      '.heic',
      '.heif'
    ];

    if (kDebugMode) {
      debugPrint('파일 경로: ${file.path}');
      debugPrint('MIME 타입: $mimeType');
      debugPrint('파일 확장자: $extension');
      debugPrint(
          '지원되는 MIME 타입 포함 여부: ${mimeType != null && _supportedMimeTypes.contains(mimeType)}');
      debugPrint('지원되는 확장자 포함 여부: ${validExtensions.contains(extension)}');
    }

    if ((mimeType == null || !_supportedMimeTypes.contains(mimeType)) &&
        !validExtensions.contains(extension)) {
      throw Exception('지원하지 않는 이미지 형식입니다. (지원 형식: JPG, PNG, WebP, HEIC)');
    }

    final fileSize = await file.length();
    if (fileSize > 10 * 1024 * 1024) {
      // 10MB
      throw Exception('이미지 크기는 10MB를 초과할 수 없습니다.');
    }
  }

  Future<String> uploadProfileImage(String userId, File file) async {
    await _validateImageFile(file);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('profiles/$userId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  Future<String> uploadProductImage(
      String sellerId, String productId, File file) async {
    await _validateImageFile(file);
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('products/$sellerId/$productId/$fileName');
    return _uploadAndGetUrl(ref, file);
  }

  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files) async {
    final List<String> urls = [];

    for (final file in files) {
      // URL인 경우 바로 추가
      if (file.path.startsWith('http')) {
        urls.add(file.path);
        continue;
      }

      // 파일 검증
      await _validateImageFile(file);
    }

    // 실제 파일만 필터링
    final localFiles =
        files.where((file) => !file.path.startsWith('http')).toList();

    if (localFiles.isEmpty) {
      return urls;
    }

    // 동시에 처리할 최대 이미지 수
    const int maxConcurrent = 3;

    // 이미지를 청크로 나누어 처리
    for (var i = 0; i < localFiles.length; i += maxConcurrent) {
      final end = (i + maxConcurrent < localFiles.length)
          ? i + maxConcurrent
          : localFiles.length;
      final chunk = localFiles.sublist(i, end);

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
