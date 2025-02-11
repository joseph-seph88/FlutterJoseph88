import 'package:o2/domain/repositories/review_repository.dart';

import '../entities/review.dart';

abstract class ReviewUseCase {
  Future<void> addStoreReview(
      String userId, String email, Map<String, dynamic> storeReview);

  Future<List<Review>> getReviewAboutStore(mapId);

  Future<bool> isDuplicateStoreReview(userId, mapId);
}

class ReviewUseCaseImpl implements ReviewUseCase {
  final ReviewRepository _repository;

  ReviewUseCaseImpl(this._repository);

  @override
  Future<void> addStoreReview(
      String userId, String email, Map<String, dynamic> storeReview) async {
    try {
      await _repository.addStoreReview(userId, email, storeReview);
    } catch (e) {
      throw Exception('[RE:USECASE_업체 리뷰 등록 에러]');
    }
  }

  @override
  Future<List<Review>> getReviewAboutStore(mapId) async {
    try {
      return await _repository.getReviewAboutStore(mapId);
    } catch (e) {
      throw Exception('[RE:USECASE_업체 리뷰 가져오기 에러]');
    }
  }

  @override
  Future<bool> isDuplicateStoreReview(userId, mapId) async {
    try {
      return await _repository.isDuplicateStoreReview(userId, mapId);
    } catch (e) {
      throw Exception('[RE:USECASE_업체 리뷰 중복 에러]');
    }
  }
}
