import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

class MyPurchaseHistoryScreen extends ConsumerWidget {
  const MyPurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("나의 구매내역"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "구매 내역이 없어요.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.text,
              ),
            ),
            Text(
              "동네 이웃과 따뜻한 거래를 해보세요.",
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
