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
  });

  final TextEditingController controller;
  final String fieldName;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final FocusNode? focusNode;

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
        hintText = "Password";
        icon = Icons.lock;
        break;
      case "name":
        hintText = "name";
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
        prefixIcon: Icon(icon),
        suffixIcon: onSuffixIconPressed == null
            ? null
            : IconButton(
                onPressed: onSuffixIconPressed,
                icon: obscureText!
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
      ),
      focusNode: focusNode,
    );
  }
}
