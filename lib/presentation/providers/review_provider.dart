import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/repositories/review_repository_impl.dart';
import 'package:o2/domain/usecases/review_use_case.dart';
import '../../data/datasources/review_data_source.dart';
import '../state/review_state.dart';
import 'map_provider.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final reviewDataSourceProvider = Provider((ref) {
  final fireStore = ref.read(fireStoreProvider);
  return ReviewDataSource(fireStore);
});

final reviewRepositoryProvider = Provider((ref) {
  final reviewDataSource = ref.read(reviewDataSourceProvider);
  return ReviewRepositoryImpl(reviewDataSource);
});

final reviewUseCaseProvider = Provider((ref) {
  final reviewRepo = ref.read(reviewRepositoryProvider);
  return ReviewUseCaseImpl(reviewRepo);
});

final reviewProvider =
    StateNotifierProvider<ReviewNotifier, ReviewState>((ref) {
  final reviewUseCase = ref.read(reviewUseCaseProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return ReviewNotifier(reviewUseCase, firebaseAuth);
});

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewUseCase _reviewUseCase;
  final FirebaseAuth _auth;

  ReviewNotifier(this._reviewUseCase, this._auth)
      : super(ReviewState(
          isLoading: false,
          error: '',
          userId: '',
          email: '',
          asyncStoreReviewList: const AsyncValue.data([]),
        ));

  Future<void> addStoreReview(Map<String, dynamic> storeReview) async {
    state = state.copyWith(error: '');
    try {
      final userInfo = _auth.currentUser;
      if (userInfo != null) {
        final userId = userInfo.uid;
        final email = userInfo.email;
        await _reviewUseCase.addStoreReview(userId, email!, storeReview);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[RE:NOTIFIER_업체 리뷰 등록 에러]');
    }
  }

  Future<void> getReviewAboutStore(mapId) async {
    state = state.copyWith(
        error: '', asyncStoreReviewList: const AsyncValue.data([]));
    try {
      final reviewData = await _reviewUseCase.getReviewAboutStore(mapId);
      if (reviewData.isNotEmpty) {
        state =
            state.copyWith(asyncStoreReviewList: AsyncValue.data(reviewData));
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[RE:NOTIFIER_업체 리뷰 가져오기 에러]');
    }
  }

  Future<bool> isDuplicateStoreReview(mapId) async {
    state = state.copyWith(error: '');
    try {
      final userInfo = _auth.currentUser;
      if (userInfo != null) {
        final userId = userInfo.uid;
        final isUse =
            await _reviewUseCase.isDuplicateStoreReview(userId, mapId);
        return isUse;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[RE:NOTIFIER_업체 리뷰 중복 에러]');
    }
  }
}
