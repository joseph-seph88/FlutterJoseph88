import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/core/utils/search_utils.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final String locationName; // 주소명 (예: "인창동")
  final GeoPoint location; // 위도, 경도
  final String category;
  final List<String> images;
  final int viewCount;
  final int favoriteCount;
  final Timestamp createdAt;
  final String sellerId;
  final bool isOfferEnabled;
  final String status;
  final int chatCount;
  final List<String> searchKeywords;
  final String titleLower;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.locationName,
    required this.location,
    required this.category,
    required this.images,
    required this.viewCount,
    required this.favoriteCount,
    required this.createdAt,
    required this.sellerId,
    required this.isOfferEnabled,
    required this.status,
    required this.chatCount,
    List<String>? searchKeywords,
    String? titleLower,
  })  : searchKeywords = searchKeywords ??
            SearchUtils.generateSearchKeywords(title, description),
        titleLower = titleLower ?? title.toLowerCase();

  factory ProductModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as int,
      locationName: data['locationName'] as String,
      location: data['location'] as GeoPoint,
      category: data['category'] as String,
      images: List<String>.from(data['images']),
      viewCount: data['viewCount'] as int,
      favoriteCount: data['favoriteCount'] as int? ?? 0,
      createdAt: data['createdAt'] as Timestamp,
      sellerId: data['sellerId'] as String,
      isOfferEnabled: data['isOfferEnabled'] as bool,
      status: data['status'] as String,
      chatCount: data['chatCount'] as int,
      searchKeywords: List<String>.from(data['searchKeywords'] ?? []),
      titleLower: data['titleLower'] as String? ??
          data['title'].toString().toLowerCase(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'locationName': locationName,
      'location': location,
      'category': category,
      'images': images,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
      'createdAt': createdAt,
      'sellerId': sellerId,
      'isOfferEnabled': isOfferEnabled,
      'status': status,
      'chatCount': chatCount,
      'searchKeywords': searchKeywords,
      'titleLower': titleLower,
    };
  }
}
