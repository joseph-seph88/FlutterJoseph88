class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String location;
  final String category;
  final String imageUrl;
  final int viewCount;
  final int likeCount;
  final DateTime createdAt;
  final String sellerId;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.viewCount,
    required this.likeCount,
    required this.createdAt,
    required this.sellerId,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    String? location,
    String? category,
    String? imageUrl,
    int? viewCount,
    int? likeCount,
    DateTime? createdAt,
    String? sellerId,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      sellerId: sellerId ?? this.sellerId,
    );
  }
}
