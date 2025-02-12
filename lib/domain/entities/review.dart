class Review {
  final String userId;
  final String email;
  final Map<String, dynamic>? storeReview; //   {mapId, comment}

  Review({
    required this.userId,
    required this.email,
    this.storeReview,
  });
}
