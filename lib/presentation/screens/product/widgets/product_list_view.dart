import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';

class ProductListView extends ConsumerWidget {
  final String? category;

  const ProductListView({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = category != null ? ref.watch(productsByCategoryProvider(category!)) : ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('상품이 없습니다.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/detail/${product.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('에러가 발생했습니다: $error'),
      ),
    );
  }
}
