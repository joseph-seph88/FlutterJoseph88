import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final String location;
  final String category;
  final List<String> images;
  final int viewCount;
  final int likeCount;
  final Timestamp createdAt;
  final String sellerId;
  final bool isOfferEnabled;
  final String status;
  final int chatCount;

  const ProductModel({
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

  factory ProductModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as int,
      location: data['location'] as String,
      category: data['category'] as String,
      images: List<String>.from(data['images']),
      viewCount: data['viewCount'] as int,
      likeCount: data['likeCount'] as int,
      createdAt: data['createdAt'] as Timestamp,
      sellerId: data['sellerId'] as String,
      isOfferEnabled: data['isOfferEnabled'] as bool,
      status: data['status'] as String,
      chatCount: data['chatCount'] as int,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'category': category,
      'images': images,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'createdAt': createdAt,
      'sellerId': sellerId,
      'isOfferEnabled': isOfferEnabled,
      'status': status,
      'chatCount': chatCount,
    };
  }
}
