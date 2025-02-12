import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/review.dart';

class ReviewState {
  final bool isLoading;
  final String error;
  final String userId;
  final String email;
  final AsyncValue<List<Review>> asyncStoreReviewList;

  ReviewState({
    required this.isLoading,
    required this.error,
    required this.userId,
    required this.email,
    required this.asyncStoreReviewList,
  });

  ReviewState copyWith({
    bool? isLoading,
    String? error,
    String? userId,
    String? email,
    AsyncValue<List<Review>>? asyncStoreReviewList,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      asyncStoreReviewList: asyncStoreReviewList ?? this.asyncStoreReviewList,
    );
  }
}
