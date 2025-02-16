import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/core/utils/date_util.dart';
import 'package:o2/core/utils/format_utils.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/chat_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  // 동 이름 추출 함수
  String _extractDongName(String fullAddress) {
    final dongMatch =
        RegExp(r'([가-힣]+동|[가-힣]+읍|[가-힣]+면)').firstMatch(fullAddress);
    return dongMatch?.group(1) ?? fullAddress;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = GoRouterState.of(context).pathParameters['id'] ?? '';
      ref.read(productNotifierProvider(id).notifier).incrementViewCount(id);
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final productAsync = ref.watch(productDetailProvider(id));
    final user = ref.watch(authProvider);
    final isFavoriteAsync = user != null
        ? ref.watch(isFavoriteProductProvider((userId: user.id, productId: id)))
        : const AsyncValue.data(false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          if (user != null)
            productAsync.when(
              data: (product) {
                if (product == null || user.id != product.sellerId) {
                  return const SizedBox.shrink();
                }
                return PopupMenuButton(
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '삭제하기',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        final currentContext = context;
                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (!mounted || !currentContext.mounted) return;
                          showModalBottomSheet(
                            context: currentContext,
                            builder: (context) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '정말 삭제하시겠습니까?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final currentContext = context;
                                          Navigator.pop(currentContext);
                                          try {
                                            await ref
                                                .read(
                                                    productNotifierProvider(id)
                                                        .notifier)
                                                .deleteProduct(id);
                                            if (!currentContext.mounted) return;
                                            currentContext.pop();
                                            if (!currentContext.mounted) return;
                                            ScaffoldMessenger.of(currentContext)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text('상품이 삭제되었습니다')),
                                            );
                                          } catch (e) {
                                            if (!currentContext.mounted) return;
                                            ScaffoldMessenger.of(currentContext)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      '상품 삭제 중 오류가 발생했습니다')),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('상품을 찾을 수 없습니다.'));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상품 이미지
                    if (product.images.isNotEmpty)
                      SizedBox(
                        height: 300,
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
                    // 판매자 정보
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final sellerAsync =
                              ref.watch(sellerProvider(product.sellerId));

                          return sellerAsync.when(
                            data: (seller) => Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: seller?.image != null
                                      ? NetworkImage(seller!.image!)
                                      : null,
                                  child: seller?.image == null
                                      ? const Icon(Icons.person_outline)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seller?.name ?? '알 수 없음',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.text,
                                            ),
                                      ),
                                      Text(
                                        _extractDongName(product.locationName),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '36.5°C',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.orange,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.sentiment_satisfied_alt,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '매너온도',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            loading: () => const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.primary,
                            )),
                            error: (error, _) => Center(
                                child: Text('판매자 정보를 불러올 수 없습니다: $error')),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    // 판매자가 자신의 상품일 경우 상태 변경 섹션 추가
                    if (product.sellerId == ref.read(authProvider)?.id) ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: product.status ==
                                            ProductStatus.active
                                        ? null
                                        : () async {
                                            try {
                                              await ref
                                                  .read(productNotifierProvider(
                                                          product.id)
                                                      .notifier)
                                                  .updateStatus(product.id,
                                                      ProductStatus.active);
                                              if (!mounted) return;
                                              _showSnackBar('상태가 변경되었습니다.');
                                            } catch (e) {
                                              if (!mounted) return;
                                              _showSnackBar('상태 변경에 실패했습니다.');
                                            }
                                          },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          product.status == ProductStatus.active
                                              ? AppColors.primary
                                              : null,
                                    ),
                                    child: Text(
                                      ProductStatus.active.label,
                                      style: TextStyle(
                                        color: product.status ==
                                                ProductStatus.active
                                            ? Colors.white
                                            : AppColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: product.status ==
                                            ProductStatus.reserved
                                        ? null
                                        : () async {
                                            try {
                                              await ref
                                                  .read(productNotifierProvider(
                                                          product.id)
                                                      .notifier)
                                                  .updateStatus(product.id,
                                                      ProductStatus.reserved);
                                              if (!mounted) return;
                                              _showSnackBar('상태가 변경되었습니다.');
                                            } catch (e) {
                                              if (!mounted) return;
                                              _showSnackBar('상태 변경에 실패했습니다.');
                                            }
                                          },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: product.status ==
                                              ProductStatus.reserved
                                          ? AppColors.primary
                                          : null,
                                    ),
                                    child: Text(
                                      ProductStatus.reserved.label,
                                      style: TextStyle(
                                        color: product.status ==
                                                ProductStatus.reserved
                                            ? Colors.white
                                            : AppColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: product.status ==
                                            ProductStatus.completed
                                        ? null
                                        : () async {
                                            try {
                                              await ref
                                                  .read(productNotifierProvider(
                                                          product.id)
                                                      .notifier)
                                                  .updateStatus(product.id,
                                                      ProductStatus.completed);
                                              if (!mounted) return;
                                              _showSnackBar('상태가 변경되었습니다.');
                                            } catch (e) {
                                              if (!mounted) return;
                                              _showSnackBar('상태 변경에 실패했습니다.');
                                            }
                                          },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: product.status ==
                                              ProductStatus.completed
                                          ? AppColors.primary
                                          : null,
                                    ),
                                    child: Text(
                                      ProductStatus.completed.label,
                                      style: TextStyle(
                                        color: product.status ==
                                                ProductStatus.completed
                                            ? Colors.white
                                            : AppColors.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                    // 상품 정보
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${product.category} · ${product.createdAt.toElapsedTimeString()}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.text,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '조회 ${product.viewCount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '관심 ${product.favoriteCount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '채팅 ${product.chatCount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // 거래 희망 장소
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '거래희망장소',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.text,
                                    ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Text(
                                      product.locationName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: NaverMap(
                                options: NaverMapViewOptions(
                                  initialCameraPosition: NCameraPosition(
                                    target: NLatLng(
                                        product.latitude, product.longitude),
                                    zoom: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    // 가격
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        product.price.toPrice(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // 하단 버튼
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(productNotifierProvider(id).notifier)
                                .toggleFavorite(user!.id, id);
                          } catch (e) {
                            if (!mounted) return;
                            _showSnackBar('관심상품 등록에 실패했습니다.');
                          }
                        },
                        icon: isFavoriteAsync.when(
                          data: (isFavorite) => Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : AppColors.textSecondary,
                          ),
                          loading: () => const Icon(
                            Icons.favorite_border,
                            color: AppColors.textSecondary,
                          ),
                          error: (_, __) => const Icon(
                            Icons.favorite_border,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              product.price.toPrice(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                            ),
                            if (product.isOfferEnabled)
                              Text(
                                '가격 제안 가능',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onChatButtonClicked(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('채팅하기'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('에러가 발생했습니다: $error'),
        ),
      ),
    );
  }

  void _onChatButtonClicked(Product product) async {
    final userID = ref.read(authProvider)?.id;
    if (userID == null) return;

    final chatRooms = ref.read(chatRoomStreamProvider).value;
    final chatRoom = chatRooms
        ?.firstWhereOrNull((element) => element.productID == product.id);

    if (mounted) {
      context.push('/chat_room', extra: {
        if (chatRoom != null) ...{
          'chatRoomId': chatRoom.id,
        },
        'otherUserId': product.sellerId,
        'productID': product.id,
      });
    }
  }
}
