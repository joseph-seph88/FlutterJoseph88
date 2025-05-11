import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonImage;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.buttonImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(51),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Image.asset(buttonImage)),
    );
  }
}
