abstract interface class ImageRepository {
  Future<String> uploadImage(String root, String id, String path);
}