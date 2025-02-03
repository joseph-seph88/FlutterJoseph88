import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2/data/models/product_model.dart';

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
    // 검색어를 소문자로 변환
    final lowercaseQuery = query.toLowerCase();

    try {
      // 1. searchKeywords 배열에 검색어가 포함된 상품을 찾음
      final snapshot = await _firestore
          .collection(_collection)
          .where('searchKeywords', arrayContains: lowercaseQuery)
          .orderBy('createdAt', descending: true) // 최신순 정렬
          .get();

      return snapshot.docs;
    } catch (e) {
      // Firestore 인덱스 오류 등이 발생할 경우 기본 검색으로 폴백
      final fallbackSnapshot = await _firestore
          .collection(_collection)
          .where('title', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('title', isLessThan: lowercaseQuery + '\uf8ff')
          .get();

      return fallbackSnapshot.docs;
    }
  }

  // 카테고리별 상품 조회
  Future<List<DocumentSnapshot>> getProductsByCategory(String category) async {
    final snapshot = await _firestore.collection(_collection).where('category', isEqualTo: category).get();
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

  // 모든 상품의 검색 키워드 업데이트
  Future<void> updateAllProductsSearchKeywords() async {
    try {
      // 1. 모든 상품 데이터 가져오기
      final snapshot = await _firestore.collection(_collection).get();

      // 2. 각 상품의 searchKeywords 필드 업데이트
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title'] as String;
        final description = data['description'] as String;

        // 검색 키워드 생성
        final searchKeywords = ProductModel.generateSearchKeywords(title, description);

        // Firestore 문서 업데이트
        await doc.reference.update({
          'searchKeywords': searchKeywords,
        });
      }
    } catch (e) {
      print('Error updating search keywords: $e');
      rethrow;
    }
  }

  // 최근 검색어 저장
  Future<void> saveRecentSearch(String userId, String keyword) async {
    final userDoc = _firestore.collection('users').doc(userId);

    await userDoc.set({
      'recentSearches': FieldValue.arrayUnion([
        {
          'keyword': keyword,
          'timestamp': Timestamp.now(),
        }
      ]),
    }, SetOptions(merge: true));

    // 최근 검색어가 10개를 초과하면 가장 오래된 검색어 삭제
    final userSnapshot = await userDoc.get();
    final recentSearches = List<Map<String, dynamic>>.from(userSnapshot.data()?['recentSearches'] ?? []);

    if (recentSearches.length > 10) {
      // 시간순으로 정렬
      recentSearches.sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

      // 10개만 남기고 나머지 삭제
      final keepSearches = recentSearches.take(10).toList();
      await userDoc.update({
        'recentSearches': keepSearches,
      });
    }
  }

  // 최근 검색어 목록 조회
  Future<List<String>> getRecentSearches(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final recentSearches = List<Map<String, dynamic>>.from(userDoc.data()?['recentSearches'] ?? []);

    // 시간순으로 정렬
    recentSearches.sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

    return recentSearches.map((search) => search['keyword'] as String).toList();
  }

  // 최근 검색어 삭제
  Future<void> removeRecentSearch(String userId, String keyword) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    final recentSearches = List<Map<String, dynamic>>.from(userSnapshot.data()?['recentSearches'] ?? []);

    // 해당 키워드를 가진 검색어 삭제
    recentSearches.removeWhere((search) => search['keyword'] == keyword);

    await userDoc.update({
      'recentSearches': recentSearches,
    });
  }

  // 최근 검색어 전체 삭제
  Future<void> clearRecentSearches(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'recentSearches': [],
    });
  }
}
