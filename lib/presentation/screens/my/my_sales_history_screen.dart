import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/domain/entities/product.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';

class MySalesHistoryScreen extends ConsumerStatefulWidget {
  const MySalesHistoryScreen({super.key});

  @override
  ConsumerState<MySalesHistoryScreen> createState() =>
      _MySalesHistoryScreenState();
}

class _MySalesHistoryScreenState extends ConsumerState<MySalesHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabStatus = [
    ProductStatus.active,
    ProductStatus.reserved,
    ProductStatus.completed,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider)!;
    final salesAsync = ref.watch(salesProductsProvider(user.id));

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "나의 판매내역",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    OutlinedButton(
                      onPressed: () => context.push('/write'),
                      child: Text(
                        "글쓰기",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.image != null && user.image!.isNotEmpty
                      ? NetworkImage(user.image!)
                      : null,
                  child: user.image == null || user.image!.isEmpty
                      ? const Icon(Icons.person_outline)
                      : null,
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: _tabStatus.map((status) => Tab(text: status.label)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabStatus
                  .map((status) => _buildAsyncContent(salesAsync, status))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsyncContent(
      AsyncValue<List<Product>> salesAsync, ProductStatus status) {
    return salesAsync.when(
      data: (products) => _buildProductList(products, status),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('에러가 발생했습니다: $error'),
      ),
    );
  }

  Widget _buildProductList(List<Product> products, ProductStatus status) {
    final theme = Theme.of(context);
    final filterProducts =
        products.where((product) => product.status == status).toList();
    return filterProducts.isEmpty
        ? Center(
            child: Text(
              _getEmptyMessage(status),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
            ),
          )
        : ListView.separated(
            itemCount: filterProducts.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final product = filterProducts[index];
              return ProductCard(
                product: product,
                onTap: () => context.push('/detail/${product.id}'),
              );
            },
          );
  }

  String _getEmptyMessage(ProductStatus status) {
    switch (status) {
      case ProductStatus.active:
        return "판매중인 게시글이 없어요.";
      case ProductStatus.reserved:
        return "예약중인 게시글이 없어요.";
      case ProductStatus.completed:
        return "거래완료된 게시글이 없어요.";
    }
  }
}
