import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchProductsProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '검색어를 입력하세요',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: searchResultsAsync.when(
        data: (products) {
          if (_query.isEmpty) {
            return const Center(child: Text('검색어를 입력해주세요'));
          }

          if (products.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다'));
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
      ),
    );
  }
}
