import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadDummyData() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  final productsRef = firestore.collection('products');
  final usersRef = firestore.collection('users');

  // 사용자 더미 데이터
  const String userId = 'L8IM3YPhZYeQO9oZQnWJeHGKL5u2';
  final dummyUser = {
    'id': userId,
    'email': 'test@naver.com',
    'name': 'jin',
    'favoriteProductIds': [],
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
  };

  // 사용자 데이터 추가
  batch.set(usersRef.doc(userId), dummyUser);

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
      'favoriteCount': 0,
      'createdAt': Timestamp.now(),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 2,
      'searchKeywords': ['아이폰', '15', '프로', '256gb', '실버', '애플', '중고폰'],
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
      'favoriteCount': 0,
      'createdAt':
          Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 4,
      'searchKeywords': ['자전거', '알톤', '로드바이크', '스포츠', '레저'],
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
      'favoriteCount': 0,
      'createdAt':
          Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
      'sellerId': userId,
      'isOfferEnabled': false,
      'status': 'active',
      'chatCount': 3,
      'searchKeywords': ['캣타워', '고양이', '반려동물', '무료나눔', '나눔'],
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
      'favoriteCount': 0,
      'createdAt':
          Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 1,
      'searchKeywords': ['에어팟', '프로', '2세대', '애플', '이어폰'],
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
      'favoriteCount': 0,
      'createdAt':
          Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 6,
      'searchKeywords': ['침대', '프레임', '퀸사이즈', '가구', '인테리어'],
    },
    {
      'title': '닌텐도 스위치 OLED + 젤다의 전설',
      'description': '닌텐도 스위치 OLED 모델과 젤다의 전설 티어스 오브 더 킹덤 게임팩입니다. 구성품 모두 있어요.',
      'price': 420000,
      'locationName': '인창동',
      'location': const GeoPoint(37.5642135, 127.0016985),
      'category': '디지털기기',
      'images': [
        'https://images.unsplash.com/photo-1578303512597-81e6cc155b3e?q=80&w=1000',
        'https://images.unsplash.com/photo-1617096200347-cb04ae810b1d?q=80&w=1000'
      ],
      'viewCount': 234,
      'likeCount': 15,
      'favoriteCount': 0,
      'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 12))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 8,
      'searchKeywords': ['닌텐도', '스위치', 'OLED', '젤다', '게임기', '게임'],
    },
    {
      'title': '캠핑 테이블 세트',
      'description': '1년 사용한 캠핑 테이블 세트입니다. 접이식이라 보관이 편하고 야외 활동에 최적화되어 있어요.',
      'price': 85000,
      'locationName': '방이동',
      'location': const GeoPoint(37.5132612, 127.1001336),
      'category': '스포츠/레저',
      'images': [
        'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?q=80&w=1000',
        'https://images.unsplash.com/photo-1475518845976-0fd87b7e4e5d?q=80&w=1000'
      ],
      'viewCount': 178,
      'likeCount': 9,
      'favoriteCount': 0,
      'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 15))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 5,
      'searchKeywords': ['캠핑', '테이블', '야외', '레저', '접이식'],
    },
    {
      'title': '맥북 프로 M2 16인치',
      'description':
          '맥북 프로 M2 16인치 스페이스 그레이입니다. 배터리 사이클 50회 미만이고 애케어플러스 적용 중입니다.',
      'price': 2800000,
      'locationName': '잠실동',
      'location': const GeoPoint(37.5132612, 127.1001336),
      'category': '디지털기기',
      'images': [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=1000',
        'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?q=80&w=1000'
      ],
      'viewCount': 312,
      'likeCount': 24,
      'favoriteCount': 0,
      'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 18))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 12,
      'searchKeywords': ['맥북', '프로', 'M2', '애플', '노트북'],
    },
    {
      'title': '무선 청소기 다이슨 V12',
      'description': '다이슨 V12 무선청소기입니다. 6개월 사용했고 필터 교체한지 1개월 됐어요. 구성품 모두 있습니다.',
      'price': 580000,
      'locationName': '서초동',
      'location': const GeoPoint(37.4923615, 127.0292881),
      'category': '디지털기기',
      'images': [
        'https://images.unsplash.com/photo-1558317374-067fb5f30001?q=80&w=1000',
        'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?q=80&w=1000'
      ],
      'viewCount': 245,
      'likeCount': 18,
      'favoriteCount': 0,
      'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 22))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 7,
      'searchKeywords': ['다이슨', '청소기', '무선청소기', 'V12', '가전제품'],
    },
    {
      'title': '골프 풀세트 초급자용',
      'description': '6개월 사용한 초급자용 골프 풀세트입니다. 캘러웨이 세트이고 가방도 포함입니다.',
      'price': 950000,
      'locationName': '대치동',
      'location': const GeoPoint(37.4923615, 127.0292881),
      'category': '스포츠/레저',
      'images': [
        'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?q=80&w=1000',
        'https://images.unsplash.com/photo-1496115965489-21be7e6e59a0?q=80&w=1000'
      ],
      'viewCount': 167,
      'likeCount': 11,
      'favoriteCount': 0,
      'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 25))),
      'sellerId': userId,
      'isOfferEnabled': true,
      'status': 'active',
      'chatCount': 4,
      'searchKeywords': ['골프', '골프클럽', '캘러웨이', '스포츠', '골프세트'],
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
