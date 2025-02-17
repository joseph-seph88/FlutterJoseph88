import 'package:flutter/material.dart';

class ProfileImageAvatar extends StatelessWidget {
  final double? radius;
  final String? imageUrl;

  const ProfileImageAvatar({super.key, this.radius, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: imageUrl != null
          ? NetworkImage(imageUrl!)
          : null,
      child: imageUrl == null
          ? const Icon(Icons.person_outline)
          : null,
    );
  }
}
