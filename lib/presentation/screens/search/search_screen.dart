import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:o2/core/theme/app_theme.dart';
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
  List<String> _autoCompleteResults = [];
  bool _isSearching = false;

  // TODO: 실제 사용자 ID로 교체해야 합니다.
  final String _userId = 'test_user';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _updateAutoComplete(String value) {
    if (value.isEmpty) {
      setState(() {
        _isSearching = false;
        _autoCompleteResults = [];
      });
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () async {
      if (!mounted) return;

      try {
        final results = await ref.read(searchProductsProvider(value).future);

        if (!mounted) return;

        setState(() {
          _isSearching = true;
          _autoCompleteResults = results.map((product) => product.title).where((title) => title.toLowerCase() != value.toLowerCase()).take(5).toList();
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isSearching = false;
          _autoCompleteResults = [];
        });
      }
    });
  }

  Future<void> _onSearch(String value, {bool keepFocus = false}) async {
    if (value.isEmpty) return;

    setState(() {
      _query = value;
      _isSearching = false;
      _autoCompleteResults = [];
    });

    try {
      await ref.read(saveRecentSearchProvider(_userId))(value);
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
    final recentSearchesAsync = ref.watch(recentSearchesProvider(_userId));

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
            _isSearching = false;
            _autoCompleteResults = [];
          });
        },
      ),
      body: Column(
        children: [
          if (_isSearching && _autoCompleteResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _autoCompleteResults.length,
                itemBuilder: (context, index) {
                  final result = _autoCompleteResults[index];
                  return AutoCompleteItem(
                    result: result,
                    onTap: () {
                      _searchController.text = result;
                      _onSearch(result, keepFocus: true);
                    },
                  );
                },
              ),
            )
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                  onTap: () => context.push('/detail/${product.id}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('에러가 발생했습니다: $error'),
                ),
              ),
            )
          else
            Expanded(
              child: recentSearchesAsync.when(
                data: (recentSearches) => SearchContent(
                  searchController: _searchController,
                  onSearchSelect: (value) => _onSearch(value),
                  recentSearches: recentSearches,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => SearchContent(
                  searchController: _searchController,
                  onSearchSelect: _onSearch,
                  recentSearches: const [],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
