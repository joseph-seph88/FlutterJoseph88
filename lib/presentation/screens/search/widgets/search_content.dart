import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/product_provider.dart';
import 'package:o2/presentation/screens/search/widgets/search_suggestion_button.dart';
import 'package:o2/presentation/screens/search/widgets/recent_search_item.dart';

class SearchContent extends ConsumerWidget {
  final TextEditingController searchController;
  final Function(String) onSearchSelect;
  final List<String> recentSearches;
  final String? userId;

  const SearchContent({
    super.key,
    required this.searchController,
    required this.onSearchSelect,
    required this.recentSearches,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSuggestedSearches(ref),
          if (recentSearches.isNotEmpty) ...[
            _buildRecentSearchesHeader(context, ref, userId),
            _buildRecentSearchesList(context, ref, userId),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedSearches(WidgetRef ref) {
    final popularSearchesAsync = ref.watch(popularSearchesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('추천 검색'),
        popularSearchesAsync.when(
          data: (popularSearches) => _buildSuggestedSearchList(popularSearches),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSuggestedSearchList(List<String> popularSearches) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          for (final search in popularSearches.take(5)) ...[
            if (search != popularSearches.first) const SizedBox(width: 8),
            SearchSuggestionButton(
              label: search,
              onTap: () => _onSearchItemTap(search),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentSearchesHeader(
      BuildContext context, WidgetRef ref, String? userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '최근 검색어',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
          ),
          if (userId != null)
            TextButton(
              onPressed: () => _onClearAllRecentSearches(ref, userId),
              child: Text(
                '전체 삭제',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesList(
      BuildContext context, WidgetRef ref, String? userId) {
    // 중복 제거
    final uniqueSearches = recentSearches.toSet().take(5).toList();

    return Column(
      children: [
        for (final search in uniqueSearches)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RecentSearchItem(
              label: search,
              onTap: () => _onSearchItemTap(search),
              onDelete: () => _onDeleteRecentSearch(ref, userId, search),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  void _onSearchItemTap(String search) {
    searchController.text = search;
    onSearchSelect(search);
  }

  Future<void> _onClearAllRecentSearches(WidgetRef ref, String? userId) async {
    if (userId == null) return;

    try {
      await ref.read(clearRecentSearchesProvider(userId))();
    } catch (e) {
      debugPrint('최근 검색어 전체 삭제 실패: $e');
    }
  }

  Future<void> _onDeleteRecentSearch(
      WidgetRef ref, String? userId, String search) async {
    if (userId == null) return;

    try {
      await ref.read(removeRecentSearchProvider(userId))(search);
    } catch (e) {
      debugPrint('최근 검색어 삭제 실패: $e');
    }
  }
}
