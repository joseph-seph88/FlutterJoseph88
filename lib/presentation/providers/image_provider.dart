import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/domain/repositories/image_repository.dart';
import 'package:o2/presentation/providers/providers.dart' as providers;

// 이미지 저장소 Provider
final imageRepositoryProvider = Provider<ImageRepository>(
    (ref) => ref.watch(providers.imageRepositoryProvider));

// 프로필 이미지 업로드용
final uploadProfileImageProvider =
    Provider<Future<String> Function(String userId, File)>((ref) {
  return (String userId, File image) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadProfileImage(userId, image);
  };
});

// 상품 이미지 업로드용
final uploadProductImagesProvider = Provider<
    Future<List<String>> Function(
        String sellerId, String productId, List<File>)>((ref) {
  return (String sellerId, String productId, List<File> images) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadProductImages(sellerId, productId, images);
  };
});

// 채팅 이미지 업로드용
final uploadChatImageProvider =
    Provider<Future<String> Function(String chatRoomId, String senderId, File)>(
        (ref) {
  return (String chatRoomId, String senderId, File image) {
    final imageRepository = ref.read(imageRepositoryProvider);
    return imageRepository.uploadChatImage(chatRoomId, senderId, image);
  };
});
