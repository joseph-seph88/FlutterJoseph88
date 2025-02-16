import 'dart:io';
import 'package:o2/data/datasources/image_data_source.dart';
import 'package:o2/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource _dataSource;

  ImageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadProfileImage(String userId, File file) async {
    return await _dataSource.uploadProfileImage(userId, file);
  }

  @override
  Future<String> uploadProductImage(
      String sellerId, String productId, File file) async {
    return await _dataSource.uploadProductImage(sellerId, productId, file);
  }

  @override
  Future<List<String>> uploadProductImages(
      String sellerId, String productId, List<File> files) async {
    return await _dataSource.uploadProductImages(sellerId, productId, files);
  }

  @override
  Future<String> uploadChatImage(
      String chatRoomId, String senderId, File file) async {
    return await _dataSource.uploadChatImage(chatRoomId, senderId, file);
  }
}
