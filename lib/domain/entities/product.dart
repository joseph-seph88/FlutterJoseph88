import 'package:o2/data/models/product_model.dart';

enum ProductStatus {
  active('active', '판매중'),
  reserved('reserved', '예약중'),
  completed('completed', '거래완료');

  final String code;
  final String label;
  const ProductStatus(this.code, this.label);

  factory ProductStatus.fromCode(String code) {
    return ProductStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => ProductStatus.active,
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final String locationName; // 주소명
  final double latitude; // 위도
  final double longitude; // 경도
  final String category;
  final List<String> images;
  final int viewCount;
  final int favoriteCount;
  final DateTime createdAt;
  final String sellerId;
  final bool isOfferEnabled;
  final ProductStatus status;
  final int chatCount;
  final bool isLiked; // 현재 사용자의 관심 상품 여부
  final List<String> searchKeywords;
  final String titleLower;
  final Map<String, DateTime>? favorites; // 추가: favorites 데이터

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.images,
    required this.viewCount,
    required this.favoriteCount,
    required this.createdAt,
    required this.sellerId,
    required this.isOfferEnabled,
    required this.status,
    required this.chatCount,
    this.isLiked = false,
    required this.searchKeywords,
    required this.titleLower,
    this.favorites,
  });

  factory Product.fromModel(ProductModel model, {bool isLiked = false}) {
    return Product(
      id: model.id,
      title: model.title,
      description: model.description,
      price: model.price,
      locationName: model.locationName,
      latitude: model.location.latitude,
      longitude: model.location.longitude,
      category: model.category,
      images: model.images,
      viewCount: model.viewCount,
      favoriteCount: model.favoriteCount,
      createdAt: model.createdAt.toDate(),
      sellerId: model.sellerId,
      isOfferEnabled: model.isOfferEnabled,
      status: ProductStatus.fromCode(model.status),
      chatCount: model.chatCount,
      isLiked: isLiked,
      searchKeywords: model.searchKeywords,
      titleLower: model.titleLower,
      favorites: model.favorites?.map(
        (key, value) => MapEntry(key, value.toDate()),
      ),
    );
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    String? locationName,
    double? latitude,
    double? longitude,
    String? category,
    List<String>? images,
    int? viewCount,
    int? favoriteCount,
    DateTime? createdAt,
    String? sellerId,
    bool? isOfferEnabled,
    ProductStatus? status,
    int? chatCount,
    bool? isLiked,
    List<String>? searchKeywords,
    String? titleLower,
    Map<String, DateTime>? favorites,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      images: images ?? this.images,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      createdAt: createdAt ?? this.createdAt,
      sellerId: sellerId ?? this.sellerId,
      isOfferEnabled: isOfferEnabled ?? this.isOfferEnabled,
      status: status ?? this.status,
      chatCount: chatCount ?? this.chatCount,
      isLiked: isLiked ?? this.isLiked,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      titleLower: titleLower ?? this.titleLower,
      favorites: favorites ?? this.favorites,
    );
  }
}
