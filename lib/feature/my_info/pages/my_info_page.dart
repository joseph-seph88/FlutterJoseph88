import 'package:flutter/material.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // 설정 페이지로 이동 (Cubit 연동 부분)
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 섹션
            _buildProfileSection(),

            const SizedBox(height: 16),

            // 활동 지표 섹션
            _buildActivityMetrics(),

            const SizedBox(height: 16),

            // 메뉴 섹션
            _buildMenuSection(),

            const SizedBox(height: 16),

            // 나의 리뷰 섹션
            _buildMyReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // 프로필 사진 및 기본 정보
          Row(
            children: [
              // 프로필 이미지
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 20),

              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '김맛집',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'foodlover@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        // 프로필 편집 페이지로 이동 (Cubit 연동 부분)
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Text('프로필 편집'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 사용자 레벨 정보
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '맛집 탐험가 Lv.3',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    Text(
                      '다음 레벨까지 2리뷰',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.amber[400]!),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityMetrics() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          _buildMetricItem('리뷰', '23'),
          _buildDivider(),
          _buildMetricItem('찜한 곳', '45'),
          _buildDivider(),
          _buildMetricItem('방문 기록', '78'),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String count) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuItem('찜한 식당', Icons.favorite_border),
          _buildDividerLine(),
          _buildMenuItem('방문 기록', Icons.history),
          _buildDividerLine(),
          _buildMenuItem('결제 수단 관리', Icons.credit_card),
          _buildDividerLine(),
          _buildMenuItem('나의 쿠폰', Icons.confirmation_number_outlined),
          _buildDividerLine(),
          _buildMenuItem('친구 초대', Icons.person_add_alt_1),
          _buildDividerLine(),
          _buildMenuItem('고객센터', Icons.headset_mic_outlined),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // 각 메뉴 탭 시 처리 (Cubit 연동 부분)
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerLine() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: Colors.grey[200],
    );
  }

  Widget _buildMyReviewsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '나의 리뷰',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 전체 리뷰 보기 페이지로 이동 (Cubit 연동 부분)
                },
                child: Text(
                  '전체보기',
                  style: TextStyle(
                    color: Colors.amber[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewItem(),
          const SizedBox(height: 16),
          _buildReviewItem(),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 식당 정보
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '맛있는 식당',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '한식 • 서울시 강남구',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // 별점
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Icon(Icons.star_half, color: Colors.amber, size: 18),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 리뷰 내용
          const Text(
            '메뉴가 다양하고 맛있어요. 직원분들도 친절하고 분위기도 좋아 자주 방문하게 되는 곳입니다. 특히 김치찌개와 된장찌개가 맛있어요!',
            style: TextStyle(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // 리뷰 이미지들
          Row(
            children: [
              _buildReviewImage(),
              const SizedBox(width: 8),
              _buildReviewImage(),
              const SizedBox(width: 8),
              _buildReviewImage(),
            ],
          ),

          const SizedBox(height: 12),

          // 리뷰 작성일 및 액션 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2024.05.01',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // 리뷰 수정 처리 (Cubit 연동 부분)
                    },
                    icon: Icon(Icons.edit_outlined,
                        size: 16, color: Colors.grey[600]),
                    label: Text(
                      '수정',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // 리뷰 삭제 처리 (Cubit 연동 부분)
                    },
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: Colors.grey[600]),
                    label: Text(
                      '삭제',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      ),
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';


// class MyPageScreen extends StatelessWidget {
//   const MyPageScreen({Key? key}) : super(key: key);

//   // @override
//   // Widget build(BuildContext context) {
//   //   return BlocProvider(
//   //     create: (_) => ProfileCubit(),
//   //     child: Scaffold(
//   //       backgroundColor: AppColors.background,
//   //       body: BlocBuilder<ProfileCubit, ProfileState>(
//   //         builder: (context, state) {
//   //           if (state is ProfileLoading) {
//   //             return _buildLoadingState();
//   //           } else if (state is ProfileLoaded) {
//   //             return _buildLoadedState(context, state.profile);
//   //           } else if (state is ProfileError) {
//   //             return _buildErrorState(context, state.message);
//   //           }
//   //           return const Center(child: CircularProgressIndicator());
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }

//     @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:
//             //  _buildLoadingState()
//              _buildLoadedState(context));
//               // _buildErrorState(context, state.message);

//   }

//   // Widget _buildLoadingState() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             Container(
//               height: 250,
//               color: Colors.white,
//             ),
//             const SizedBox(height: 16),
//             Container(
//               height: 100,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               color: Colors.white,
//             ),
//             const SizedBox(height: 16),
//             Container(
//               height: 200,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               color: Colors.white,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.error_outline,
//             color: AppColors.error,
//             size: 60,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             message,
//             style: const TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               context.read<ProfileCubit>().loadProfile();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: const Text('다시 시도'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadedState(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         // 앱바 및 프로필 헤더
//         SliverAppBar(
//           expandedHeight: 220,
//           pinned: true,
//           // backgroundColor: AppColors.primary,
//           flexibleSpace: FlexibleSpaceBar(
//             background: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   // colors: AppColors.primaryGradient,
//                 ),
//               ),
//               child: SafeArea(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Hero(
//                       tag: 'profile_image',
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 3,
//                           ),
//                         ),
//                         child: ClipOval(
//                           // child: CachedNetworkImage(
//                           //   imageUrl: profile.profileImage,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Container(
//                               color: Colors.grey[300],
//                               child: const Icon(
//                                 Icons.person,
//                                 size: 60,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => const Icon(
//                               Icons.error,
//                               color: Colors.red,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'profile.name',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Text(
//                        ' profile.membershipLevel',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),



//         // 활동 통계
//         SliverToBoxAdapter(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 20,
//             ),
//             decoration: BoxDecoration(
//               // color: AppColors.card,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '나의 푸드 활동',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     // color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatItem(
//                       context,
//                       Icons.restaurant,
//                       '주문',
//                       profile.orderCount.toString(),
//                       AppColors.primary,
//                     ),
//                     _buildStatItem(
//                       context,
//                       Icons.rate_review,
//                       '리뷰',
//                       profile.reviewCount.toString(),
//                       AppColors.accent,
//                     ),
//                     _buildStatItem(
//                       context,
//                       Icons.favorite,
//                       '찜',
//                       profile.favoriteCount.toString(),
//                       AppColors.secondary,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // 포인트 카드
//         SliverToBoxAdapter(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 // colors: AppColors.secondaryGradient,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       '푸디 포인트',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.payment,
//                             size: 16,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(width: 4),
//                           const Text(
//                             '사용하기',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   '100 P',
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   height: 120,
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: const [
//                             FlSpot(0, 3),
//                             FlSpot(1, 1),
//                             FlSpot(2, 4),
//                             FlSpot(3, 2),
//                             FlSpot(4, 5),
//                             FlSpot(5, 3),
//                             FlSpot(6, 4),
//                           ],
//                           isCurved: true,
//                           color: Colors.white,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Colors.white.withOpacity(0.2),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(enabled: false),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // 취향 분석
//         SliverToBoxAdapter(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               // color: AppColors.card,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '내 맛집 취향',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   // children: profile.preferences.map((preference) {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         // color: AppColors.primaryLight,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'preference',
//                         style: const TextStyle(
//                           // color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // 최근 주문
//         SliverToBoxAdapter(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               // color: AppColors.card,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       '최근 주문',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         // color: AppColors.textPrimary,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {

//                       },
//                       child: Row(
//                         children: [
//                           const Text(
//                             '전체보기',
//                             style: TextStyle(
//                               // color: AppColors.primary,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 14,
//                             // color: AppColors.primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // _buildRecentOrderItem(
//                 //   restaurantName: '맛있는 국수집',
//                 //   orderDate: '오늘 · 2시간 전',
//                 //   imageUrl: 'https://placehold.co/400',
//                 //   status: '배달 완료',
//                 //   statusColor: AppColors.success,
//                 // ),
//                 const Divider(height: 24),
//                 // _buildRecentOrderItem(
//                 //   restaurantName: '화덕 피자 & 파스타',
//                 //   orderDate: '어제',
//                 //   imageUrl: 'https://placehold.co/400',
//                 //   status: '배달 완료',
//                 //   statusColor: AppColors.success,
//                 // ),
//               ],
//             ),
//           ),
//         ),

//         // 설정 버튼들
//         SliverToBoxAdapter(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               // color: AppColors.card,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // _buildSettingsItem(
//                 //   icon: Icons.account_circle_outlined,
//                 //   title: '계정 관리',
//                 // ),
//                 const Divider(height: 1),
//               ])))

//                SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final order = state.recentOrders[index];
//                     return _buildOrderItem(context, order);
//                   },
//                   childCount: state.recentOrders.length,
//                 ),
//               ),

//               // 하단 여백
//               const SliverToBoxAdapter(
//                 child: SizedBox(height: 24),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInfoColumn(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 28),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider() {
//     return Container(
//       height: 40,
//       width: 1,
//       color: Colors.grey[300],
//     );
//   }

//   Widget _buildOrderItem(BuildContext context, OrderSummary order) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             // 식당 이미지
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset(
//                 order.restaurantImage,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 16),

//             // 주문 정보
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         order.restaurantName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green[50],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           order.status,
//                           style: TextStyle(
//                             color: Colors.green[700],
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     order.items.join(', '),
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         order.date,
//                         style: TextStyle(
//                           color: Colors.grey[500],
//                           fontSize: 12,
//                         ),
//                       ),
//                       Text(
//                         '${order.totalAmount.toStringAsFixed(0)}원',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }