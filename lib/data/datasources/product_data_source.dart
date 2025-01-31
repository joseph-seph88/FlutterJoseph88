import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDataSource {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'products';

  // 상품 목록 조회
  Future<List<DocumentSnapshot>> getProducts() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs;
  }

  // 상품 상세 조회
  Future<DocumentSnapshot?> getProduct(String id) async {
    return await _firestore.collection(_collection).doc(id).get();
  }

  // 상품 검색
  Future<List<DocumentSnapshot>> searchProducts(String query) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('title', isGreaterThanOrEqualTo: query)
        .get();
    return snapshot.docs;
  }

  // 카테고리별 상품 조회
  Future<List<DocumentSnapshot>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs;
  }

  // 상품 조회수 증가
  Future<void> incrementViewCount(String id) async {
    await _firestore.collection(_collection).doc(id).update({
      'viewCount': FieldValue.increment(1),
    });
  }

  // 상품 좋아요 토글
  Future<void> toggleLike(String id, bool isLiked) async {
    await _firestore.collection(_collection).doc(id).update({
      'likeCount': FieldValue.increment(isLiked ? 1 : -1),
    });
  }
}