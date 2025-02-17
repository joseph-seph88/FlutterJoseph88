import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthIconButton extends StatelessWidget {
  const AuthIconButton({
    super.key,
    required this.onPressed,
    required this.iconPath,
  });

  final VoidCallback onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        width: 48,
        height: 48,
      ),
    );
  }
}
