import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
            autofocus: true,
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
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '담기',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                ].map((keyword) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(keyword),
                      onPressed: () {},
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
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
