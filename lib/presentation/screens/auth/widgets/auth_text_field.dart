import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.fieldName,
    this.keyboardType,
    this.obscureText,
    this.onSuffixIconPressed,
    this.focusNode,
    this.errorText,
  });

  final TextEditingController controller;
  final String fieldName;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final FocusNode? focusNode;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String hintText = "";
    IconData? icon;

    switch (fieldName) {
      case "email":
        hintText = "Email을 입력해 주세요.";
        icon = Icons.people_alt;
        break;
      case "password":
        hintText = "비밀번호를 입력해주세요.";
        icon = Icons.lock;
        break;
      case "passwordConfirm":
        hintText = "비밀번호를 다시 입력해주세요.";
        icon = Icons.lock;
        break;
      case "name":
        hintText = "이름을 입력해주세요.";
        icon = Icons.person;
        break;
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.text),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        errorText: errorText,
        prefixIcon: Icon(icon),
        suffixIcon: onSuffixIconPressed == null
            ? null
            : IconButton(
                onPressed: onSuffixIconPressed,
                icon: obscureText!
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
      ),
      focusNode: focusNode,
    );
  }
}
