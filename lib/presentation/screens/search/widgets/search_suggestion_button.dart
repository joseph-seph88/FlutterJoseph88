import 'package:flutter/material.dart';
import 'package:o2/core/theme/app_theme.dart';

class SearchSuggestionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SearchSuggestionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
        ),
      ),
    );
  }
}
