import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthText extends StatelessWidget {
  const AuthText({super.key, required this.fieldName});

  final String fieldName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String text = "";

    switch (fieldName) {
      case "email":
        text = "Email *";
        break;
      case "password":
        text = "비밀번호 *";
        break;
      case "passwordConfirm":
        text = "비밀번호 확인 *";
        break;
      case "name":
        text = "이름 *";
        break;
    }

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
