import '../entities/review.dart';

abstract class ReviewRepository {
  Future<void> addStoreReview(String userId, String email, Map<String, dynamic> storeReview);

  Future<List<Review>> getReviewAboutStore(mapId);

  Future<bool> isDuplicateStoreReview(userId, mapId);
}
