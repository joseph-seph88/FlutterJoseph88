import 'dart:io';

abstract interface class ImageRepository {
  // 프로필 이미지 업로드
  Future<String> uploadProfileImage(File file);

  // 상품 이미지 업로드
  Future<String> uploadProductImage(File file);
  Future<List<String>> uploadProductImages(List<File> files);

  // 채팅 이미지 업로드
  Future<String> uploadChatImage(String chatRoomId, File file);
}
