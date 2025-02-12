import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';
import 'package:o2/presentation/screens/search/widgets/auto_complete_item.dart';
import 'package:o2/presentation/screens/search/widgets/search_app_bar.dart';
import 'package:o2/presentation/screens/search/widgets/search_content.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _isSearchMode = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _updateAutoComplete(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    setState(() {
      _isSearchMode = value.isNotEmpty;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        // 실제 검색은 하지 않고 입력 모드만 변경
        _isSearchMode = value.isNotEmpty;
      });
    });
  }

  Future<void> _onSearch(String value, {bool keepFocus = false}) async {
    if (value.isEmpty) return;

    final user = ref.read(authProvider);
    if (user == null) return;

    setState(() {
      _query = value;
      _isSearchMode = false;
    });

    try {
      await ref.read(saveRecentSearchProvider(user.id))(value);
      await ref.read(incrementSearchCountProvider)(value);
    } catch (e) {
      debugPrint('검색어 저장 실패: $e');
    }

    if (!mounted) return;

    if (!keepFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchProductsProvider(_query));
    final autoCompleteAsync =
        ref.watch(autoCompleteProvider(_searchController.text));
    final user = ref.watch(authProvider);
    final recentSearchesAsync = user != null
        ? ref.watch(recentSearchesProvider(user.id))
        : const AsyncValue.data(<String>[]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        controller: _searchController,
        onChanged: _updateAutoComplete,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _onSearch(value);
          }
        },
        onClear: () {
          _searchController.clear();
          setState(() {
            _query = '';
            _isSearchMode = false;
          });
        },
      ),
      body: Column(
        children: [
          // 자동완성 결과
          if (_isSearchMode)
            autoCompleteAsync.when(
              data: (suggestions) => Container(
                color: Colors.white,
                child: Column(
                  children: [
                    for (final suggestion in suggestions)
                      AutoCompleteItem(
                        result: suggestion,
                        onTap: () {
                          _searchController.text = suggestion;
                          _onSearch(suggestion, keepFocus: true);
                        },
                      ),
                  ],
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            )
          // 검색 결과
          else if (_query.isNotEmpty)
            Expanded(
              child: searchResultsAsync.when(
                data: (products) => products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '검색 결과가 없습니다',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              '"$_query" 검색 결과 ${products.length}개',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.divider),
                          Expanded(
                            child: ListView.separated(
                              itemCount: products.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                color: AppColors.divider,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () =>
                                      context.push('/detail/${product.id}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (error, stack) => Center(
                  child: Text('에러가 발생했습니다: $error'),
                ),
              ),
            )
          // 기본 화면 (최근 검색어 등)
          else
            Expanded(
              child: recentSearchesAsync.when(
                data: (recentSearches) => SearchContent(
                  searchController: _searchController,
                  onSearchSelect: (value) => _onSearch(value),
                  recentSearches: recentSearches,
                  userId: user?.id,
                ),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (_, __) => SearchContent(
                  searchController: _searchController,
                  onSearchSelect: _onSearch,
                  recentSearches: const [],
                  userId: user?.id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
