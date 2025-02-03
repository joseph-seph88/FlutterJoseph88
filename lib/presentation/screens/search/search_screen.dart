import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/product/widgets/product_card.dart';
import 'package:o2/presentation/screens/search/widgets/auto_complete_item.dart';
import 'package:o2/presentation/screens/search/widgets/search_app_bar.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  final List<String> _recentSearches = ['노트북 파우치', '백팩', '샘소나이트', '노트북 마개봉', '미개봉 노트북'];
  List<String> _autoCompleteResults = [];
  bool _isSearching = false;

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

    // 이전 타이머가 있다면 취소
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // 1초 후에 자동완성 결과 표시
    _debounce = Timer(const Duration(seconds: 1), () async {
      if (!mounted) return;

      try {
        // 검색 결과 가져오기
        final results = await ref.read(searchProductsProvider(value).future);

        if (!mounted) return;

        setState(() {
          _isSearching = true;
          // 검색 결과의 제목을 자동완성 결과로 사용
          _autoCompleteResults = results
              .map((product) => product.title)
              .where((title) => title.toLowerCase() != value.toLowerCase())
              .take(5) // 최대 5개까지만 표시
              .toList();
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

  void _onSearch(String value, {bool keepFocus = false}) {
    if (value.isEmpty) return;

    setState(() {
      _query = value;
      _isSearching = false;
      _autoCompleteResults = [];
      if (!_recentSearches.contains(value)) {
        _recentSearches.insert(0, value);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }
    });

    // keepFocus가 false일 때만 포커스 해제
    if (!keepFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchProductsProvider(_query));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        searchController: _searchController,
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
        recentSearches: _recentSearches,
        onSearchSelect: (value) => _onSearch(value, keepFocus: true),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    if (_recentSearches.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '최근 검색',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _recentSearches.clear();
                                });
                              },
                              child: Text(
                                '전체 삭제',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentSearches.length,
                        itemBuilder: (context, index) {
                          final search = _recentSearches[index];
                          return InkWell(
                            onTap: () {
                              _searchController.text = search;
                              _onSearch(search, keepFocus: true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.history,
                                    size: 20,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      search,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.text,
                                          ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () => _removeRecentSearch(search),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
