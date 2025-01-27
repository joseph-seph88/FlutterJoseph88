import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/data/dummy/dummy_products.dart';
import 'package:o2/presentation/screens/product/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  int _selectedTabIndex = 0;

  final _tabs = ['통합', '중고거래', '동네업체'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                  },
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: '노트북 백팩',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.defaultSpacing,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              if (_isSearching)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                ),
            ],
          ),
        ),
        actions: [
          if (_isSearching)
            TextButton(
              onPressed: () {},
              child: Text(
                '알림 받기',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: _isSearching ? _buildSearchResults(theme) : _buildInitialContent(theme),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리 탭
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: AppStyles.defaultPadding.copyWith(
            top: AppStyles.smallSpacing,
            bottom: AppStyles.smallSpacing,
          ),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = index == _selectedTabIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(tab),
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  backgroundColor: isSelected ? AppColors.text : AppColors.surface,
                  side: BorderSide(
                    color: isSelected ? AppColors.text : AppColors.divider,
                  ),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected ? AppColors.surface : AppColors.text,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1),
        // 검색 결과
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: dummyProducts.length,
            itemBuilder: (context, index) {
              final product = dummyProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInitialContent(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 추천 검색
          Padding(
            padding: AppStyles.defaultPadding,
            child: Text(
              '추천 검색',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: AppStyles.defaultPadding.copyWith(top: 0),
            child: Row(
              children: [
                '노트북 미개봉',
                '미개봉 노트북',
                'lg노트북',
                '태블릿 미개봉',
                '탭s6',
              ].map((keyword) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(keyword),
                    onPressed: () {
                      _searchController.text = keyword;
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.divider),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // 최근 검색
          Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    '전체 삭제',
                    style: theme.textTheme.labelLarge?.copyWith(
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
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: const Text('노트북'),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {},
                ),
                onTap: () {
                  _searchController.text = '노트북';
                  setState(() {
                    _isSearching = true;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
