import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_login/core/app_style/app_theme.dart';
import 'package:project_login/core/constants/app_constant.dart';

class HomePage extends StatelessWidget {
  final _searchController = SearchController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildAddressBar(),
          _buildSearchBar(),
          // _buildBannerSection(),
          // _buildCategorySection(),
          // _buildRestaurantListSection(),
          // 메인 배너 광고
          SliverToBoxAdapter(child: _buildMainBanner(context)),

          // const SizedBox(height: 20),

          // 카테고리 아이콘 메뉴
          SliverToBoxAdapter(child: _buildCategoryMenu()),

          // const SizedBox(height: 20),

          // 할인 쿠폰 섹션
          SliverToBoxAdapter(child: _buildCouponSection()),

          // const SizedBox(height: 20),

          // 오늘의 추천 음식
          SliverToBoxAdapter(child: _buildRecommendedFoodSection()),

          // const SizedBox(height: 20),

          // 인기 식당 섹션
          SliverToBoxAdapter(child: _buildPopularRestaurantSection()),

          // const SizedBox(height: 20),

          // 이벤트 배너
          SliverToBoxAdapter(child: _buildEventBanner()),

          // const SizedBox(height: 20),

          // 리뷰 이벤트 섹션
          SliverToBoxAdapter(child: _buildReviewEventSection()),

          // const SizedBox(height: 20),
        ],
      )),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      floating: true,
      pinned: false,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            '오먹',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppTheme.textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: AppTheme.textColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
            // SizedBox(: 8),
            Expanded(
              child: Text(
                '서울특별시 강남구 테헤란로',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppTheme.textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '음식점이나 음식을 검색해보세요',
            hintStyle: TextStyle(color: AppTheme.greyColor, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: AppTheme.greyColor),
            filled: true,
            fillColor: AppTheme.backgroundColor,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(vertical: 16),
        child: PageView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: [
                  AppTheme.primaryColor.withOpacity(0.7),
                  Colors.blue.withOpacity(0.7),
                  Colors.green.withOpacity(0.7),
                ][index],
              ),
              child: Center(
                child: Text(
                  ['신규 회원 할인 쿠폰', '배달비 무료 이벤트', '첫 주문 50% 할인'][index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildCategorySection() {
  //   return SliverToBoxAdapter(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             '음식 카테고리',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         Container(
  //           height: 100,
  //           child: state.isLoading
  //               ? Center(child: CircularProgressIndicator())
  //               : ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   padding: EdgeInsets.symmetric(horizontal: 10),
  //                   itemCount: state.categories.length,
  //                   itemBuilder: (context, index) {
  //                     final category = state.categories[index];
  //                     final isSelected = state.selectedCategoryId == category.id;
  //                     return FoodCategoryCard(
  //                       category: category,
  //                       isSelected: isSelected,
  //                       onTap: () {
  //                         if (isSelected) {
  //                           context.read<FoodCubit>().clearCategoryFilter();
  //                         } else {
  //                           context.read<FoodCubit>().selectCategory(category.id);
  //                         }
  //                       },
  //                     );
  //                   },
  //                 ),
  //         ),
  //         SizedBox(height: 16),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRestaurantListSection() {
  //   final filteredRestaurants = state.selectedCategoryId != null
  //       ? state.restaurants
  //           .where((r) => r.categoryIds.contains(state.selectedCategoryId))
  //           .toList()
  //       : state.restaurants;

  //   return SliverPadding(
  //     padding: EdgeInsets.symmetric(horizontal: 16),
  //     sliver: SliverToBoxAdapter(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 state.selectedCategoryId != null
  //                     ? '${state.categories.firstWhere((c) => c.id == state.selectedCategoryId).name} 맛집'
  //                     : '인기 맛집',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () {},
  //                 child: Text(
  //                   '더보기',
  //                   style: TextStyle(color: AppTheme.primaryColor),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 8),
  //           state.isLoading
  //               ? Center(
  //                   child: Padding(
  //                     padding: EdgeInsets.all(32.0),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 )
  //               : filteredRestaurants.isEmpty
  //                   ? Center(
  //                       child: Padding(
  //                         padding: EdgeInsets.all(32.0),
  //                         child: Text('해당하는 음식점이 없습니다.'),
  //                       ),
  //                     )
  //                   : ListView.builder(
  //                       shrinkWrap: true,
  //                       physics: NeverScrollableScrollPhysics(),
  //                       itemCount: filteredRestaurants.length,
  //                       itemBuilder: (context, index) {
  //                         return RestaurantCard(
  //                           restaurant: filteredRestaurants[index],
  //                         );
  //                       },
  //                     ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // 메인 배너 광고
  Widget _buildMainBanner(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMainBannerForm(
            context,
            Colors.amber[100],
            "신규 오픈 레스토랑\n최대 30% 할인",
            Icons.restaurant,
            Colors.amber[800],
          ),
          _buildMainBannerForm(
            context,
            Colors.green[100],
            "신규스 50%",
            Icons.restaurant,
            Colors.green[800],
          ),
          _buildMainBannerForm(
            context,
            Colors.blue[100],
            "오로 20%",
            Icons.restaurant,
            Colors.blue[800],
          ),
        ],
      ),
    );
  }

  Widget _buildMainBannerForm(BuildContext context, Color? backgroundColor,
      String content, IconData? icon, Color? contentColor) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/banner_placeholder.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 48, color: contentColor),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '1/3',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리 메뉴
  Widget _buildCategoryMenu() {
    final categories = [
      {'icon': Icons.local_dining, 'name': '한식'},
      {'icon': Icons.local_pizza, 'name': '양식'},
      {'icon': Icons.ramen_dining, 'name': '일식'},
      {'icon': Icons.rice_bowl, 'name': '중식'},
      {'icon': Icons.coffee, 'name': '카페'},
      {'icon': Icons.local_bar, 'name': '술집'},
      {'icon': Icons.cake, 'name': '디저트'},
      {'icon': Icons.more_horiz, 'name': '더보기'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: List.generate(
              4,
              (index) => _buildCategoryItem(
                categories[index]['icon'] as IconData,
                categories[index]['name'] as String,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(
              4,
              (index) => _buildCategoryItem(
                categories[index + 4]['icon'] as IconData,
                categories[index + 4]['name'] as String,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String name) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // 카테고리 선택 로직 (Cubit 연동 부분)
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.amber[800],
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(name),
          ],
        ),
      ),
    );
  }

  // 할인 쿠폰 섹션
  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 할인 쿠폰',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCouponCard('첫 주문 할인', '3,000원', Colors.blue[700]!),
                const SizedBox(width: 12),
                _buildCouponCard('신규 가입 축하', '5,000원', Colors.purple[700]!),
                const SizedBox(width: 12),
                _buildCouponCard('오늘만 특가', '2,000원', Colors.green[700]!),
                const SizedBox(width: 12),
                _buildCouponCard('생일 축하', '10,000원', Colors.pink[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(String title, String amount, Color color) {
    return Container(
      width: 150,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(175)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '지금 받기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  Widget _buildRecommendedFoodSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '오늘의 추천 음식',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 전체보기 로직 (Cubit 연동 부분)
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: const Text('전체보기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          // child:
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFoodCard('맛있는 김치찌개', '한식당', '8,000원', 4.8),
                const SizedBox(width: 16),
                _buildFoodCard('스테이크 정식', '양식당', '18,000원', 4.5),
                const SizedBox(width: 16),
                _buildFoodCard('모듬 초밥', '일식당', '15,000원', 4.7),
                const SizedBox(width: 16),
                _buildFoodCard('마라탕', '중식당', '12,000원', 4.6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(
      String name, String restaurant, String price, double rating) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 음식 이미지
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(Icons.restaurant, size: 40, color: Colors.grey[400]),
            ),
          ),

          // 음식 정보
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber[800]),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 인기 식당 섹션
  Widget _buildPopularRestaurantSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '내 주변 인기 식당',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'HOT',
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // 전체보기 로직 (Cubit 연동 부분)
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: const Text('전체보기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final restaurants = [
                {
                  'name': '맛있는 한식당',
                  'type': '한식',
                  'distance': '0.3km',
                  'rating': 4.8,
                  'reviews': 128
                },
                {
                  'name': '신선한 해산물',
                  'type': '일식',
                  'distance': '0.5km',
                  'rating': 4.9,
                  'reviews': 254
                },
                {
                  'name': '분위기 좋은 양식당',
                  'type': '양식',
                  'distance': '0.7km',
                  'rating': 4.7,
                  'reviews': 176
                },
              ];
              return _buildRestaurantItem(
                name: restaurants[index]['name'] as String,
                type: restaurants[index]['type'] as String,
                distance: restaurants[index]['distance'] as String,
                rating: restaurants[index]['rating'] as double,
                reviews: restaurants[index]['reviews'] as int,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantItem({
    required String name,
    required String type,
    required String distance,
    required double rating,
    required int reviews,
  }) {
    return InkWell(
      onTap: () {
        // 식당 상세 페이지로 이동 (Cubit 연동 부분)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 식당 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Icon(Icons.restaurant, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(width: 16),

            // 식당 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        distance,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[800]),
                          const SizedBox(width: 4),
                          Text(
                            '$rating',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '리뷰 $reviews',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 즐겨찾기 버튼
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.grey[400],
              onPressed: () {
                // 즐겨찾기 추가 로직 (Cubit 연동 부분)
              },
            ),
          ],
        ),
      ),
    );
  }

  // 이벤트 배너
  Widget _buildEventBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 100,
          width: double.infinity,
          color: Colors.blue[100],
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/banner_placeholder.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.card_giftcard,
                              size: 36, color: AppTheme.primary),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '친구 초대하고 포인트 받자!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '친구 한 명당 2,000P 적립',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '참여하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 리뷰 이벤트 섹션
  Widget _buildReviewEventSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, color: Colors.purple[700], size: 20),
              const SizedBox(width: 8),
              Text(
                '리뷰 작성하고 포인트 받기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '방문했던 식당의 솔직한 리뷰를 남겨주세요.\n최대 500P를 드립니다!',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.purple[50],
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.purple[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('작성 가능한 리뷰'),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  // 리뷰 작성 페이지로 이동 (Cubit 연동 부분)
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.purple[700],
                  side: BorderSide(color: Colors.purple[700]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('작성하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
