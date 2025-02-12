class ReviewModel {
  final String userId;
  final String email;
  final Map<String, dynamic>? storeReview; //   {mapId, comment}

  ReviewModel({
    required this.userId,
    required this.email,
    this.storeReview,
  });

  ReviewModel copyWith({
    String? userId,
    String? email,
    Map<String, dynamic>? storeReview,
  }) {
    return ReviewModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      storeReview: storeReview ?? this.storeReview,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'storeReview': storeReview,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> reviewData) {
    return ReviewModel(
      userId: reviewData['userId'],
      email: reviewData['email'],
      storeReview: reviewData['storeReview'],
    );
  }

  ReviewModel toEntity() {
    return ReviewModel(
      userId: userId,
      email: email,
      storeReview: storeReview,
    );
  }
}
