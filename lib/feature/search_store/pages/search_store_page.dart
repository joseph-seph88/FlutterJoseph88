import 'package:flutter/material.dart';

class SearchStorePage extends StatelessWidget {
  const SearchStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식당 검색'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 검색 필터 섹션
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // 검색창
                TextField(
                  decoration: InputDecoration(
                    hintText: '식당 이름, 음식 종류 검색',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),

                const SizedBox(height: 16),

                // 필터 카테고리
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('한식'),
                      _buildFilterChip('양식'),
                      _buildFilterChip('중식'),
                      _buildFilterChip('일식'),
                      _buildFilterChip('카페'),
                      _buildFilterChip('분위기 좋은'),
                      _buildFilterChip('가성비'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 정렬 방식 선택
                Row(
                  children: [
                    _buildSortButton('평점순', isSelected: true),
                    _buildSortButton('거리순'),
                    _buildSortButton('리뷰 많은순'),
                  ],
                ),
              ],
            ),
          ),

          // 검색 결과 목록
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 10, // 임시 데이터 개수
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildRestaurantItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: label == '한식', // 예시로 '한식'이 선택된 상태
        onSelected: (selected) {
          // 필터 선택 처리 (Cubit 연동 부분)
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.amber[100],
        checkmarkColor: Colors.amber[800],
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildSortButton(String label, {bool isSelected = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton(
          onPressed: () {
            // 정렬 방식 변경 처리 (Cubit 연동 부분)
          },
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? Colors.amber[50] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: isSelected ? Colors.amber : Colors.grey[300]!,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber[800] : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantItem() {
    return InkWell(
      onTap: () {
        // 식당 상세 페이지로 이동 (Cubit 연동 부분)
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 식당 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),

            // 식당 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '맛있는 식당',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '한식 • 서울시 강남구',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.access_time, color: Colors.grey, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '10:00 - 22:00',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.location_on, color: Colors.grey, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '500m',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTagChip('조용한'),
                      _buildTagChip('주차가능'),
                      _buildTagChip('단체석'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
