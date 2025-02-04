import 'package:o2/data/datasources/image_data_source.dart';
import 'package:o2/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource _dataSource;

  ImageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadImage(String id, String path) async {
    final snapshot = await _dataSource.uploadImage(id, path);

    return snapshot.ref.getDownloadURL();
  }
}