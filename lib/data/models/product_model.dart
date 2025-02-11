import 'package:cloud_firestore/cloud_firestore.dart';

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
  }) : searchKeywords =
            searchKeywords ?? generateSearchKeywords(title, description);

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
    };
  }

  // 검색 키워드 생성 메서드
  static List<String> generateSearchKeywords(String title, String description) {
    final Set<String> keywords = {};

    // 제목과 설명을 소문자로 변환
    final lowercaseTitle = title.toLowerCase();
    final lowercaseDescription = description.toLowerCase();

    // 1. 제목에서 키워드 생성 (부분 문자열)
    for (int i = 0; i < lowercaseTitle.length; i++) {
      for (int j = i + 1; j <= lowercaseTitle.length; j++) {
        final substring = lowercaseTitle.substring(i, j);
        if (substring.length >= 2) {
          // 2글자 이상만 포함
          keywords.add(substring);
        }
      }
    }

    // 2. 제목을 공백으로 분리하여 각 단어를 키워드로 추가
    final titleWords = lowercaseTitle.split(' ');
    keywords.addAll(titleWords.where((word) => word.length >= 2));

    // 3. 설명에서 주요 단어 추출 (2글자 이상인 단어만)
    final descriptionWords =
        lowercaseDescription.split(' ').where((word) => word.length >= 2);
    keywords.addAll(descriptionWords);

    // 4. 카테고리 관련 키워드 추가 (예: "중고", "새제품" 등)
    final commonKeywords = [
      '중고',
      '새제품',
      '할인',
      '급처',
    ];
    keywords.addAll(commonKeywords);

    return keywords.toList();
  }
}
