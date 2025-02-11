import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/data/models/review_model.dart';

class ReviewDataSource {
  final FirebaseFirestore _fireStore;

  ReviewDataSource(this._fireStore);

  Future<void> addStoreReview(ReviewModel reviewData) async {
    try {
      await _fireStore
          .collection('reviews')
          .add(reviewData.toMap());
    } catch (e) {
      throw Exception('[RE:DS_업체 리뷰 등록 에러]');
    }
  }

  Future<List<ReviewModel>> getReviewAboutStore(mapId) async {
    try {
      final reviewSnapshot = await _fireStore
          .collection('reviews')
          .where('storeReview.mapId', isEqualTo: mapId)
          .get();

      return reviewSnapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('[RE:DS_업체 리뷰 가져오기 에러]');
    }
  }

  Future<bool> isDuplicateStoreReview(userId, mapId) async {
    try {
      final reviewSnapshot = await _fireStore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .where('storeReview.mapId', isEqualTo: mapId)
          .get();

      final isUse = reviewSnapshot.docs.isEmpty;
      return isUse;
    } catch (e) {
      throw Exception('[RE:DS_업체 리뷰 중복 에러]');
    }
  }
}
