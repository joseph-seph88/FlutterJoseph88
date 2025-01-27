import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

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
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: '인창동 근처에서 검색',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppStyles.defaultSpacing,
                vertical: 8,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: _isSearching ? _buildSearchResults() : _buildInitialContent(theme),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: const Text('미개봉 노트북'),
          onTap: () {},
        );
      },
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
