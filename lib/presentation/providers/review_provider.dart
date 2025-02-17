import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/data/repositories/review_repository_impl.dart';
import 'package:o2/domain/usecases/review_use_case.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import '../../data/datasources/review_data_source.dart';
import '../../domain/entities/user_entity.dart';
import '../state/review_state.dart';
import 'map_provider.dart';

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
  final authState = ref.read(authProvider);
  return ReviewNotifier(reviewUseCase, authState);
});

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewUseCase _reviewUseCase;
  final UserEntity? _authState;

  ReviewNotifier(this._reviewUseCase, this._authState)
      : super(ReviewState(
          isLoading: false,
          error: '',
          userId: '',
          email: '',
          asyncStoreReviewList: const AsyncValue.data([]),
        ));

  Future<void> addStoreReview(
      Map<String, dynamic> storeReview) async {
    state = state.copyWith(error: '');
    try {
      if(_authState == null) {return;}
      final userId = _authState!.id;
      final userEmail = _authState!.email;
      await _reviewUseCase.addStoreReview(userId, userEmail, storeReview);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[RE:NOTIFIER_업체 리뷰 등록 에러] ${e.toString()}');
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
      throw Exception('[RE:NOTIFIER_업체 리뷰 가져오기 에러] ${e.toString()}');
    }
  }

  Future<bool> isDuplicateStoreReview(String? mapId) async {
    state = state.copyWith(error: '');
    try {
      if(_authState == null) {return false;}
      final userId = _authState!.id;
      if (mapId == null) {return false;}
      final isUse = await _reviewUseCase.isDuplicateStoreReview(userId, mapId);
      return isUse;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      throw Exception('[RE:NOTIFIER_업체 리뷰 중복 에러] ${e.toString()}');
    }
  }
}
