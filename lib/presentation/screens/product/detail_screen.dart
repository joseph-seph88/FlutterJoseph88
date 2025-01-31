import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/data/dummy/dummy_products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = GoRouterState.of(context).pathParameters['id'];
    final product = dummyProducts.firstWhere((p) => p.id == id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 슬라이더
                  AspectRatio(
                    aspectRatio: 1,
                    child: PageView.builder(
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          product.images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  // 프로필 영역
                  Padding(
                    padding: AppStyles.defaultPadding,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.divider,
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppStyles.defaultSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.sellerId, // TODO: User 모델 추가 후 닉네임으로 변경
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                product.location,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.thermostat_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '36.5°C', // TODO: User 모델 추가 후 실제 매너온도로 변경
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '매너온도',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // 상품 정보
                  Padding(
                    padding: AppStyles.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: AppStyles.smallSpacing),
                        Text(
                          '${product.category} • ${_getTimeAgo(product.createdAt)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppStyles.defaultSpacing),
                        Text(
                          product.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: AppStyles.defaultSpacing),
                        Row(
                          children: [
                            Text(
                              '조회 ${product.viewCount}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppStyles.defaultSpacing),
                            Text(
                              '관심 ${product.likeCount}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 하단 영역
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.divider,
                ),
              ),
            ),
            padding: AppStyles.defaultPadding,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                const SizedBox(width: AppStyles.smallSpacing),
                const VerticalDivider(width: 1),
                const SizedBox(width: AppStyles.smallSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.price.toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},',
                            )}원',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        '가격 제안 불가',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('채팅하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //정건님 코드 합쳐지면 삭제
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}주 전';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}달 전';
    } else {
      return '${(difference.inDays / 365).floor()}년 전';
    }
  }
}
