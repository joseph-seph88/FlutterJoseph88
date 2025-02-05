import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

import '../../../core/theme/app_theme.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final _auth = ref.watch(authProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: AppStyles.defaultSpacing),
                Text(
                  _auth.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  "프로필 수정",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
