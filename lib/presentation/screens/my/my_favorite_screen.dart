import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';

class MyFavoriteScreen extends ConsumerWidget {
  const MyFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider)!;
    final favoritesAsync = ref.watch(favoriteProductsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("관심목록"),
        centerTitle: true,
      ),
      body: favoritesAsync.when(
        data: (products) => products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "관심 표시한 글이 없어요.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      "우리 동네에 올라온 글을 탐색하고",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      "관심표시 해보세요!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.text,
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
    );
  }
}
