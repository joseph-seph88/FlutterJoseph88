import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

import '../../../core/theme/app_theme.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("나의 당근"),
        actions: [
          IconButton(
            //TODO : 셋팅 화면 이동
            onPressed: () {},
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.smallSpacing),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.smallSpacing),
              ),
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.all(AppStyles.smallSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              auth.image != null && auth.image!.isNotEmpty
                                  ? NetworkImage(auth.image!)
                                  : null,
                          child: auth.image == null || auth.image!.isEmpty
                              ? const Icon(Icons.person_outline)
                              : null,
                        ),
                        const SizedBox(
                          width: AppStyles.defaultSpacing,
                        ),
                        Text(
                          auth.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(
                          width: AppStyles.defaultSpacing,
                        ),
                        Text(
                          "36.5°C",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.push("/my/profile"),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.smallSpacing),
              ),
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  top: AppStyles.defaultSpacing,
                  bottom: AppStyles.defaultSpacing,
                  left: AppStyles.defaultSpacing,
                  right: AppStyles.smallSpacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "나의 거래",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_border),
                            const SizedBox(width: AppStyles.smallSpacing),
                            Text(
                              "관심목록",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.push("/my/favorite"),
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.library_books),
                            const SizedBox(width: AppStyles.smallSpacing),
                            Text(
                              "판매내역",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.push("/my/salesHistory"),
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shop_outlined),
                            const SizedBox(width: AppStyles.smallSpacing),
                            Text(
                              "구매내역",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.push("/my/purchaseHistory"),
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
