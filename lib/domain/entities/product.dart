class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String location;
  final String category;
  final List<String> images;
  final int viewCount;
  final int likeCount;
  final DateTime createdAt;
  final String sellerId;
  final bool isOfferEnabled;
  final String status;
  final int chatCount;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.category,
    required this.images,
    required this.viewCount,
    required this.likeCount,
    required this.createdAt,
    required this.sellerId,
    required this.isOfferEnabled,
    required this.status,
    required this.chatCount,
  });
}
