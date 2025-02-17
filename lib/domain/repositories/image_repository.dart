import 'dart:io';

abstract interface class ImageRepository {
  // 프로필 이미지 업로드
  Future<String> uploadProfileImage(String userId, File file);

  // 상품 이미지 업로드
  Future<String> uploadProductImage(
      String sellerId, String productId, File file);
  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files);

  // 채팅 이미지 업로드
  Future<String> uploadChatImage(String chatRoomId, String senderId, File file);
}
