import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';

class RecentSearchItem extends StatelessWidget {
  final String search;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentSearchItem({
    super.key,
    required this.search,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
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
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
