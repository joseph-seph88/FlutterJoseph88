import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';

class MySalesHistoryScreen extends ConsumerStatefulWidget {
  const MySalesHistoryScreen({super.key});

  @override
  ConsumerState<MySalesHistoryScreen> createState() =>
      _MySalesHistoryScreenState();
}

class _MySalesHistoryScreenState extends ConsumerState<MySalesHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: AppStyles.defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "나의 판매내역",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppStyles.smallSpacing),
                    OutlinedButton(
                      onPressed: () => context.push('/write'),
                      child: Text(
                        "글쓰기",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person_outline),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "판매중"),
              Tab(text: "거래완료"),
              Tab(text: "숨김"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: Text(
                    "판매중인 게시글이 없어요.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "거래완료된 게시글이 없어요.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "숨기기한 게시글이 없어요.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
