import 'package:flutter/material.dart';

class FavoriteStorePage extends StatelessWidget {
  const FavoriteStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 찜한 식당 더미 데이터
    final List<Map<String, dynamic>> favorites = [
      {
        'id': 1,
        'name': '황금 돈까스',
        'image': 'assets/images/tonkatsu.jpg',
        'rating': 4.8,
        'reviewCount': 452,
        'category': '일식',
        'distance': '0.8km',
        'deliveryTime': '25-35분',
        'deliveryFee': '3,000원',
        'isNew': false,
        'isCoupon': true,
        'signature': ['왕돈까스', '치즈돈까스', '김치나베'],
      },
      {
        'id': 2,
        'name': '맛있는 떡볶이',
        'image': 'assets/images/tteokbokki.jpg',
        'rating': 4.7,
        'reviewCount': 328,
        'category': '분식',
        'distance': '1.2km',
        'deliveryTime': '15-25분',
        'deliveryFee': '무료',
        'isNew': false,
        'isCoupon': false,
        'signature': ['로제떡볶이', '치즈떡볶이', '모듬튀김'],
      },
      {
        'id': 3,
        'name': '신선한 초밥',
        'image': 'assets/images/sushi.jpg',
        'rating': 4.9,
        'reviewCount': 687,
        'category': '일식',
        'distance': '1.5km',
        'deliveryTime': '35-50분',
        'deliveryFee': '2,500원',
        'isNew': false,
        'isCoupon': true,
        'signature': ['모듬초밥', '연어초밥', '특선초밥'],
      },
      {
        'id': 4,
        'name': '화덕 피자',
        'image': 'assets/images/pizza.jpg',
        'rating': 4.6,
        'reviewCount': 231,
        'category': '양식',
        'distance': '2.3km',
        'deliveryTime': '30-45분',
        'deliveryFee': '무료',
        'isNew': true,
        'isCoupon': true,
        'signature': ['마르게리타', '페퍼로니', '콰트로치즈'],
      },
      {
        'id': 5,
        'name': '엄마의 손맛 한식',
        'image': 'assets/images/korean.jpg',
        'rating': 4.7,
        'reviewCount': 519,
        'category': '한식',
        'distance': '0.5km',
        'deliveryTime': '20-30분',
        'deliveryFee': '3,500원',
        'isNew': false,
        'isCoupon': false,
        'signature': ['된장찌개', '김치찌개', '순두부찌개', '비빔밥'],
      },
      {
        'id': 6,
        'name': '24시 족발',
        'image': 'assets/images/jokbal.jpg',
        'rating': 4.5,
        'reviewCount': 182,
        'category': '한식',
        'distance': '3.0km',
        'deliveryTime': '40-55분',
        'deliveryFee': '2,000원',
        'isNew': false,
        'isCoupon': true,
        'signature': ['족발', '보쌈', '막국수'],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '나의 찜 목록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () {
              // 검색 기능
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 26),
            onPressed: () {
              // 필터 기능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 상단 필터 카테고리
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _buildCategoryPill('전체', true),
                  _buildCategoryPill('한식', false),
                  _buildCategoryPill('중식', false),
                  _buildCategoryPill('일식', false),
                  _buildCategoryPill('양식', false),
                  _buildCategoryPill('분식', false),
                  _buildCategoryPill('카페', false),
                  _buildCategoryPill('디저트', false),
                ],
              ),
            ),
          ),

          // 찜 목록 정렬 및 수 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 ${favorites.length}개',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '인기순',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ],
            ),
          ),

          // 찜 목록
          Expanded(
            child: favorites.isEmpty
                ? _buildEmptyFavorites()
                : ListView.builder(
                    itemCount: favorites.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final restaurant = favorites[index];
                      return _buildFavoriteCard(context, restaurant);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          // 필터 선택 기능
        },
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.deepOrange,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget _buildFavoriteCard(
      BuildContext context, Map<String, dynamic> restaurant) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 식당 이미지
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  restaurant['image'],
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160,
                      color: Colors.grey[300],
                      child: const Icon(Icons.restaurant,
                          color: Colors.grey, size: 50),
                    );
                  },
                ),
              ),

              // 찜 버튼
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.deepOrange),
                    onPressed: () {
                      // 찜 취소 기능
                    },
                    iconSize: 24,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // 새로운 식당 또는 쿠폰 표시
              if (restaurant['isNew'] || restaurant['isCoupon'])
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      if (restaurant['isNew'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (restaurant['isNew'] && restaurant['isCoupon'])
                        const SizedBox(width: 6),
                      if (restaurant['isCoupon'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '쿠폰',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          // 식당 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 식당 이름 및 평점
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '(${restaurant['reviewCount']})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 카테고리, 거리, 배달시간, 배달비
                Row(
                  children: [
                    _buildInfoPill(restaurant['category']),
                    _buildInfoDot(),
                    _buildInfoPill(restaurant['distance']),
                    _buildInfoDot(),
                    _buildInfoPill(restaurant['deliveryTime']),
                    _buildInfoDot(),
                    _buildInfoPill('배달팁 ${restaurant['deliveryFee']}'),
                  ],
                ),

                const SizedBox(height: 12),

                // 대표 메뉴
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      (restaurant['signature'] as List).map<Widget>((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.deepOrange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // 주문하기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 주문하기 기능
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '주문하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 13,
      ),
    );
  }

  Widget _buildInfoDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '•',
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '찜한 가게가 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '마음에 드는 음식점을 찜해보세요!',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 메인 화면으로 이동
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('음식점 둘러보기'),
          ),
        ],
      ),
    );
  }
}
