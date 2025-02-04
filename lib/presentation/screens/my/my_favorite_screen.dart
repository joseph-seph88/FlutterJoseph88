import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

class MyFavoriteScreen extends ConsumerWidget {
  const MyFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("관심목록"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "관심 표시한 글이 없어요.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
            ),
            Text(
              "우리 동네에 올라온 글을 탐색하고",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
            ),
            Text(
              "관심표시 해보세요!",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
