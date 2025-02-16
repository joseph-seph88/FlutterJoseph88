import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/repositories/image_repository.dart';

// 이미지 저장소 Provider
final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  throw UnimplementedError(); // DI 설정에서 실제 구현체를 주입해야 합니다.
});

// 프로필 이미지 업로드용
final uploadProfileImageProvider =
    Provider<Future<String> Function(File)>((ref) {
  return (File image) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadProfileImage(image);
  };
});

// 상품 이미지 업로드용
final uploadProductImagesProvider =
    Provider<Future<List<String>> Function(List<File>)>((ref) {
  return (List<File> images) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadProductImages(images);
  };
});

// 채팅 이미지 업로드용
final uploadChatImageProvider =
    Provider<Future<String> Function(String, File)>((ref) {
  return (String chatRoomId, File image) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadChatImage(chatRoomId, image);
  };
});
