import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double size;

  const ActionButton({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: backgroundColor.withAlpha(80),
              blurRadius: 12,
              offset: Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: Icon(iconData, color: iconColor, size: size * 0.5),
        onPressed: onPressed,
      ),
    );
  }
}
