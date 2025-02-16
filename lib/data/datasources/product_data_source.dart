import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o2/core/utils/search_utils.dart';
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
      // 1. 제목 기반 검색 (startsWith)
      final titleStartsWithSnapshot = await _firestore
          .collection(_collection)
          .where('titleLower', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('titleLower', isLessThan: '$lowercaseQuery\uf8ff')
          .orderBy('titleLower')
          .orderBy('createdAt', descending: true)
          .get();

      // 2. 키워드 기반 검색
      final keywordSnapshot = await _firestore
          .collection(_collection)
          .where('searchKeywords', arrayContains: lowercaseQuery)
          .orderBy('createdAt', descending: true)
          .get();

      // 결과 합치기 (중복 제거)
      final results =
          {...titleStartsWithSnapshot.docs, ...keywordSnapshot.docs}.toList();

      // 최신순 정렬
      results.sort((a, b) => (b.data()['createdAt'] as Timestamp)
          .compareTo(a.data()['createdAt'] as Timestamp));

      return results;
    } catch (e) {
      debugPrint('검색 오류: $e');
      // 인덱스 오류 등이 발생할 경우 부분 문자열 검색으로 폴백
      final snapshot = await _firestore.collection(_collection).get();
      final fallbackResults = snapshot.docs.where((doc) {
        final data = doc.data();
        final title = (data['title'] as String).toLowerCase();
        final keywords = List<String>.from(data['searchKeywords'] ?? []);
        return title.contains(lowercaseQuery) ||
            keywords.any((keyword) => keyword.contains(lowercaseQuery));
      }).toList();

      fallbackResults.sort((a, b) => (b.data()['createdAt'] as Timestamp)
          .compareTo(a.data()['createdAt'] as Timestamp));

      return fallbackResults;
    }
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
        final searchKeywords =
            SearchUtils.generateSearchKeywords(title, description);

        // Firestore 문서 업데이트
        await doc.reference.update({
          'searchKeywords': searchKeywords,
          'titleLower': title.toLowerCase(), // 소문자 제목 필드 추가
        });
      }
    } catch (e) {
      debugPrint('Error updating search keywords: $e');
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
    final recentSearches = List<Map<String, dynamic>>.from(
        userSnapshot.data()?['recentSearches'] ?? []);

    if (recentSearches.length > 10) {
      // 시간순으로 정렬
      recentSearches.sort((a, b) =>
          (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

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
    final recentSearches = List<Map<String, dynamic>>.from(
        userDoc.data()?['recentSearches'] ?? []);

    // 시간순으로 정렬
    recentSearches.sort((a, b) =>
        (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

    return recentSearches.map((search) => search['keyword'] as String).toList();
  }

  // 최근 검색어 삭제
  Future<void> removeRecentSearch(String userId, String keyword) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final userSnapshot = await userDoc.get();
    final recentSearches = List<Map<String, dynamic>>.from(
        userSnapshot.data()?['recentSearches'] ?? []);

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

  // 검색어 카운트 증가
  Future<void> incrementSearchCount(String keyword) async {
    final searchStatsRef = _firestore.collection('searchStats').doc('keywords');

    await searchStatsRef.set({
      keyword: FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  // 인기 검색어 가져오기
  Future<List<String>> getPopularSearches({int limit = 5}) async {
    final searchStatsRef = _firestore.collection('searchStats').doc('keywords');
    final snapshot = await searchStatsRef.get();

    if (!snapshot.exists) {
      return [];
    }

    final data = snapshot.data() as Map<String, dynamic>;
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

    return sortedEntries.take(limit).map((e) => e.key).toList();
  }

  // 관심 상품 추가
  Future<void> addToFavorites(String userId, String productId) async {
    final batch = _firestore.batch();

    // 사용자의 관심 상품 목록에 추가
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'favoriteProductIds': FieldValue.arrayUnion([productId])
    });

    // 상품의 favoriteCount 증가
    final productRef = _firestore.collection(_collection).doc(productId);
    batch.update(productRef, {'favoriteCount': FieldValue.increment(1)});

    await batch.commit();
  }

  // 관심 상품 제거
  Future<void> removeFromFavorites(String userId, String productId) async {
    final batch = _firestore.batch();

    // 사용자의 관심 상품 목록에서 제거
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'favoriteProductIds': FieldValue.arrayRemove([productId])
    });

    // 상품의 favoriteCount 감소
    final productRef = _firestore.collection(_collection).doc(productId);
    batch.update(productRef, {'favoriteCount': FieldValue.increment(-1)});

    await batch.commit();
  }

  // 관심 상품 목록 조회
  Future<List<DocumentSnapshot>> getFavoriteProducts(String userId) async {
    // 사용자의 관심 상품 ID 목록 가져오기
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final favoriteIds =
        List<String>.from(userDoc.data()?['favoriteProductIds'] ?? []);

    if (favoriteIds.isEmpty) {
      return [];
    }

    // 관심 상품 목록 조회
    final chunks = <List<String>>[];
    for (var i = 0; i < favoriteIds.length; i += 10) {
      final end = (i + 10 < favoriteIds.length) ? i + 10 : favoriteIds.length;
      chunks.add(favoriteIds.sublist(i, end));
    }

    final results = <DocumentSnapshot>[];
    for (final chunk in chunks) {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(querySnapshot.docs);
    }

    return results;
  }

  // 관심 상품 여부 확인
  Future<bool> isFavoriteProduct(String userId, String productId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final favoriteIds =
        List<String>.from(userDoc.data()?['favoriteProductIds'] ?? []);
    return favoriteIds.contains(productId);
  }

  Future<void> createProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toFirebase());
  }

  Future<void> updateStatus(String id, String status) async {
    await _firestore.collection(_collection).doc(id).update({
      'status': status,
    });
  }
}
