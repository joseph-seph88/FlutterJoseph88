import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';
import 'package:o2/presentation/screens/product/widgets/home_app_bar.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      body: productsAsync.when(
        data: (products) => products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '등록된 상품이 없습니다',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.push('/detail/${product.id}'),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('에러가 발생했습니다: $error'),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: AppStyles.largeSpacing),
        child: FloatingActionButton.extended(
          heroTag: 'productListFab',
          onPressed: () => context.push('/write'),
          backgroundColor: theme.colorScheme.primary,
          label: Row(
            children: [
              const Icon(
                Icons.add,
                color: AppColors.surface,
              ),
              const SizedBox(width: AppStyles.smallSpacing),
              Text(
                '글쓰기',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.surface,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
