import 'package:flutter/material.dart';

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey),
        child: Center(child: Icon(Icons.no_photography)),
      ),
    );
  }
}
