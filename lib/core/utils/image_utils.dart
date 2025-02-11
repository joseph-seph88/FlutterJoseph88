import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  static const String compressedPrefix = 'compressed_';

  /// 임시 디렉토리의 압축된 이미지 파일들을 정리
  static Future<void> cleanupCompressedImages() async {
    try {
      final dir = await getTemporaryDirectory();
      final files = dir.listSync();

      for (var file in files) {
        if (file is File &&
            path.basename(file.path).startsWith(compressedPrefix)) {
          final fileName = path.basename(file.path);
          final timestamp = int.tryParse(
              fileName.substring(compressedPrefix.length, fileName.length - 4));

          if (timestamp != null) {
            final fileDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
            final now = DateTime.now();

            // 24시간 이상 된 파일 삭제
            if (now.difference(fileDate).inHours > 24) {
              await file.delete();
              debugPrint('오래된 압축 파일 삭제: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('압축 파일 정리 중 오류: $e');
    }
  }

  /// 이미지 압축 처리
  /// quality: 압축 품질 (0-100)
  /// minWidth: 최소 너비
  /// minHeight: 최소 높이
  static Future<File> compressImage(
    File file, {
    int quality = 85,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      debugPrint('압축 시작: ${file.path}');
      if (!file.existsSync()) {
        debugPrint('파일이 존재하지 않음: ${file.path}');
        throw Exception('파일이 존재하지 않습니다.');
      }

      // 파일 확장자 확인
      final extension = path.extension(file.path).toLowerCase();
      debugPrint('파일 확장자: $extension');
      if (!['.jpg', '.jpeg', '.png', '.heic', '.webp'].contains(extension)) {
        debugPrint('지원하지 않는 파일 형식: $extension');
        throw Exception('지원하지 않는 파일 형식입니다.');
      }

      // 원본 이미지 크기 확인
      final bytes = await file.readAsBytes();
      final originalSize = bytes.length;
      debugPrint('원본 크기: ${originalSize ~/ 1024}KB');

      // 이미지 크기에 따른 품질 조정
      int adjustedQuality = quality;
      if (originalSize > 5 * 1024 * 1024) {
        adjustedQuality = 70;
      } else if (originalSize > 2 * 1024 * 1024) {
        adjustedQuality = 75;
      } else if (originalSize > 1 * 1024 * 1024) {
        adjustedQuality = 80;
      }
      debugPrint('설정된 압축 품질: $adjustedQuality%');

      // 먼저 메모리에서 압축
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: adjustedQuality,
        minWidth: minWidth,
        minHeight: minHeight,
        rotate: 0,
      );

      if (compressedBytes.isEmpty) {
        debugPrint('압축 실패 - 압축된 데이터가 비어있음');
        return file;
      }

      // 압축된 데이터를 새 파일로 저장
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '$compressedPrefix${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(compressedBytes);

      final compressedSize = compressedBytes.length;
      debugPrint(
          '압축 후 크기: ${compressedSize ~/ 1024}KB (품질: $adjustedQuality%)');
      debugPrint(
          '압축률: ${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(2)}%');

      if (compressedSize >= originalSize) {
        debugPrint(
            '압축 결과가 원본보다 큼 (${compressedSize ~/ 1024}KB > ${originalSize ~/ 1024}KB)');
        await compressedFile.delete(); // 압축 실패 시 임시 파일 삭제
        return file;
      }

      // 24시간 이상 된 압축 파일들 정리
      await cleanupCompressedImages();

      return compressedFile;
    } catch (e, stackTrace) {
      debugPrint('이미지 압축 오류 발생');
      debugPrint('에러 메시지: $e');
      debugPrint('스택 트레이스: $stackTrace');
      return file;
    }
  }

  /// 여러 이미지 압축 처리
  static Future<List<File>> compressImages(
    List<File> files, {
    int quality = 85,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    final compressedFiles = <File>[];
    debugPrint('총 ${files.length}개의 이미지 압축 시작');

    for (var i = 0; i < files.length; i++) {
      try {
        debugPrint('${i + 1}번째 이미지 압축 시작');
        final compressedFile = await compressImage(
          files[i],
          quality: quality,
          minWidth: minWidth,
          minHeight: minHeight,
        );
        compressedFiles.add(compressedFile);
        debugPrint('${i + 1}번째 이미지 압축 완료');
      } catch (e, stackTrace) {
        debugPrint('${i + 1}번째 이미지 압축 실패');
        debugPrint('에러 메시지: $e');
        debugPrint('스택 트레이스: $stackTrace');
        compressedFiles.add(files[i]);
      }
    }

    debugPrint('전체 이미지 압축 완료 (${compressedFiles.length}개)');
    return compressedFiles;
  }
}
