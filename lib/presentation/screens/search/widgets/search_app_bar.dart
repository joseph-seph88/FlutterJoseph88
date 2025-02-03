import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/screens/search/widgets/category_button.dart';
import 'package:o2/presentation/screens/search/widgets/custom_search_bar.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final List<String> recentSearches;
  final ValueChanged<String> onSearchSelect;

  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.recentSearches,
    required this.onSearchSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 64,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: CustomSearchBar(
          controller: searchController,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onClear: onClear,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 4,
              ),
              child: Text(
                '추천 검색',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                children: [
                  for (final search in recentSearches.take(5)) ...[
                    if (search != recentSearches.first) const SizedBox(width: 8),
                    CategoryButton(
                      label: search,
                      onTap: () {
                        searchController.text = search;
                        onSearchSelect(search);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(124);
}
