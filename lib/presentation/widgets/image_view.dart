import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewWidget extends StatelessWidget {
  const ImageViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = (GoRouterState.of(context).extra as Map)['url'];
    if (imageUrl == null) return Container(color: Colors.black);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained * 0.8,
      ),
    );
  }
}
