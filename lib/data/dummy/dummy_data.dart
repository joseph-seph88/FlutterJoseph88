import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadDummyData() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  final productsRef = firestore.collection('products');

  // 더미 데이터 정의
  final dummyProducts = [
    {
      'title': '아이폰 15 프로 256GB 실버',
      'description': '구매한지 2개월 된 아이폰 15 프로입니다. 항상 케이스 착용했고 기스 없이 깨끗합니다.',
      'price': 1350000,
      'locationName': '인창동',
      'location': const GeoPoint(37.5642135, 127.0016985), // 서울숲
      'category': '디지털기기',
      'images': [
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=1000',
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?q=80&w=1000'
      ],
      'viewCount': 45,
      'likeCount': 3,
      'createdAt': Timestamp.now(),
      'sellerId': 'user123',
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 2,
    },
    {
      'title': '자전거 팝니다',
      'description': '알톤 로드바이크 2년 탔습니다. 상태 양호하고 정비 잘되어있어요.',
      'price': 250000,
      'locationName': '성수동',
      'location': const GeoPoint(37.5445996, 127.0557268), // 성수동
      'category': '스포츠/레저',
      'images': [
        'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?q=80&w=1000',
        'https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?q=80&w=1000'
      ],
      'viewCount': 128,
      'likeCount': 8,
      'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
      'sellerId': 'user456',
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 4,
    },
    {
      'title': '캣타워 무료나눔',
      'description': '이사가게 되어서 캣타워 나눔합니다. 3단 캣타워고 사용감 있지만 튼튼해요.',
      'price': 0,
      'locationName': '송파동',
      'location': const GeoPoint(37.5145937, 127.1059684), // 송파
      'category': '반려동물용품',
      'images': [
        'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?q=80&w=1000',
      ],
      'viewCount': 67,
      'likeCount': 5,
      'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      'sellerId': 'user789',
      'isOfferEnabled': false,
      'status': 'active',
      'chatCount': 3,
    },
    {
      'title': '에어팟 프로 2세대',
      'description': '한 달 사용한 에어팟 프로 2세대입니다. 박스 있고 영수증도 있어요.',
      'price': 280000,
      'locationName': '잠실동',
      'location': const GeoPoint(37.5132612, 127.1001336), // 잠실
      'category': '디지털기기',
      'images': [
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?q=80&w=1000',
        'https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?q=80&w=1000'
      ],
      'viewCount': 89,
      'likeCount': 6,
      'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5))),
      'sellerId': 'user101',
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 1,
    },
    {
      'title': '퀸 사이즈 침대 프레임',
      'description': '2년 사용한 퀸사이즈 침대 프레임입니다. 매트리스 제외, 프레임만 판매합니다.',
      'price': 150000,
      'locationName': '역삼동',
      'location': const GeoPoint(37.5006636, 127.0363749), // 역삼
      'category': '가구/인테리어',
      'images': [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1000',
        'https://images.unsplash.com/photo-1505693314120-0d443867891c?q=80&w=1000'
      ],
      'viewCount': 156,
      'likeCount': 12,
      'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8))),
      'sellerId': 'user202',
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 6,
    },
  ];

  // 기존 데이터 삭제
  final existingDocs = await productsRef.get();
  for (var doc in existingDocs.docs) {
    batch.delete(doc.reference);
  }

  // 새 데이터 추가
  for (var product in dummyProducts) {
    final docRef = productsRef.doc();
    batch.set(docRef, product);
  }

  // 배치 커밋
  await batch.commit();
}
