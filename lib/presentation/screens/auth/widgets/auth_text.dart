import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthText extends StatelessWidget {
  const AuthText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}
