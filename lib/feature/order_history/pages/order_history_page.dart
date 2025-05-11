import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터 - 주문 내역
    final List<Map<String, dynamic>> orders = [
      {
        'id': 'ORD-2023785',
        'restaurantName': '맛있는 치킨',
        'restaurantImage': 'assets/images/chicken.jpg',
        'date': '2025년 5월 6일',
        'time': '18:30',
        'totalAmount': 28000,
        'items': [
          {'name': '양념치킨', 'quantity': 1, 'price': 20000},
          {'name': '콜라', 'quantity': 1, 'price': 2000},
          {'name': '치즈볼', 'quantity': 1, 'price': 6000},
        ],
        'status': '배달완료',
        'rating': 5.0,
        'paymentMethod': '신용카드',
        'address': '서울시 강남구 테헤란로 123, 4층',
      },
      {
        'id': 'ORD-2023677',
        'restaurantName': '대박 피자',
        'restaurantImage': 'assets/images/pizza.jpg',
        'date': '2025년 5월 3일',
        'time': '19:45',
        'totalAmount': 32000,
        'items': [
          {'name': '페퍼로니 피자', 'quantity': 1, 'price': 24000},
          {'name': '치즈스틱', 'quantity': 1, 'price': 6000},
          {'name': '콜라', 'quantity': 1, 'price': 2000},
        ],
        'status': '배달완료',
        'rating': 4.5,
        'paymentMethod': '카카오페이',
        'address': '서울시 강남구 테헤란로 123, 4층',
      },
      {
        'id': 'ORD-2023556',
        'restaurantName': '엄마의 분식',
        'restaurantImage': 'assets/images/tteokbokki.jpg',
        'date': '2025년 5월 1일',
        'time': '12:15',
        'totalAmount': 18500,
        'items': [
          {'name': '떡볶이', 'quantity': 1, 'price': 8000},
          {'name': '튀김', 'quantity': 1, 'price': 6000},
          {'name': '순대', 'quantity': 1, 'price': 4500},
        ],
        'status': '배달완료',
        'rating': 5.0,
        'paymentMethod': '현금',
        'address': '서울시 강남구 테헤란로 123, 4층',
      },
      {
        'id': 'ORD-2023489',
        'restaurantName': '신선한 초밥',
        'restaurantImage': 'assets/images/sushi.jpg',
        'date': '2025년 4월 28일',
        'time': '20:00',
        'totalAmount': 35000,
        'items': [
          {'name': '모듬초밥', 'quantity': 1, 'price': 25000},
          {'name': '우동', 'quantity': 1, 'price': 8000},
          {'name': '녹차', 'quantity': 1, 'price': 2000},
        ],
        'status': '배달완료',
        'rating': 4.0,
        'paymentMethod': '네이버페이',
        'address': '서울시 강남구 테헤란로 123, 4층',
      },
      {
        'id': 'ORD-2023312',
        'restaurantName': '24시 족발',
        'restaurantImage': 'assets/images/jokbal.jpg',
        'date': '2025년 4월 23일',
        'time': '21:30',
        'totalAmount': 42000,
        'items': [
          {'name': '족발 중', 'quantity': 1, 'price': 35000},
          {'name': '막국수', 'quantity': 1, 'price': 7000},
        ],
        'status': '배달완료',
        'rating': 4.5,
        'paymentMethod': '네이버페이',
        'address': '서울시 강남구 테헤란로 123, 4층',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '주문 내역',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 검색 기능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 섹션
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip(
                  label: '전체',
                  isSelected: true,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '이번 달',
                  isSelected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '지난 달',
                  isSelected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: '3개월',
                  isSelected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 주문 내역 리스트
          Expanded(
            child: orders.isEmpty
                ? _buildEmptyOrderList()
                : ListView.builder(
                    itemCount: orders.length,
                    padding: const EdgeInsets.only(top: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _buildOrderCard(context, order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      {required String label,
      required bool isSelected,
      required Function(bool) onSelected}) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.deepOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 헤더 (레스토랑 정보)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 레스토랑 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order['restaurantImage'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // 레스토랑 이름 및 주문 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order['restaurantName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            order['status'],
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order['date']} ${order['time']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '주문번호: ${order['id']}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 구분선
          Divider(color: Colors.grey[200], height: 1),

          // 주문 상품 목록
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order['items'].length,
            itemBuilder: (context, index) {
              final item = order['items'][index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['name']} x${item['quantity']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${item['price']}원',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 구분선
          Divider(color: Colors.grey[200], height: 1),

          // 결제 정보 및 액션 버튼
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 총 금액 및 결제 방법
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총 결제금액',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${order['totalAmount']}원',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '결제수단',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      order['paymentMethod'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 액션 버튼
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // 주문 상세보기
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.deepOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '주문 상세보기',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 재주문하기
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('재주문하기'),
                      ),
                    ),
                  ],
                ),

                // 리뷰 작성 여부에 따라 표시
                if (order['rating'] > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '리뷰 작성 완료 (${order['rating']}점)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // 리뷰 작성
                    },
                    child: const Text(
                      '리뷰 작성하기',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrderList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '주문 내역이 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '맛있는 음식을 주문해 보세요!',
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
            child: const Text('주문하러 가기'),
          ),
        ],
      ),
    );
  }
}
