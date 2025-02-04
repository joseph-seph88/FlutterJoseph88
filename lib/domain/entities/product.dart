import 'package:o2/data/models/product_model.dart';

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
    required this.locationName,
    required this.latitude,
    required this.longitude,
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

  factory Product.fromModel(ProductModel model) {
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
      likeCount: model.likeCount,
      createdAt: model.createdAt.toDate(),
      sellerId: model.sellerId,
      isOfferEnabled: model.isOfferEnabled,
      status: model.status,
      chatCount: model.chatCount,
    );
  }
}
