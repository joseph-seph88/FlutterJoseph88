import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';

class AutoCompleteItem extends StatelessWidget {
  final String result;
  final VoidCallback onTap;

  const AutoCompleteItem({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
