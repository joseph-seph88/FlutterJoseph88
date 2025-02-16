import 'dart:io';
import 'package:o2/data/datasources/image_data_source.dart';
import 'package:o2/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource _dataSource;

  ImageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadProfileImage(File file) async {
    return await _dataSource.uploadProfileImage(file);
  }

  @override
  Future<String> uploadProductImage(File file) async {
    return await _dataSource.uploadProductImage(file);
  }

  @override
  Future<List<String>> uploadProductImages(List<File> files) async {
    return await _dataSource.uploadProductImages(files);
  }

  @override
  Future<String> uploadChatImage(String chatRoomId, File file) async {
    return await _dataSource.uploadChatImage(chatRoomId, file);
  }
}
