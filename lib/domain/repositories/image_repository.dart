abstract interface class ImageRepository {
  Future<String> uploadImage(String id, String path);
}