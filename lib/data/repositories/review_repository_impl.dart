import 'package:o2/data/datasources/review_data_source.dart';
import 'package:o2/data/models/review_model.dart';
import 'package:o2/domain/repositories/review_repository.dart';
import '../../domain/entities/review.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDataSource _dataSource;

  ReviewRepositoryImpl(this._dataSource);

  @override
  Future<void> addStoreReview(
      String userId, String email, Map<String, dynamic> storeReview) async {
    try {
      final reviewData =
          ReviewModel(userId: userId, email: email, storeReview: storeReview);
      await _dataSource.addStoreReview(reviewData);
    } catch (e) {
      throw Exception('[RE:REPO_업체 리뷰 등록 에러]');
    }
  }

  @override
  Future<List<Review>> getReviewAboutStore(mapId) async {
    try {
      final reviewData = await _dataSource.getReviewAboutStore(mapId);
      return reviewData.map((model) {
        return Review(
            userId: model.userId,
            email: model.email,
            storeReview: model.storeReview);
      }).toList();
    } catch (e) {
      throw Exception('[RE:REPO_업체 리뷰 가져오기 에러]');
    }
  }

  @override
  Future<bool> isDuplicateStoreReview(userId, mapId) async {
    try {
      final isUse = await _dataSource.isDuplicateStoreReview(userId, mapId);
      return isUse;
    } catch (e) {
      throw Exception('[RE:REPO_업체 리뷰 중복 에러]');
    }
  }
}
